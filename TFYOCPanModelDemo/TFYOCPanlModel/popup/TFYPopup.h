//
//  TFYPopup.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗框架主头文件，整合所有组件
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//! Project version number for TFYPopup.
FOUNDATION_EXPORT double TFYPopupVersionNumber;

//! Project version string for TFYPopup.
FOUNDATION_EXPORT const unsigned char TFYPopupVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <TFYPopup/PublicHeader.h>

#pragma mark - Configuration Classes

#import "TFYPopupKeyboardConfiguration.h"
#import "TFYPopupContainerConfiguration.h"
#import "TFYPopupViewConfiguration.h"

#pragma mark - Protocol Definitions

#import "TFYPopupViewAnimator.h"
#import "TFYPopupViewDelegate.h"

#pragma mark - Core Classes

#import "TFYPopupBackgroundView.h"
#import "TFYPopupView.h"
#import "TFYPopupPriorityManager.h"
#import "TFYPopupContainerManager.h"

#pragma mark - Layout System

#import "TFYPopupAnimatorLayout.h"

#pragma mark - Animator Classes

#import "TFYPopupBaseAnimator.h"
#import "TFYPopupAnimators.h"
#import "TFYPopupBottomSheetAnimator.h"

#pragma mark - Container Selection

#import "TFYPopupContainerType.h"

#pragma mark - Convenience Macros

/// 快速创建并显示淡入淡出弹窗（使用容器选择）
#define TFYPopupShowFadeInOut(contentView, animated, completion) \
    [TFYPopupView showContentViewWithContainerSelection:contentView \
                                          configuration:[[TFYPopupViewConfiguration alloc] init] \
                                               animator:[[TFYPopupFadeInOutAnimator alloc] init] \
                                               animated:animated \
                                             completion:completion]

/// 快速创建并显示缩放弹窗（使用容器选择）
#define TFYPopupShowZoomInOut(contentView, animated, completion) \
    [TFYPopupView showContentViewWithContainerSelection:contentView \
                                          configuration:[[TFYPopupViewConfiguration alloc] init] \
                                               animator:[[TFYPopupZoomInOutAnimator alloc] init] \
                                               animated:animated \
                                             completion:completion]

/// 快速创建并显示底部弹出框
#define TFYPopupShowBottomSheet(contentView, animated, completion) \
    [TFYPopupView showBottomSheetWithContentView:contentView \
                                        animated:animated \
                                      completion:completion]

/// 快速消失所有弹窗
#define TFYPopupDismissAll(animated, completion) \
    [TFYPopupView dismissAllAnimated:animated completion:completion]

/// 快速显示高优先级弹窗
#define TFYPopupShowHighPriority(contentView, animated, completion) \
    [TFYPopupView showContentView:contentView \
                         priority:TFYPopupPriorityHigh \
                         strategy:TFYPopupPriorityStrategyReplace \
                         animated:animated \
                       completion:completion]

/// 快速显示紧急弹窗
#define TFYPopupShowUrgent(contentView, animated, completion) \
    [TFYPopupView showContentView:contentView \
                         priority:TFYPopupPriorityUrgent \
                         strategy:TFYPopupPriorityStrategyReplace \
                         animated:animated \
                       completion:completion]

/// 快速显示等待队列弹窗
#define TFYPopupShowQueued(contentView, animated, completion) \
    [TFYPopupView showContentView:contentView \
                         priority:TFYPopupPriorityNormal \
                         strategy:TFYPopupPriorityStrategyQueue \
                         animated:animated \
                       completion:completion]

#pragma mark - Container Selection Macros

/// 快速显示弹窗（使用容器选择）
#define TFYPopupShowWithContainerSelection(contentView, animated, completion) \
    [TFYPopupView showContentViewWithContainerSelection:contentView \
                                          configuration:[[TFYPopupViewConfiguration alloc] init] \
                                               animator:[[TFYPopupFadeInOutAnimator alloc] init] \
                                               animated:animated \
                                             completion:completion]

/// 快速显示弹窗（使用指定容器视图）
#define TFYPopupShowWithContainerView(contentView, containerView, animated, completion) \
    [TFYPopupView showContentView:contentView \
                    containerView:containerView \
                    configuration:[[TFYPopupViewConfiguration alloc] init] \
                         animator:[[TFYPopupFadeInOutAnimator alloc] init] \
                         animated:animated \
                       completion:completion]

