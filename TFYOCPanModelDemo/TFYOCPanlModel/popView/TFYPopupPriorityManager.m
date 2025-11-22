//
//  TFYPopupPriorityManager.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗优先级管理器实现
//

#import "TFYPopupPriorityManager.h"
#import "TFYPopupView.h"
#import <objc/runtime.h>

// 为了访问 TFYPopupView 的私有方法，需要声明
@interface TFYPopupView ()
+ (NSMutableArray<TFYPopupView *> *)currentPopupViews;
+ (dispatch_queue_t)popupQueue;
@end

#pragma mark - Notification Names

NSNotificationName const TFYPopupPriorityDidChangeNotification = @"TFYPopupPriorityDidChangeNotification";
NSNotificationName const TFYPopupQueueDidUpdateNotification = @"TFYPopupQueueDidUpdateNotification";
NSNotificationName const TFYPopupDidReplaceNotification = @"TFYPopupDidReplaceNotification";

#pragma mark - Global Variables

static BOOL _priorityDebugMode = NO;

#pragma mark - Utility Functions Implementation

BOOL TFYPopupPriorityIsHigher(TFYPopupPriority priority1, TFYPopupPriority priority2) {
    return priority1 > priority2;
}

NSInteger TFYPopupPriorityGetValue(TFYPopupPriority priority) {
    return (NSInteger)priority;
}

TFYPopupPriority TFYPopupPriorityFromValue(NSInteger value) {
    // 限制在有效范围内
    if (value < TFYPopupPriorityBackground) return TFYPopupPriorityBackground;
    if (value > TFYPopupPriorityUrgent) return TFYPopupPriorityUrgent;
    return (TFYPopupPriority)value;
}

#pragma mark - TFYPopupPriorityItem Implementation

@implementation TFYPopupPriorityItem

- (instancetype)initWithPopupView:(TFYPopupView *)popupView
                         priority:(TFYPopupPriority)priority
                         strategy:(TFYPopupPriorityStrategy)strategy
                   maxWaitingTime:(NSTimeInterval)maxWaitingTime
                       completion:(nullable void (^)(void))completion {
    
    self = [super init];
    if (self) {
        _popupView = popupView;
        _priority = priority;
        _strategy = strategy;
        _maxWaitingTime = maxWaitingTime;
        _completionBlock = [completion copy];
        _enqueuedTime = [NSDate date];
    }
    return self;
}

- (BOOL)isExpired {
    if (self.maxWaitingTime <= 0) return NO;
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:self.enqueuedTime];
    return elapsedTime > self.maxWaitingTime;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<TFYPopupPriorityItem: popup=%@, priority=%@, strategy=%@, expired=%@>",
            self.popupView,
            [TFYPopupPriorityManager priorityDescription:self.priority],
            [TFYPopupPriorityManager strategyDescription:self.strategy],
            self.isExpired ? @"YES" : @"NO"];
}

@end

#pragma mark - TFYPopupPriorityManager Implementation

@interface TFYPopupPriorityManager ()

// 当前显示的弹窗 (按优先级排序)
@property (nonatomic, strong) NSMutableArray<TFYPopupView *> *displayedPopups;

// 等待队列 (按优先级排序)
@property (nonatomic, strong) NSMutableArray<TFYPopupPriorityItem *> *internalWaitingQueue;

// 并发队列
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

// 清理定时器
@property (nonatomic, strong, nullable) NSTimer *cleanupTimer;

@end

@implementation TFYPopupPriorityManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static TFYPopupPriorityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TFYPopupPriorityManager alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _displayedPopups = [NSMutableArray array];
        _internalWaitingQueue = [NSMutableArray array];
        _concurrentQueue = dispatch_queue_create("com.tfy.popup.priority.queue", DISPATCH_QUEUE_CONCURRENT);
        
        // 默认配置
        _defaultMaxWaitingTime = 30.0; // 30秒
        _maxSimultaneousPopups = 1; // 改为1，确保优先级效果明显
        _autoCleanupExpiredPopups = YES;
        _isQueuePaused = NO;
        
        [self setupCleanupTimer];
        [self setupNotificationObservers];
    }
    return self;
}

