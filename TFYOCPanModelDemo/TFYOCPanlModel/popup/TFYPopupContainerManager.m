//
//  TFYPopupContainerManager.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗容器管理器实现
//

#import "TFYPopupContainerManager.h"

// 定义通知常量
NSNotificationName const TFYPopupContainerDidChangeNotification = @"TFYPopupContainerDidChangeNotification";
NSNotificationName const TFYPopupContainerDidBecomeAvailableNotification = @"TFYPopupContainerDidBecomeAvailableNotification";
NSNotificationName const TFYPopupContainerDidBecomeUnavailableNotification = @"TFYPopupContainerDidBecomeUnavailableNotification";

@interface TFYPopupContainerManager ()

@property (nonatomic, strong) NSMutableArray<TFYPopupContainerInfo *> *discoveredContainers;
@property (nonatomic, strong) NSMutableArray<TFYPopupContainerInfo *> *customContainers;
@property (nonatomic, strong) id<TFYPopupContainerSelector> defaultSelector;
@property (nonatomic, strong) NSTimer *discoveryTimer;
@property (nonatomic, strong) dispatch_queue_t managerQueue;

@end

@implementation TFYPopupContainerManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static TFYPopupContainerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _discoveredContainers = [NSMutableArray array];
        _customContainers = [NSMutableArray array];
        _enableAutoDiscovery = YES;
        _discoveryInterval = 5.0;
        _enableContainerChangeNotifications = YES;
        _enableDebugMode = NO;
        
        _managerQueue = dispatch_queue_create("com.tfy.popup.container.manager", DISPATCH_QUEUE_CONCURRENT);
        
        // 设置默认选择器
        _defaultSelector = [[TFYPopupDefaultContainerSelector alloc] initWithStrategy:TFYPopupContainerSelectionStrategySmart];
        
        // 开始自动发现
        [self startAutoDiscovery];
        
        // 监听应用状态变化
        [self setupApplicationStateObservers];
    }
    return self;
}

- (void)dealloc {
    [self stopAutoDiscovery];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Container Discovery

- (void)discoverAvailableContainersWithCompletion:(TFYPopupContainerDiscoveryCallback)completion {
    dispatch_async(self.managerQueue, ^{
        @try {
            NSMutableArray<TFYPopupContainerInfo *> *containers = [NSMutableArray array];
            
            // 发现UIWindow容器
            NSArray<TFYPopupContainerInfo *> *windowContainers = [self discoverWindowContainers];
            if (windowContainers) {
                [containers addObjectsFromArray:windowContainers];
            }
            
            // 发现UIViewController容器
            NSArray<TFYPopupContainerInfo *> *viewControllerContainers = [self discoverViewControllerContainers];
            if (viewControllerContainers) {
                [containers addObjectsFromArray:viewControllerContainers];
            }
            
            // 发现UIView容器
            NSArray<TFYPopupContainerInfo *> *viewContainers = [self discoverViewContainers];
            if (viewContainers) {
                [containers addObjectsFromArray:viewContainers];
            }
            
            // 添加自定义容器
            if (self.customContainers) {
                [containers addObjectsFromArray:self.customContainers];
            }
            
            // 检查是否找到任何容器
            if (containers.count == 0) {
                NSError *error = [NSError errorWithDomain:@"TFYPopupContainerManager"
                                                     code:1001
                                                 userInfo:@{NSLocalizedDescriptionKey: @"没有发现可用的容器"}];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(@[], error);
                });
                return;
            }
            
            // 更新发现的容器列表
            dispatch_barrier_async(self.managerQueue, ^{
                [self.discoveredContainers removeAllObjects];
                [self.discoveredContainers addObjectsFromArray:containers];
            });
            
            // 发送通知
            if (self.enableContainerChangeNotifications) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupContainerDidChangeNotification
                                                                        object:self
                                                                      userInfo:@{@"containers": [containers copy]}];
                });
            }
            
            // 返回结果
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion([containers copy], nil);
            });
        } @catch (NSException *exception) {
            NSError *error = [NSError errorWithDomain:@"TFYPopupContainerManager"
                                                 code:1002
                                             userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"容器发现异常: %@", exception.reason]}];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(@[], error);
            });
        }
    });
}

- (void)discoverContainersOfType:(TFYPopupContainerType)type
                      completion:(TFYPopupContainerDiscoveryCallback)completion {
    dispatch_async(self.managerQueue, ^{
        NSArray<TFYPopupContainerInfo *> *containers = nil;
        
        switch (type) {
            case TFYPopupContainerTypeWindow:
                containers = [self discoverWindowContainers];
                break;
            case TFYPopupContainerTypeViewController:
                containers = [self discoverViewControllerContainers];
                break;
            case TFYPopupContainerTypeView:
                containers = [self discoverViewContainers];
                break;
            case TFYPopupContainerTypeCustom:
                containers = [self.customContainers copy];
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(containers, nil);
        });
    });
}

