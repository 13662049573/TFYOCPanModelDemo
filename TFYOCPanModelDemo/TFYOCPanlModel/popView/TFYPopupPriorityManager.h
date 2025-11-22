//
//  TFYPopupPriorityManager.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗优先级管理器，处理多弹窗的优先级调度
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TFYPopupView;

/// 弹窗优先级枚举
typedef NS_ENUM(NSInteger, TFYPopupPriority) {
    TFYPopupPriorityBackground = 0,    // 背景级 (最低)
    TFYPopupPriorityLow = 100,         // 低优先级
    TFYPopupPriorityNormal = 200,      // 普通优先级 (默认)
    TFYPopupPriorityHigh = 300,        // 高优先级
    TFYPopupPriorityCritical = 400,    // 关键优先级
    TFYPopupPriorityUrgent = 500,      // 紧急优先级 (最高)
} NS_SWIFT_NAME(PopupPriority);

/// 优先级处理策略
typedef NS_ENUM(NSUInteger, TFYPopupPriorityStrategy) {
    TFYPopupPriorityStrategyQueue = 0,     // 队列等待
    TFYPopupPriorityStrategyReplace,       // 替换低优先级
    TFYPopupPriorityStrategyOverlay,       // 覆盖显示
    TFYPopupPriorityStrategyReject         // 拒绝显示
} NS_SWIFT_NAME(PopupPriorityStrategy);

/// 优先级队列项
NS_SWIFT_NAME(PopupPriorityItem)
@interface TFYPopupPriorityItem : NSObject

@property (nonatomic, weak) TFYPopupView *popupView;
@property (nonatomic, assign) TFYPopupPriority priority;
@property (nonatomic, assign) TFYPopupPriorityStrategy strategy;
@property (nonatomic, strong) NSDate *enqueuedTime;
@property (nonatomic, assign) NSTimeInterval maxWaitingTime;
@property (nonatomic, copy, nullable) void (^completionBlock)(void);

- (instancetype)initWithPopupView:(TFYPopupView *)popupView
                         priority:(TFYPopupPriority)priority
                         strategy:(TFYPopupPriorityStrategy)strategy
                   maxWaitingTime:(NSTimeInterval)maxWaitingTime
                       completion:(nullable void (^)(void))completion;

@property (nonatomic, assign, readonly) BOOL isExpired;

@end

/// 优先级变化通知
FOUNDATION_EXPORT NSNotificationName const _Nonnull TFYPopupPriorityDidChangeNotification NS_SWIFT_NAME(Popup.priorityDidChangeNotification);
FOUNDATION_EXPORT NSNotificationName const _Nonnull TFYPopupQueueDidUpdateNotification NS_SWIFT_NAME(Popup.queueDidUpdateNotification);
FOUNDATION_EXPORT NSNotificationName const _Nonnull TFYPopupDidReplaceNotification NS_SWIFT_NAME(Popup.didReplaceNotification);

/// 优先级管理器
NS_SWIFT_NAME(PopupPriorityManager)
@interface TFYPopupPriorityManager : NSObject

#pragma mark - Singleton

/// 单例管理器
+ (instancetype)sharedManager NS_SWIFT_NAME(shared());

#pragma mark - Core Management

/// 根据优先级添加弹窗
/// @param popup 弹窗实例
/// @param priority 优先级
/// @param strategy 处理策略
/// @param completion 完成回调
/// @return 是否成功添加
- (BOOL)addPopup:(TFYPopupView *)popup
        priority:(TFYPopupPriority)priority
        strategy:(TFYPopupPriorityStrategy)strategy
      completion:(nullable void (^)(void))completion NS_SWIFT_NAME(add(popup:priority:strategy:completion:));

/// 移除弹窗并处理等待队列
/// @param popup 弹窗实例
- (void)removePopup:(TFYPopupView *)popup NS_SWIFT_NAME(remove(popup:));

/// 立即显示下一个优先级最高的弹窗
- (void)processNextPopup NS_SWIFT_NAME(processNext());