- (void)dealloc {
    [self.cleanupTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupCleanupTimer {
    if (self.autoCleanupExpiredPopups) {
        self.cleanupTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                             target:self
                                                           selector:@selector(periodicCleanup)
                                                           userInfo:nil
                                                            repeats:YES];
    }
}

- (void)setupNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

#pragma mark - Core Management

- (BOOL)addPopup:(TFYPopupView *)popup
        priority:(TFYPopupPriority)priority
        strategy:(TFYPopupPriorityStrategy)strategy
      completion:(nullable void (^)(void))completion {
    
    if (!popup) {
        if (_priorityDebugMode) {
            NSLog(@"TFYPopupPriorityManager: 尝试添加空弹窗");
        }
        return NO;
    }
    
    __block BOOL result = NO;
    
    dispatch_barrier_sync(self.concurrentQueue, ^{
        if (self.isQueuePaused) {
            if (_priorityDebugMode) {
                NSLog(@"TFYPopupPriorityManager: 队列已暂停，拒绝添加弹窗");
            }
            return;
        }
        
        result = [self _addPopupInternal:popup priority:priority strategy:strategy completion:completion];
    });
    
    if (result) {
        [self postQueueUpdateNotification];
    }
    
    return result;
}

- (BOOL)_addPopupInternal:(TFYPopupView *)popup
                 priority:(TFYPopupPriority)priority
                 strategy:(TFYPopupPriorityStrategy)strategy
               completion:(nullable void (^)(void))completion {
    
    if (_priorityDebugMode) {
        NSLog(@"TFYPopupPriorityManager: 添加弹窗 - 优先级:%@, 策略:%@",
              [self.class priorityDescription:priority],
              [self.class strategyDescription:strategy]);
    }
    
    // 检查是否已存在
    if ([self.displayedPopups containsObject:popup]) {
        if (_priorityDebugMode) {
            NSLog(@"TFYPopupPriorityManager: 弹窗已在显示列表中");
        }
        return NO;
    }
    
    // 处理不同策略
    switch (strategy) {
        case TFYPopupPriorityStrategyQueue:
            return [self handleQueueStrategy:popup priority:priority completion:completion];
            
        case TFYPopupPriorityStrategyReplace:
            return [self handleReplaceStrategy:popup priority:priority completion:completion];
            
        case TFYPopupPriorityStrategyOverlay:
            return [self handleOverlayStrategy:popup priority:priority completion:completion];
            
        case TFYPopupPriorityStrategyReject:
            return [self handleRejectStrategy:popup priority:priority completion:completion];
    }
    
    return NO;
}

- (BOOL)handleQueueStrategy:(TFYPopupView *)popup
                   priority:(TFYPopupPriority)priority
                 completion:(nullable void (^)(void))completion {
    
    // 参数检查
    if (!popup) {
        if (_priorityDebugMode) {
            NSLog(@"TFYPopupPriorityManager: handleQueueStrategy - popup为nil");
        }
        return NO;
    }
    
    // 队列策略：严格按优先级排序，高优先级优先显示
    BOOL shouldDisplayImmediately = [self shouldDisplayImmediatelyForPriority:priority];
    
    if (shouldDisplayImmediately) {
        // 检查是否有空间显示，如果没有空间则需要替换低优先级弹窗
        if (self.displayedPopups.count >= self.maxSimultaneousPopups) {
            // 找到最低优先级的弹窗
            TFYPopupView *lowestPriorityPopup = [self findLowestPriorityDisplayedPopup];
            if (lowestPriorityPopup) {
                TFYPopupPriority lowestPriority = [self getPriorityForPopup:lowestPriorityPopup];
                // 只有当新弹窗优先级更高时才替换
                if (TFYPopupPriorityIsHigher(priority, lowestPriority)) {
                    if (_priorityDebugMode) {
                        NSLog(@"TFYPopupPriorityManager: 队列策略替换 - 移除:%@, 显示:%@", 
                              [self.class priorityDescription:lowestPriority],
                              [self.class priorityDescription:priority]);
                    }
                    
                    // 移除低优先级弹窗（队列策略下被替换的弹窗直接dismiss，不重新加入队列）
                    [self moveDisplayedPopupToWaitingQueue:lowestPriorityPopup];
                } else {
                    // 新弹窗优先级不够高，无法替换，加入等待队列
                    shouldDisplayImmediately = NO;
                }
            } else {
                // 找不到最低优先级弹窗，加入等待队列
                shouldDisplayImmediately = NO;
            }
        }
        
        if (shouldDisplayImmediately) {
            // 显示新的高优先级弹窗
            [self displayPopup:popup withPriority:priority completion:completion];
            return YES;
        }
    }
    
    // 添加到等待队列，队列会自动按优先级排序
    TFYPopupPriorityItem *item = [[TFYPopupPriorityItem alloc] initWithPopupView:popup
                                                                        priority:priority
                                                                        strategy:TFYPopupPriorityStrategyQueue
                                                                  maxWaitingTime:self.defaultMaxWaitingTime
                                                                      completion:completion];
    
    if (!item) {
        if (_priorityDebugMode) {
            NSLog(@"TFYPopupPriorityManager: 创建TFYPopupPriorityItem失败");
        }
        return NO;
    }
    
    [self insertItemIntoWaitingQueue:item];
    
    if (_priorityDebugMode) {
        NSLog(@"TFYPopupPriorityManager: 弹窗已加入等待队列，优先级：%@", [self.class priorityDescription:priority]);
    }
    
    // 检查是否需要重新排序显示队列
    [self reorderDisplayQueueIfNeeded];
    
    return YES;
}

- (BOOL)handleReplaceStrategy:(TFYPopupView *)popup
                     priority:(TFYPopupPriority)priority
                   completion:(nullable void (^)(void))completion {
    
    // 查找并替换低优先级弹窗
    NSMutableArray<TFYPopupView *> *toReplace = [NSMutableArray array];
    
    for (TFYPopupView *displayedPopup in self.displayedPopups) {
        TFYPopupPriority displayedPriority = [self getPriorityForPopup:displayedPopup];
        if (TFYPopupPriorityIsHigher(priority, displayedPriority)) {
            [toReplace addObject:displayedPopup];
        }
    }
    
    // 执行替换
    for (TFYPopupView *popupToReplace in toReplace) {
        [self removeDisplayedPopup:popupToReplace];
        [popupToReplace dismissAnimated:YES completion:nil];
        
        [self postReplaceNotificationWithOld:popupToReplace new:popup];
    }
    
    // 显示新弹窗
    if ([self canDisplayImmediately:priority]) {
        [self displayPopup:popup withPriority:priority completion:completion];
        return YES;
    }
    
    return NO;
}

- (BOOL)handleOverlayStrategy:(TFYPopupView *)popup
                     priority:(TFYPopupPriority)priority
                   completion:(nullable void (^)(void))completion {
    
    // 覆盖策略：直接显示，不管当前状态
    [self displayPopup:popup withPriority:priority completion:completion];
    return YES;
}

- (BOOL)handleRejectStrategy:(TFYPopupView *)popup
                    priority:(TFYPopupPriority)priority
                  completion:(nullable void (^)(void))completion {
    
    // 拒绝策略：如果不能立即显示就拒绝
    if ([self canDisplayImmediately:priority]) {
        [self displayPopup:popup withPriority:priority completion:completion];
        return YES;
    }
    
    if (_priorityDebugMode) {
        NSLog(@"TFYPopupPriorityManager: 拒绝显示弹窗 - 无法立即显示");
    }
    
    return NO;
}

- (void)removePopup:(TFYPopupView *)popup {
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self _removePopupInternal:popup];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self processNextPopup];
            [self postQueueUpdateNotification];
        });
    });
}