- (NSArray<TFYPopupContainerInfo *> *)currentAvailableContainers {
    __block NSArray<TFYPopupContainerInfo *> *containers = nil;
    dispatch_sync(self.managerQueue, ^{
        containers = [self.discoveredContainers copy];
    });
    return containers;
}

- (NSArray<TFYPopupContainerInfo *> *)currentAvailableContainersOfType:(TFYPopupContainerType)type {
    NSArray<TFYPopupContainerInfo *> *allContainers = [self currentAvailableContainers];
    return [allContainers filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat:@"type == %lu", (unsigned long)type]];
}

#pragma mark - Container Management

- (void)registerCustomContainer:(TFYPopupContainerInfo *)containerInfo {
    if (!containerInfo) return;
    
    dispatch_barrier_async(self.managerQueue, ^{
        // 检查是否已存在
        BOOL exists = NO;
        for (TFYPopupContainerInfo *existing in self.customContainers) {
            if (existing.containerView == containerInfo.containerView) {
                exists = YES;
                break;
            }
        }
        
        if (!exists) {
            [self.customContainers addObject:containerInfo];
            
            if (self.enableContainerChangeNotifications) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupContainerDidBecomeAvailableNotification
                                                                        object:self
                                                                      userInfo:@{@"container": containerInfo}];
                });
            }
        }
    });
}

- (void)unregisterCustomContainer:(TFYPopupContainerInfo *)containerInfo {
    if (!containerInfo) return;
    
    dispatch_barrier_async(self.managerQueue, ^{
        [self.customContainers removeObject:containerInfo];
        
        if (self.enableContainerChangeNotifications) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupContainerDidBecomeUnavailableNotification
                                                                    object:self
                                                                  userInfo:@{@"container": containerInfo}];
            });
        }
    });
}

- (BOOL)isContainerAvailable:(TFYPopupContainerInfo *)containerInfo {
    if (!containerInfo) return NO;
    
    // 检查容器视图是否仍然有效
    if (!containerInfo.containerView || !containerInfo.containerView.window) {
        return NO;
    }
    
    // 检查容器是否在发现的列表中
    __block BOOL isDiscovered = NO;
    dispatch_sync(self.managerQueue, ^{
        for (TFYPopupContainerInfo *discovered in self.discoveredContainers) {
            if (discovered.containerView == containerInfo.containerView) {
                isDiscovered = YES;
                break;
            }
        }
    });
    
    return isDiscovered;
}

- (void)refreshContainerStates {
    [self discoverAvailableContainersWithCompletion:^(NSArray<TFYPopupContainerInfo *> *containers, NSError *error) {
        if (self.enableDebugMode) {
            NSLog(@"TFYPopupContainerManager: 刷新容器状态完成，发现 %lu 个容器", (unsigned long)containers.count);
        }
    }];
}

#pragma mark - Container Selection

- (void)setDefaultContainerSelector:(id<TFYPopupContainerSelector>)selector {
    if (selector) {
        _defaultSelector = selector;
    }
}

- (id<TFYPopupContainerSelector>)defaultContainerSelector {
    return _defaultSelector;
}

- (void)selectBestContainerWithCompletion:(TFYPopupContainerSelectionCallback)completion {
    [self selectBestContainerWithSelector:self.defaultSelector completion:completion];
}

- (void)selectBestContainerWithSelector:(id<TFYPopupContainerSelector>)selector
                             completion:(TFYPopupContainerSelectionCallback)completion {
    [self discoverAvailableContainersWithCompletion:^(NSArray<TFYPopupContainerInfo *> *containers, NSError *error) {
        if (error) {
            if (completion) completion(nil, error);
            return;
        }
        
        if (selector) {
            [selector selectContainerFromAvailableContainers:containers completion:completion];
        } else {
            // 使用默认选择器
            [self.defaultSelector selectContainerFromAvailableContainers:containers completion:completion];
        }
    }];
}

#pragma mark - Private Methods