/// 快速显示弹窗（使用当前窗口）
#define TFYPopupShowWithCurrentWindow(contentView, animated, completion) \
    [TFYPopupView showContentView:contentView \
                    containerView:TFYPopupGetCurrentWindowContainer().containerView \
                    configuration:[[TFYPopupViewConfiguration alloc] init] \
                         animator:[[TFYPopupFadeInOutAnimator alloc] init] \
                         animated:animated \
                       completion:completion]

/// 快速显示弹窗（使用当前视图控制器）
#define TFYPopupShowWithCurrentViewController(contentView, animated, completion) \
    [TFYPopupView showContentView:contentView \
                    containerView:TFYPopupGetCurrentViewControllerContainer().containerView \
                    configuration:[[TFYPopupViewConfiguration alloc] init] \
                         animator:[[TFYPopupFadeInOutAnimator alloc] init] \
                         animated:animated \
                       completion:completion]

#pragma mark - Notification Names

/// 弹窗即将显示通知
FOUNDATION_EXPORT NSNotificationName const _Nonnull TFYPopupWillAppearNotification NS_SWIFT_NAME(Popup.willAppearNotification);

/// 弹窗已经显示通知
FOUNDATION_EXPORT NSNotificationName const _Nonnull TFYPopupDidAppearNotification NS_SWIFT_NAME(Popup.didAppearNotification);

/// 弹窗即将消失通知
FOUNDATION_EXPORT NSNotificationName const _Nonnull TFYPopupWillDisappearNotification NS_SWIFT_NAME(Popup.willDisappearNotification);

/// 弹窗已经消失通知
FOUNDATION_EXPORT NSNotificationName const _Nonnull TFYPopupDidDisappearNotification NS_SWIFT_NAME(Popup.didDisappearNotification);

/// 弹窗数量变化通知
FOUNDATION_EXPORT NSNotificationName const _Nonnull TFYPopupCountDidChangeNotification NS_SWIFT_NAME(Popup.countDidChangeNotification);

#pragma mark - Global Functions

/// 获取当前弹窗数量
FOUNDATION_EXPORT NSInteger TFYPopupGetCurrentCount(void) NS_SWIFT_NAME(Popup.getCurrentCount());

/// 检查是否有弹窗正在显示
FOUNDATION_EXPORT BOOL TFYPopupIsPresenting(void) NS_SWIFT_NAME(Popup.isPresenting());

/// 获取所有当前弹窗
FOUNDATION_EXPORT NSArray<TFYPopupView *> * _Nonnull TFYPopupGetAllCurrentPopups(void) NS_SWIFT_NAME(Popup.getAllCurrentPopups());

#pragma mark - Priority Functions

/// 获取当前最高优先级
FOUNDATION_EXPORT TFYPopupPriority TFYPopupGetCurrentHighestPriority(void) NS_SWIFT_NAME(Popup.getCurrentHighestPriority());

/// 获取等待队列数量
FOUNDATION_EXPORT NSInteger TFYPopupGetWaitingQueueCount(void) NS_SWIFT_NAME(Popup.getWaitingQueueCount());

/// 清理低优先级弹窗
FOUNDATION_EXPORT void TFYPopupClearLowPriorityPopups(TFYPopupPriority threshold) NS_SWIFT_NAME(Popup.clearLowPriorityPopups(_:));

/// 暂停优先级队列
FOUNDATION_EXPORT void TFYPopupPausePriorityQueue(void) NS_SWIFT_NAME(Popup.pausePriorityQueue());

/// 恢复优先级队列
FOUNDATION_EXPORT void TFYPopupResumePriorityQueue(void) NS_SWIFT_NAME(Popup.resumePriorityQueue());

/// 启用优先级调试模式
FOUNDATION_EXPORT void TFYPopupEnablePriorityDebugMode(BOOL enabled) NS_SWIFT_NAME(Popup.enablePriorityDebugMode(_:));

/// 打印优先级队列信息
FOUNDATION_EXPORT void TFYPopupLogPriorityQueue(void) NS_SWIFT_NAME(Popup.logPriorityQueue());

NS_SWIFT_NAME(Popup)
@interface TFYPopup: NSObject
@end