- (void)_removePopupInternal:(TFYPopupView *)popup {
    if (_priorityDebugMode) {
        NSLog(@"TFYPopupPriorityManager: 移除弹窗");
    }
    
    // 从显示列表中移除
    [self removeDisplayedPopup:popup];
    
    // 从等待队列中移除
    [self removeFromWaitingQueue:popup];
}

- (void)processNextPopup {
    if (self.isQueuePaused) return;
    
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self _processNextPopupInternal];
    });
}

- (void)_processNextPopupInternal {
    // 清理过期项目（同步执行，确保清理完成后再处理）
    [self _clearExpiredWaitingPopupsInternal];
    
    // 按优先级排序等待队列
    [self sortWaitingQueue];
    
    // 处理等待队列中的弹窗，严格按优先级顺序
    while (self.internalWaitingQueue.count > 0) {
        TFYPopupPriorityItem *item = self.internalWaitingQueue.firstObject;
        
        // 检查弹窗是否还有效且未过期
        if (!item.popupView || item.isExpired) {
            [self.internalWaitingQueue removeObjectAtIndex:0];
            continue;
        }
        
        // 检查是否可以显示此弹窗（这些方法在barrier队列中调用，线程安全）
        if ([self shouldDisplayImmediatelyForPriority:item.priority] && [self canDisplayImmediately:item.priority]) {
            [self.internalWaitingQueue removeObjectAtIndex:0];
            
            // 保存completion block的引用，避免在异步执行时丢失
            void (^completionBlock)(void) = item.completionBlock;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self displayPopup:item.popupView withPriority:item.priority completion:completionBlock];
            });
            
            if (_priorityDebugMode) {
                NSLog(@"TFYPopupPriorityManager: 处理等待队列 - 显示弹窗：%@", [self.class priorityDescription:item.priority]);
            }
        } else {
            // 如果最高优先级的弹窗都不能显示，说明需要等待
            break;
        }
    }
}