- (NSArray<TFYPopupContainerInfo *> *)discoverWindowContainers {
    NSMutableArray<TFYPopupContainerInfo *> *containers = [NSMutableArray array];
    
    // 确保在主线程执行UI相关操作：若不在主线程，则切到主线程执行并同步返回结果
    if (![NSThread isMainThread]) {
        __block NSArray<TFYPopupContainerInfo *> *result = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            result = [self discoverWindowContainers];
        });
        return result ?: @[];
    }
    
    if (@available(iOS 15.0, *)) {
        // iOS 15+ 使用新的场景API
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (!window.hidden && window.windowLevel >= UIWindowLevelNormal) {
                        TFYPopupContainerInfo *containerInfo = [TFYPopupContainerInfo windowContainer:window];
                        [containers addObject:containerInfo];
                    }
                }
            }
        }

        // 若前台激活场景未发现窗口，则放宽条件：遍历所有场景
        if (containers.count == 0) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                for (UIWindow *window in scene.windows) {
                    if (!window.hidden && window.windowLevel >= UIWindowLevelNormal) {
                        [containers addObject:[TFYPopupContainerInfo windowContainer:window]];
                    }
                }
            }
        }

        // 最后再做一次兜底：找任意一个窗口（即便不是keyWindow），确保至少有一个容器
        if (containers.count == 0) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.windows.firstObject) {
                    [containers addObject:[TFYPopupContainerInfo windowContainer:scene.windows.firstObject]];
                    break;
                }
            }
        }
    }
    return [containers copy];
}

- (NSArray<TFYPopupContainerInfo *> *)discoverViewControllerContainers {
    NSMutableArray<TFYPopupContainerInfo *> *containers = [NSMutableArray array];
    
    // 确保在主线程执行UI相关操作：若不在主线程，则切到主线程执行并同步返回结果
    if (![NSThread isMainThread]) {
        __block NSArray<TFYPopupContainerInfo *> *result = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            result = [self discoverViewControllerContainers];
        });
        return result ?: @[];
    }
    
    // 获取当前窗口
    UIWindow *keyWindow = nil;
    if (@available(iOS 15.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
    }
    // 若未找到keyWindow，放宽条件：遍历所有场景选择第一个可见窗口
    if (!keyWindow) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            for (UIWindow *window in scene.windows) {
                if (!window.hidden && window.windowLevel >= UIWindowLevelNormal) {
                    keyWindow = window;
                    break;
                }
            }
            if (keyWindow) break;
        }
    }
    // 兜底：任意第一个窗口
    if (!keyWindow) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.windows.firstObject) { keyWindow = scene.windows.firstObject; break; }
        }
    }
    if (keyWindow) {
        UIViewController *rootViewController = keyWindow.rootViewController;
        [self addViewControllerContainers:rootViewController toArray:containers];
    }
    
    return [containers copy];
}

- (void)addViewControllerContainers:(UIViewController *)viewController toArray:(NSMutableArray<TFYPopupContainerInfo *> *)containers {
    if (!viewController || !viewController.view) return;
    
    // 确保在主线程执行UI相关操作：若不在主线程，则切到主线程同步执行
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self addViewControllerContainers:viewController toArray:containers];
        });
        return;
    }
    
    // 添加当前视图控制器
    TFYPopupContainerInfo *containerInfo = [TFYPopupContainerInfo viewControllerContainer:viewController];
    [containers addObject:containerInfo];
    
    // 递归添加子视图控制器
    for (UIViewController *child in viewController.childViewControllers) {
        [self addViewControllerContainers:child toArray:containers];
    }
    
    // 添加模态视图控制器
    if (viewController.presentedViewController) {
        [self addViewControllerContainers:viewController.presentedViewController toArray:containers];
    }
}

- (NSArray<TFYPopupContainerInfo *> *)discoverViewContainers {
    NSMutableArray<TFYPopupContainerInfo *> *containers = [NSMutableArray array];
    
    // 确保在主线程执行UI相关操作：若不在主线程，则切到主线程执行并同步返回结果
    if (![NSThread isMainThread]) {
        __block NSArray<TFYPopupContainerInfo *> *result = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            result = [self discoverViewContainers];
        });
        return result ?: @[];
    }
    
    // 获取当前窗口
    UIWindow *keyWindow = nil;
    if (@available(iOS 15.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
    }
    // 若未找到keyWindow，放宽条件：遍历所有场景选择第一个可见窗口
    if (!keyWindow) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            for (UIWindow *window in scene.windows) {
                if (!window.hidden && window.windowLevel >= UIWindowLevelNormal) {
                    keyWindow = window;
                    break;
                }
            }
            if (keyWindow) break;
        }
    }
    // 兜底：任意第一个窗口
    if (!keyWindow) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.windows.firstObject) { keyWindow = scene.windows.firstObject; break; }
        }
    }
    if (keyWindow) {
        [self addViewContainers:keyWindow toArray:containers];
    }
    
    return [containers copy];
}