#pragma mark - Query Methods

/// 获取当前最高优先级
- (TFYPopupPriority)currentHighestPriority NS_SWIFT_NAME(currentHighestPriority());

/// 获取指定优先级的弹窗列表
/// @param priority 优先级
/// @return 弹窗列表
- (NSArray<TFYPopupView *> *)popupsWithPriority:(TFYPopupPriority)priority NS_SWIFT_NAME(popups(withPriority:));

/// 获取当前显示的弹窗列表
- (NSArray<TFYPopupView *> *)currentDisplayedPopups NS_SWIFT_NAME(currentDisplayedPopups());

/// 获取等待队列中的弹窗列表
- (NSArray<TFYPopupPriorityItem *> *)waitingQueue NS_SWIFT_NAME(waitingQueue());

/// 获取队列中的弹窗总数
- (NSInteger)totalQueueCount NS_SWIFT_NAME(totalQueueCount());

#pragma mark - Management Operations

/// 清理低优先级弹窗
/// @param priority 优先级阈值
- (void)clearPopupsWithPriorityLowerThan:(TFYPopupPriority)priority NS_SWIFT_NAME(clearPopups(withPriorityLowerThan:));

/// 清理过期的等待弹窗
- (void)clearExpiredWaitingPopups NS_SWIFT_NAME(clearExpiredWaitingPopups());

/// 暂停队列处理
- (void)pauseQueue NS_SWIFT_NAME(pauseQueue());

/// 恢复队列处理
- (void)resumeQueue NS_SWIFT_NAME(resumeQueue());

/// 清空所有队列
- (void)clearAllQueues NS_SWIFT_NAME(clearAllQueues());

#pragma mark - Configuration

/// 设置默认最大等待时间
@property (nonatomic, assign) NSTimeInterval defaultMaxWaitingTime;

/// 设置最大同时显示弹窗数量
@property (nonatomic, assign) NSInteger maxSimultaneousPopups;

/// 是否启用自动清理过期弹窗
@property (nonatomic, assign) BOOL autoCleanupExpiredPopups;

/// 队列是否暂停
@property (nonatomic, assign, readonly) BOOL isQueuePaused;

#pragma mark - Debugging

/// 启用优先级调试模式
/// @param enabled 是否启用
+ (void)enablePriorityDebugMode:(BOOL)enabled NS_SWIFT_NAME(enablePriorityDebugMode(_:));

/// 获取优先级调试模式状态
+ (BOOL)isPriorityDebugModeEnabled NS_SWIFT_NAME(isPriorityDebugModeEnabled());

/// 打印优先级队列信息
- (void)logPriorityQueue NS_SWIFT_NAME(logPriorityQueue());

/// 获取优先级描述
/// @param priority 优先级
/// @return 优先级描述字符串
+ (NSString *)priorityDescription:(TFYPopupPriority)priority NS_SWIFT_NAME(priorityDescription(_:));

/// 获取策略描述
/// @param strategy 策略
/// @return 策略描述字符串
+ (NSString *)strategyDescription:(TFYPopupPriorityStrategy)strategy NS_SWIFT_NAME(strategyDescription(_:));

@end

#pragma mark - Utility Functions

/// 比较两个优先级
FOUNDATION_EXPORT BOOL TFYPopupPriorityIsHigher(TFYPopupPriority priority1, TFYPopupPriority priority2) NS_SWIFT_NAME(PopupPriorityIsHigher(_:_:));

/// 获取优先级的数值
FOUNDATION_EXPORT NSInteger TFYPopupPriorityGetValue(TFYPopupPriority priority) NS_SWIFT_NAME(PopupPriorityGetValue(_:));

/// 从数值创建优先级
FOUNDATION_EXPORT TFYPopupPriority TFYPopupPriorityFromValue(NSInteger value) NS_SWIFT_NAME(PopupPriorityFromValue(_:));

NS_ASSUME_NONNULL_END