#pragma mark - Query Methods

- (TFYPopupPriority)currentHighestPriority {
    __block TFYPopupPriority highest = TFYPopupPriorityBackground;
    
    dispatch_sync(self.concurrentQueue, ^{
        for (TFYPopupView *popup in self.displayedPopups) {
            TFYPopupPriority priority = [self getPriorityForPopup:popup];
            if (TFYPopupPriorityIsHigher(priority, highest)) {
                highest = priority;
            }
        }
    });
    
    return highest;
}

- (NSArray<TFYPopupView *> *)popupsWithPriority:(TFYPopupPriority)priority {
    __block NSMutableArray<TFYPopupView *> *result = [NSMutableArray array];
    
    dispatch_sync(self.concurrentQueue, ^{
        for (TFYPopupView *popup in self.displayedPopups) {
            if ([self getPriorityForPopup:popup] == priority) {
                [result addObject:popup];
            }
        }
    });
    
    return [result copy];
}

- (NSArray<TFYPopupView *> *)currentDisplayedPopups {
    __block NSArray<TFYPopupView *> *result = nil;
    
    dispatch_sync(self.concurrentQueue, ^{
        result = [self.displayedPopups copy];
    });
    
    return result;
}

- (NSArray<TFYPopupPriorityItem *> *)waitingQueue {
    __block NSArray<TFYPopupPriorityItem *> *result = nil;
    
    dispatch_sync(self.concurrentQueue, ^{
        result = [self.internalWaitingQueue copy];
    });
    
    return result;
}

- (NSInteger)totalQueueCount {
    __block NSInteger count = 0;
    
    dispatch_sync(self.concurrentQueue, ^{
        count = self.displayedPopups.count + self.internalWaitingQueue.count;
    });
    
    return count;
}

#pragma mark - Management Operations

- (void)clearPopupsWithPriorityLowerThan:(TFYPopupPriority)priority {
    dispatch_barrier_async(self.concurrentQueue, ^{
        NSMutableArray<TFYPopupView *> *toClear = [NSMutableArray array];
        
        for (TFYPopupView *popup in self.displayedPopups) {
            TFYPopupPriority popupPriority = [self getPriorityForPopup:popup];
            if (TFYPopupPriorityIsHigher(priority, popupPriority)) {
                [toClear addObject:popup];
            }
        }
        
        for (TFYPopupView *popup in toClear) {
            [self removeDisplayedPopup:popup];
            dispatch_async(dispatch_get_main_queue(), ^{
                [popup dismissAnimated:YES completion:nil];
            });
        }
        
        // 清理等待队列
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(TFYPopupPriorityItem *item, NSDictionary *bindings) {
            return !TFYPopupPriorityIsHigher(priority, item.priority);
        }];
        [self.internalWaitingQueue filterUsingPredicate:predicate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postQueueUpdateNotification];
        });
    });
}

- (void)clearExpiredWaitingPopups {
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self _clearExpiredWaitingPopupsInternal];
    });
}

/// 内部清理过期弹窗方法（必须在barrier队列中调用）
- (void)_clearExpiredWaitingPopupsInternal {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(TFYPopupPriorityItem *item, NSDictionary *bindings) {
        return !item.isExpired;
    }];
    
    NSUInteger beforeCount = self.internalWaitingQueue.count;
    [self.internalWaitingQueue filterUsingPredicate:predicate];
    NSUInteger afterCount = self.internalWaitingQueue.count;
    
    if (beforeCount != afterCount && _priorityDebugMode) {
        NSLog(@"TFYPopupPriorityManager: 清理了 %lu 个过期等待弹窗", (unsigned long)(beforeCount - afterCount));
    }
}

- (void)pauseQueue {
    dispatch_barrier_async(self.concurrentQueue, ^{
        self->_isQueuePaused = YES;
    });
    
    if (_priorityDebugMode) {
        NSLog(@"TFYPopupPriorityManager: 队列已暂停");
    }
}

- (void)resumeQueue {
    dispatch_barrier_async(self.concurrentQueue, ^{
        self->_isQueuePaused = NO;
    });
    
    [self processNextPopup];
    
    if (_priorityDebugMode) {
        NSLog(@"TFYPopupPriorityManager: 队列已恢复");
    }
}