- (void)addViewContainers:(UIView *)view toArray:(NSMutableArray<TFYPopupContainerInfo *> *)containers {
    if (!view) return;
    
    // 确保在主线程执行UI相关操作：若不在主线程，则切到主线程同步执行
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self addViewContainers:view toArray:containers];
        });
        return;
    }
    
    // 添加当前视图（如果足够大且可见）
    if (view.bounds.size.width > 100 && view.bounds.size.height > 100 && !view.hidden) {
        NSString *name = [NSString stringWithFormat:@"View_%p_%@", view, NSStringFromClass([view class])];
        TFYPopupContainerInfo *containerInfo = [TFYPopupContainerInfo viewContainer:view name:name];
        [containers addObject:containerInfo];
    }
    
    // 递归添加子视图
    for (UIView *subview in view.subviews) {
        [self addViewContainers:subview toArray:containers];
    }
}

- (void)startAutoDiscovery {
    if (self.enableAutoDiscovery && !self.discoveryTimer) {
        // 确保在主线程创建并加入运行循环的常用模式，避免滚动等情况下暂停
        dispatch_async(dispatch_get_main_queue(), ^{
            self.discoveryTimer = [NSTimer timerWithTimeInterval:self.discoveryInterval
                                                          target:self
                                                        selector:@selector(discoveryTimerFired)
                                                        userInfo:nil
                                                         repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.discoveryTimer forMode:NSRunLoopCommonModes];
        });
    }
}

- (void)stopAutoDiscovery {
    if (self.discoveryTimer) {
        // 停止计时器并从运行循环移除
        [self.discoveryTimer invalidate];
        self.discoveryTimer = nil;
    }
}

- (void)discoveryTimerFired {
    [self refreshContainerStates];
}

- (void)setupApplicationStateObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self startAutoDiscovery];
    [self refreshContainerStates];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    // 应用进入后台时暂停自动发现
    [self stopAutoDiscovery];
}

#pragma mark - Utility Methods

+ (NSString *)descriptionForContainerType:(TFYPopupContainerType)type {
    switch (type) {
        case TFYPopupContainerTypeWindow:
            return @"UIWindow";
        case TFYPopupContainerTypeView:
            return @"UIView";
        case TFYPopupContainerTypeViewController:
            return @"UIViewController";
        case TFYPopupContainerTypeCustom:
            return @"Custom";
    }
}

+ (NSString *)descriptionForSelectionStrategy:(TFYPopupContainerSelectionStrategy)strategy {
    switch (strategy) {
        case TFYPopupContainerSelectionStrategyAuto:
            return @"Auto";
        case TFYPopupContainerSelectionStrategyManual:
            return @"Manual";
        case TFYPopupContainerSelectionStrategySmart:
            return @"Smart";
        case TFYPopupContainerSelectionStrategyCustom:
            return @"Custom";
    }
}

- (void)logCurrentContainerStates {
    NSArray<TFYPopupContainerInfo *> *containers = [self currentAvailableContainers];
    
    NSLog(@"=== TFYPopupContainerManager 当前容器状态 ===");
    NSLog(@"总容器数量: %lu", (unsigned long)containers.count);
    
    for (TFYPopupContainerInfo *container in containers) {
        NSLog(@"- %@ (%@): %@ - 可用: %@", 
              container.name,
              [self.class descriptionForContainerType:container.type],
              container.containerDescription,
              container.isAvailable ? @"是" : @"否");
    }
    NSLog(@"==========================================");
}

@end

#pragma mark - Convenience Functions

TFYPopupContainerInfo * TFYPopupGetCurrentWindowContainer(void) {
    UIWindow *window = nil;
    if (@available(iOS 15.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *w in scene.windows) {
                    if (w.isKeyWindow) {
                        window = w;
                        break;
                    }
                }
            }
        }
    }
    return window ? [TFYPopupContainerInfo windowContainer:window] : nil;
}

TFYPopupContainerInfo * TFYPopupGetCurrentViewControllerContainer(void) {
    UIWindow *window = nil;
    if (@available(iOS 15.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *w in scene.windows) {
                    if (w.isKeyWindow) {
                        window = w;
                        break;
                    }
                }
            }
        }
    }
    if (window && window.rootViewController) {
        return [TFYPopupContainerInfo viewControllerContainer:window.rootViewController];
    }
    
    return nil;
}

TFYPopupContainerInfo * TFYPopupGetContainerForView(UIView *view) {
    if (!view) return nil;
    
    NSString *name = [NSString stringWithFormat:@"View_%p_%@", view, NSStringFromClass([view class])];
    return [TFYPopupContainerInfo viewContainer:view name:name];
}

TFYPopupContainerInfo * TFYPopupGetContainerForViewController(UIViewController *viewController) {
    if (!viewController) return nil;
    
    return [TFYPopupContainerInfo viewControllerContainer:viewController];
}