- (void)clearAllQueues {
    dispatch_barrier_async(self.concurrentQueue, ^{
        NSArray<TFYPopupView *> *displayedCopy = [self.displayedPopups copy];
        [self.displayedPopups removeAllObjects];
        [self.internalWaitingQueue removeAllObjects];
        
        for (TFYPopupView *popup in displayedCopy) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [popup dismissAnimated:YES completion:nil];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postQueueUpdateNotification];
        });
    });
    
    if (_priorityDebugMode) {
        NSLog(@"TFYPopupPriorityManager: 已清空所有队列");
    }
}

#pragma mark - Private Helper Methods

- (BOOL)canDisplayImmediately:(TFYPopupPriority)priority {
    return self.displayedPopups.count < self.maxSimultaneousPopups;
}

- (BOOL)shouldDisplayImmediatelyForPriority:(TFYPopupPriority)priority {
    // 如果没有显示任何弹窗，可以立即显示
    if (self.displayedPopups.count == 0) {
        return YES;
    }
    
    // 检查当前显示的弹窗中是否有比当前优先级低的
    for (TFYPopupView *displayedPopup in self.displayedPopups) {
        TFYPopupPriority displayedPriority = [self getPriorityForPopup:displayedPopup];
        if (TFYPopupPriorityIsHigher(priority, displayedPriority)) {
            // 当前优先级比某个已显示的弹窗高，应该立即显示并替换
            if (_priorityDebugMode) {
                NSLog(@"TFYPopupPriorityManager: 发现可替换的低优先级弹窗 - 当前:%@, 显示中:%@", 
                      [self.class priorityDescription:priority], 
                      [self.class priorityDescription:displayedPriority]);
            }
            return YES;
        }
    }
    
    // 如果已达到最大显示数量，且当前优先级不比任何已显示的弹窗高，则不能立即显示
    if (self.displayedPopups.count >= self.maxSimultaneousPopups) {
        return NO;
    }
    
    // 检查等待队列中是否有更高优先级的弹窗
    for (TFYPopupPriorityItem *item in self.internalWaitingQueue) {
        if (TFYPopupPriorityIsHigher(item.priority, priority)) {
            // 有更高优先级的弹窗在等待，当前弹窗不应立即显示
            return NO;
        }
    }
    
    return YES;
}

- (void)reorderDisplayQueueIfNeeded {
    // 检查等待队列中是否有更高优先级的弹窗需要立即显示
    if (self.internalWaitingQueue.count == 0) {
        return;
    }
    
    // 按优先级排序等待队列（确保顺序正确）
    [self sortWaitingQueue];
    
    // 检查是否有空间显示更高优先级的弹窗
    while (self.internalWaitingQueue.count > 0 && self.displayedPopups.count < self.maxSimultaneousPopups) {
        TFYPopupPriorityItem *highestPriorityItem = self.internalWaitingQueue.firstObject;
        
        // 检查弹窗是否还有效
        if (!highestPriorityItem.popupView || highestPriorityItem.isExpired) {
            [self.internalWaitingQueue removeObjectAtIndex:0];
            continue;
        }
        
        // 检查当前显示的弹窗中是否有比等待队列最高优先级低的
        TFYPopupView *lowestPriorityDisplayed = [self findLowestPriorityDisplayedPopup];
        if (lowestPriorityDisplayed) {
            TFYPopupPriority lowestDisplayedPriority = [self getPriorityForPopup:lowestPriorityDisplayed];
            
            // 如果等待队列中的最高优先级比当前显示的最低优先级高，进行替换
            if (TFYPopupPriorityIsHigher(highestPriorityItem.priority, lowestDisplayedPriority)) {
                [self.internalWaitingQueue removeObjectAtIndex:0];
                
                // 保存completion block引用
                void (^completionBlock)(void) = highestPriorityItem.completionBlock;
                
                // 隐藏低优先级弹窗（但不销毁，重新加入等待队列）
                [self moveDisplayedPopupToWaitingQueue:lowestPriorityDisplayed];
                
                // 显示高优先级弹窗
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayPopup:highestPriorityItem.popupView 
                          withPriority:highestPriorityItem.priority 
                            completion:completionBlock];
                });
                
                if (_priorityDebugMode) {
                    NSLog(@"TFYPopupPriorityManager: 重新排序 - 显示高优先级弹窗：%@", [self.class priorityDescription:highestPriorityItem.priority]);
                }
                
                continue;
            }
        }
        
        // 如果有空间，直接显示
        if (self.displayedPopups.count < self.maxSimultaneousPopups) {
            [self.internalWaitingQueue removeObjectAtIndex:0];
            
            // 保存completion block引用
            void (^completionBlock)(void) = highestPriorityItem.completionBlock;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self displayPopup:highestPriorityItem.popupView 
                      withPriority:highestPriorityItem.priority 
                        completion:completionBlock];
            });
            
            if (_priorityDebugMode) {
                NSLog(@"TFYPopupPriorityManager: 从等待队列显示弹窗：%@", [self.class priorityDescription:highestPriorityItem.priority]);
            }
        } else {
            break;
        }
    }
}

- (TFYPopupView *)findLowestPriorityDisplayedPopup {
    if (self.displayedPopups.count == 0) {
        return nil;
    }
    
    TFYPopupView *lowestPriorityPopup = self.displayedPopups.firstObject;
    TFYPopupPriority lowestPriority = [self getPriorityForPopup:lowestPriorityPopup];
    
    for (TFYPopupView *popup in self.displayedPopups) {
        TFYPopupPriority priority = [self getPriorityForPopup:popup];
        // 修复：应该找优先级最低的，所以当priority < lowestPriority时更新
        if (priority < lowestPriority) {
            lowestPriority = priority;
            lowestPriorityPopup = popup;
        }
    }
    
    return lowestPriorityPopup;
}

- (void)moveDisplayedPopupToWaitingQueue:(TFYPopupView *)popup {
    TFYPopupPriority priority = [self getPriorityForPopup:popup];
    
    // 从显示列表移除
    [self removeDisplayedPopup:popup];
    
    // 从全局弹窗列表中移除
    dispatch_barrier_async([TFYPopupView popupQueue], ^{
        [[TFYPopupView currentPopupViews] removeObject:popup];
    });
    
    // 直接消失弹窗，队列策略下被替换的弹窗不重新加入队列
    dispatch_async(dispatch_get_main_queue(), ^{
        [popup dismissAnimated:YES completion:nil];
    });
    
    if (_priorityDebugMode) {
        NSLog(@"TFYPopupPriorityManager: 移除被替换的弹窗：%@", [self.class priorityDescription:priority]);
    }
}

/// 内部方法：在barrier队列中添加弹窗到显示列表（必须在barrier队列中调用）
- (void)_addDisplayedPopupInternal:(TFYPopupView *)popup withPriority:(TFYPopupPriority)priority {
    [self addDisplayedPopup:popup withPriority:priority];
}

- (void)displayPopup:(TFYPopupView *)popup withPriority:(TFYPopupPriority)priority completion:(nullable void (^)(void))completion {
    // 参数检查
    if (!popup) {
        if (_priorityDebugMode) {
            NSLog(@"TFYPopupPriorityManager: displayPopup - popup为nil");
        }
        if (completion) {
            completion();
        }
        return;
    }
    
    // 关键修复：检查当前是否在barrier队列中
    // 如果在barrier队列中，直接添加到显示列表，然后异步执行UI操作
    // 如果不在barrier队列中，需要先同步添加到显示列表，然后在主线程执行UI操作
    
    // 检查是否在barrier队列中（通过检查当前队列标签）
    // 使用NSString比较，更安全可靠
    NSString *currentQueueLabel = @(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) ?: "");
    NSString *concurrentQueueLabel = @(dispatch_queue_get_label(self.concurrentQueue) ?: "");
    BOOL isInBarrierQueue = [currentQueueLabel isEqualToString:concurrentQueueLabel];
    
    if (isInBarrierQueue) {
        // 在barrier队列中：直接添加到显示列表，避免死锁
        [self _addDisplayedPopupInternal:popup withPriority:priority];
        
        // 异步切换到主线程执行UI操作（注意：这里不使用sync，避免死锁）
        dispatch_async(dispatch_get_main_queue(), ^{
            // 添加到全局弹窗列表中
            dispatch_barrier_async([TFYPopupView popupQueue], ^{
                [[TFYPopupView currentPopupViews] addObject:popup];
            });
            
            if (_priorityDebugMode) {
                NSLog(@"TFYPopupPriorityManager: 显示弹窗 - 优先级:%@", [self.class priorityDescription:priority]);
            }
            
            // 发送优先级变化通知
            [self postPriorityChangeNotification];
            
            // 执行completion block
            if (completion) {
                completion();
            }
        });
    } else {
        // 不在barrier队列中：需要先同步添加到显示列表（确保线程安全）
        // 然后切换到主线程执行UI操作
        dispatch_barrier_sync(self.concurrentQueue, ^{
            [self addDisplayedPopup:popup withPriority:priority];
        });
        
        // 在主线程执行UI相关操作和completion
        dispatch_async(dispatch_get_main_queue(), ^{
            // 添加到全局弹窗列表中
            dispatch_barrier_async([TFYPopupView popupQueue], ^{
                [[TFYPopupView currentPopupViews] addObject:popup];
            });
            
            if (_priorityDebugMode) {
                NSLog(@"TFYPopupPriorityManager: 显示弹窗 - 优先级:%@", [self.class priorityDescription:priority]);
            }
            
            // 发送优先级变化通知
            [self postPriorityChangeNotification];
            
            // 执行completion block
            if (completion) {
                completion();
            }
        });
    }
}

- (void)addDisplayedPopup:(TFYPopupView *)popup withPriority:(TFYPopupPriority)priority {
    if (!popup) {
        if (_priorityDebugMode) {
            NSLog(@"TFYPopupPriorityManager: addDisplayedPopup - popup为nil");
        }
        return;
    }
    
    [self.displayedPopups addObject:popup];
    
    // 使用静态key避免重复创建selector
    static const void *kPriorityKey = &kPriorityKey;
    objc_setAssociatedObject(popup, kPriorityKey, @(priority), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 按优先级排序
    [self.displayedPopups sortUsingComparator:^NSComparisonResult(TFYPopupView *popup1, TFYPopupView *popup2) {
        TFYPopupPriority priority1 = [self getPriorityForPopup:popup1];
        TFYPopupPriority priority2 = [self getPriorityForPopup:popup2];
        
        if (priority1 > priority2) return NSOrderedAscending;
        if (priority1 < priority2) return NSOrderedDescending;
        return NSOrderedSame;
    }];
}

- (void)removeDisplayedPopup:(TFYPopupView *)popup {
    if (!popup) return;
    
    [self.displayedPopups removeObject:popup];
    
    // 使用静态key，与addDisplayedPopup保持一致
    static const void *kPriorityKey = &kPriorityKey;
    objc_setAssociatedObject(popup, kPriorityKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TFYPopupPriority)getPriorityForPopup:(TFYPopupView *)popup {
    if (!popup) {
        return TFYPopupPriorityNormal;
    }
    
    // 使用静态key，与addDisplayedPopup保持一致
    static const void *kPriorityKey = &kPriorityKey;
    NSNumber *priorityNumber = objc_getAssociatedObject(popup, kPriorityKey);
    return priorityNumber ? priorityNumber.integerValue : TFYPopupPriorityNormal;
}

- (void)removeFromWaitingQueue:(TFYPopupView *)popup {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(TFYPopupPriorityItem *item, NSDictionary *bindings) {
        return item.popupView != popup;
    }];
    [self.internalWaitingQueue filterUsingPredicate:predicate];
}

- (void)insertItemIntoWaitingQueue:(TFYPopupPriorityItem *)item {
    // 使用二分查找插入，避免全量排序（优化性能）
    NSUInteger insertIndex = [self findInsertIndexForItem:item];
    [self.internalWaitingQueue insertObject:item atIndex:insertIndex];
}

- (void)sortWaitingQueue {
    [self.internalWaitingQueue sortUsingComparator:^NSComparisonResult(TFYPopupPriorityItem *item1, TFYPopupPriorityItem *item2) {
        // 优先级高的排前面
        if (item1.priority > item2.priority) return NSOrderedAscending;
        if (item1.priority < item2.priority) return NSOrderedDescending;
        
        // 优先级相同时，入队时间早的排前面
        return [item1.enqueuedTime compare:item2.enqueuedTime];
    }];
}

/// 使用二分查找找到插入位置（优化插入性能）
- (NSUInteger)findInsertIndexForItem:(TFYPopupPriorityItem *)newItem {
    if (self.internalWaitingQueue.count == 0) {
        return 0;
    }
    
    // 二分查找：找到第一个优先级 <= newItem.priority 的位置
    NSUInteger left = 0;
    NSUInteger right = self.internalWaitingQueue.count;
    
    while (left < right) {
        NSUInteger mid = (left + right) / 2;
        TFYPopupPriorityItem *midItem = self.internalWaitingQueue[mid];
        
        if (midItem.priority > newItem.priority) {
            left = mid + 1;
        } else if (midItem.priority < newItem.priority) {
            right = mid;
        } else {
            // 优先级相同，按时间排序
            if ([midItem.enqueuedTime compare:newItem.enqueuedTime] == NSOrderedAscending) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
    }
    
    return left;
}

#pragma mark - Notification Methods

- (void)postPriorityChangeNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupPriorityDidChangeNotification object:self];
    });
}

- (void)postQueueUpdateNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupQueueDidUpdateNotification object:self];
    });
}

- (void)postReplaceNotificationWithOld:(TFYPopupView *)oldPopup new:(TFYPopupView *)newPopup {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = @{
            @"oldPopup": oldPopup ?: [NSNull null],
            @"newPopup": newPopup ?: [NSNull null]
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupDidReplaceNotification
                                                            object:self
                                                          userInfo:userInfo];
    });
}

#pragma mark - Timer & Notification Handlers

- (void)periodicCleanup {
    // 在barrier队列中同步清理过期弹窗，然后处理下一个
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self _clearExpiredWaitingPopupsInternal];
        
        // 清理完成后，处理下一个弹窗
        dispatch_async(dispatch_get_main_queue(), ^{
            [self processNextPopup];
        });
    });
}

- (void)handleApplicationDidEnterBackground:(NSNotification *)notification {
    if (_priorityDebugMode) {
        NSLog(@"TFYPopupPriorityManager: 应用进入后台，暂停队列处理");
    }
    [self pauseQueue];
}

- (void)handleMemoryWarning:(NSNotification *)notification {
    if (_priorityDebugMode) {
        NSLog(@"TFYPopupPriorityManager: 收到内存警告，清理低优先级弹窗");
    }
    [self clearPopupsWithPriorityLowerThan:TFYPopupPriorityHigh];
}

#pragma mark - Debugging

+ (void)enablePriorityDebugMode:(BOOL)enabled {
    _priorityDebugMode = enabled;
    NSLog(@"TFYPopupPriorityManager: 优先级调试模式 %@", enabled ? @"已启用" : @"已禁用");
}

+ (BOOL)isPriorityDebugModeEnabled {
    return _priorityDebugMode;
}

- (void)logPriorityQueue {
    dispatch_sync(self.concurrentQueue, ^{
        NSLog(@"=== TFYPopupPriorityManager Debug Info ===");
        NSLog(@"当前显示弹窗数量: %lu", (unsigned long)self.displayedPopups.count);
        NSLog(@"等待队列数量: %lu", (unsigned long)self.internalWaitingQueue.count);
        NSLog(@"队列是否暂停: %@", self.isQueuePaused ? @"是" : @"否");
        NSLog(@"最大同时显示数量: %ld", (long)self.maxSimultaneousPopups);
        
        NSLog(@"--- 当前显示弹窗 ---");
        for (NSInteger i = 0; i < self.displayedPopups.count; i++) {
            TFYPopupView *popup = self.displayedPopups[i];
            TFYPopupPriority priority = [self getPriorityForPopup:popup];
            NSLog(@"[%ld] %@ - 优先级: %@", (long)i, popup.class, [self.class priorityDescription:priority]);
        }
        
        NSLog(@"--- 等待队列 ---");
        for (NSInteger i = 0; i < self.internalWaitingQueue.count; i++) {
            TFYPopupPriorityItem *item = self.internalWaitingQueue[i];
            NSLog(@"[%ld] %@", (long)i, item);
        }
        
        NSLog(@"==========================================");
    });
}

+ (NSString *)priorityDescription:(TFYPopupPriority)priority {
    switch (priority) {
        case TFYPopupPriorityBackground: return @"背景级";
        case TFYPopupPriorityLow: return @"低优先级";
        case TFYPopupPriorityNormal: return @"普通优先级";
        case TFYPopupPriorityHigh: return @"高优先级";
        case TFYPopupPriorityCritical: return @"关键优先级";
        case TFYPopupPriorityUrgent: return @"紧急优先级";
        default: return @"未知优先级";
    }
}

+ (NSString *)strategyDescription:(TFYPopupPriorityStrategy)strategy {
    switch (strategy) {
        case TFYPopupPriorityStrategyQueue: return @"队列等待";
        case TFYPopupPriorityStrategyReplace: return @"替换低优先级";
        case TFYPopupPriorityStrategyOverlay: return @"覆盖显示";
        case TFYPopupPriorityStrategyReject: return @"拒绝显示";
        default: return @"未知策略";
    }
}

@end
