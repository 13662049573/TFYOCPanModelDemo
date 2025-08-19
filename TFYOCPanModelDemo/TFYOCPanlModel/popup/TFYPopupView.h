//
//  TFYPopupView.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：主要弹窗视图类，提供完整的弹窗功能
//

#import <UIKit/UIKit.h>
#import "TFYPopupViewConfiguration.h"
#import "TFYPopupViewAnimator.h"
#import "TFYPopupViewDelegate.h"
#import "TFYPopupBackgroundView.h"

NS_ASSUME_NONNULL_BEGIN

@class TFYPopupBaseAnimator;

/// 回调 block 类型定义
typedef void (^TFYPopupViewCallback)(void) NS_SWIFT_NAME(PopupViewCallback);

/// 主要弹窗视图类
NS_SWIFT_NAME(PopupView)
@interface TFYPopupView : UIView

#pragma mark - Properties

/// 是否可消失
@property (nonatomic, assign) BOOL isDismissible;

/// 是否可交互
@property (nonatomic, assign, readonly) BOOL isInteractive;

/// 是否可穿透
@property (nonatomic, assign, readonly) BOOL isPenetrable;

/// 是否正在展示中
@property (nonatomic, assign, readonly) BOOL isPresenting;

/// 背景视图
@property (nonatomic, strong, readonly) TFYPopupBackgroundView *backgroundView;

/// 代理
@property (nonatomic, weak, nullable) id<TFYPopupViewDelegate> delegate;

#pragma mark - Callbacks

/// 即将显示回调
@property (nonatomic, copy, nullable) TFYPopupViewCallback willDisplayCallback;

/// 已经显示回调
@property (nonatomic, copy, nullable) TFYPopupViewCallback didDisplayCallback;

/// 即将消失回调
@property (nonatomic, copy, nullable) TFYPopupViewCallback willDismissCallback;

/// 已经消失回调
@property (nonatomic, copy, nullable) TFYPopupViewCallback didDismissCallback;

#pragma mark - Initialization

/// 指定初始化方法
/// @param containerView 容器视图
/// @param contentView 内容视图
/// @param animator 动画器
/// @param configuration 配置对象
- (instancetype)initWithContainerView:(UIView *)containerView
                          contentView:(UIView *)contentView
                             animator:(id<TFYPopupViewAnimator>)animator
                        configuration:(TFYPopupViewConfiguration *)configuration NS_SWIFT_NAME(init(containerView:contentView:animator:configuration:));

/// 便利初始化方法（使用默认配置）
- (instancetype)initWithContainerView:(UIView *)containerView
                          contentView:(UIView *)contentView
                             animator:(id<TFYPopupViewAnimator>)animator NS_SWIFT_NAME(init(containerView:contentView:animator:));

#pragma mark - Configuration

/// 配置弹窗
/// @param configuration 配置对象
/// @return 返回自身，支持链式调用
- (instancetype)configureWithConfiguration:(TFYPopupViewConfiguration *)configuration NS_SWIFT_NAME(configure(configuration:));

/// 配置背景样式
/// @param style 背景样式
/// @param color 背景颜色
/// @param blurStyle 模糊样式
/// @return 返回自身，支持链式调用
- (instancetype)configureBackgroundWithStyle:(TFYPopupBackgroundStyle)style
                                        color:(UIColor *)color
                                    blurStyle:(UIBlurEffectStyle)blurStyle NS_SWIFT_NAME(configureBackground(style:color:blurStyle:));

#pragma mark - Display & Dismiss

/// 显示弹窗
/// @param animated 是否动画
/// @param completion 完成回调
- (void)displayAnimated:(BOOL)animated completion:(nullable TFYPopupViewCallback)completion NS_SWIFT_NAME(display(animated:completion:));

/// 消失弹窗
/// @param animated 是否动画
/// @param completion 完成回调
- (void)dismissAnimated:(BOOL)animated completion:(nullable TFYPopupViewCallback)completion NS_SWIFT_NAME(dismiss(animated:completion:));

#pragma mark - Static Methods

/// 显示弹窗（便利方法）
/// @param contentView 内容视图
/// @param configuration 配置对象
/// @param animator 动画器
/// @param animated 是否动画
/// @param completion 完成回调
/// @return 弹窗实例
+ (instancetype)showContentView:(UIView *)contentView
                  configuration:(TFYPopupViewConfiguration *)configuration
                       animator:(id<TFYPopupViewAnimator>)animator
                       animated:(BOOL)animated
                     completion:(nullable TFYPopupViewCallback)completion NS_SWIFT_NAME(show(contentView:configuration:animator:animated:completion:));

#pragma mark - Priority Methods

/// 显示弹窗（带优先级）
/// @param contentView 内容视图
/// @param priority 优先级
/// @param strategy 处理策略
/// @param animated 是否动画
/// @param completion 完成回调
/// @return 弹窗实例
+ (instancetype)showContentView:(UIView *)contentView
                       priority:(TFYPopupPriority)priority
                       strategy:(TFYPopupPriorityStrategy)strategy
                       animated:(BOOL)animated
                     completion:(nullable TFYPopupViewCallback)completion NS_SWIFT_NAME(show(contentView:priority:strategy:animated:completion:));

/// 显示弹窗（带优先级和配置）
/// @param contentView 内容视图
/// @param configuration 配置对象
/// @param animator 动画器
/// @param priority 优先级
/// @param strategy 处理策略
/// @param animated 是否动画
/// @param completion 完成回调
/// @return 弹窗实例
+ (instancetype)showContentView:(UIView *)contentView
                  configuration:(TFYPopupViewConfiguration *)configuration
                       animator:(id<TFYPopupViewAnimator>)animator
                       priority:(TFYPopupPriority)priority
                       strategy:(TFYPopupPriorityStrategy)strategy
                       animated:(BOOL)animated
                     completion:(nullable TFYPopupViewCallback)completion NS_SWIFT_NAME(show(contentView:configuration:animator:priority:strategy:animated:completion:));

/// 显示弹窗（使用默认配置）
/// @param contentView 内容视图
/// @param animated 是否动画
/// @param completion 完成回调
/// @return 弹窗实例
+ (instancetype)showContentView:(UIView *)contentView
                       animated:(BOOL)animated
                     completion:(nullable TFYPopupViewCallback)completion NS_SWIFT_NAME(show(contentView:animated:completion:));

/// 消失所有弹窗
/// @param animated 是否动画
/// @param completion 完成回调
+ (void)dismissAllAnimated:(BOOL)animated completion:(nullable TFYPopupViewCallback)completion NS_SWIFT_NAME(dismissAll(animated:completion:));

/// 获取当前弹窗数量
+ (NSInteger)currentPopupCount NS_SWIFT_NAME(currentCount());

/// 获取所有当前弹窗
+ (NSArray<TFYPopupView *> *)allCurrentPopups NS_SWIFT_NAME(allCurrent());

#pragma mark - Priority Query Methods

/// 获取弹窗的优先级
@property (nonatomic, assign, readonly) TFYPopupPriority currentPriority;

/// 获取当前最高优先级
+ (TFYPopupPriority)currentHighestPriority NS_SWIFT_NAME(currentHighestPriority());

/// 获取指定优先级的弹窗列表
+ (NSArray<TFYPopupView *> *)popupsWithPriority:(TFYPopupPriority)priority NS_SWIFT_NAME(popups(withPriority:));

/// 清理低优先级弹窗
+ (void)clearPopupsWithPriorityLowerThan:(TFYPopupPriority)priority NS_SWIFT_NAME(clearPopups(withPriorityLowerThan:));

/// 暂停/恢复优先级队列
+ (void)pausePriorityQueue NS_SWIFT_NAME(pausePriorityQueue());
+ (void)resumePriorityQueue NS_SWIFT_NAME(resumePriorityQueue());

/// 获取等待队列信息
+ (NSInteger)waitingQueueCount NS_SWIFT_NAME(waitingQueueCount());

/// 调试：打印优先级队列信息
+ (void)logPriorityQueue NS_SWIFT_NAME(logPriorityQueue());

#pragma mark - Bottom Sheet Convenience

/// 显示底部弹出框（便利方法）
/// @param contentView 内容视图
/// @param animated 是否动画
/// @param completion 完成回调
/// @return 弹窗实例
+ (instancetype)showBottomSheetWithContentView:(UIView *)contentView
                                      animated:(BOOL)animated
                                    completion:(nullable TFYPopupViewCallback)completion NS_SWIFT_NAME(showBottomSheet(contentView:animated:completion:));

/// 启用底部弹出框手势功能（如果当前使用的是底部弹出框动画器）
- (void)enableBottomSheetGestures NS_SWIFT_NAME(enableBottomSheetGestures());

/// 禁用底部弹出框手势功能（如果当前使用的是底部弹出框动画器）
- (void)disableBottomSheetGestures NS_SWIFT_NAME(disableBottomSheetGestures());

/// 检查底部弹出框手势是否已启用
@property (nonatomic, assign, readonly) BOOL isBottomSheetGesturesEnabled;

@end

#pragma mark - UIView Category

/// UIView 扩展
@interface UIView (TFYPopupView)

/// 查找当前视图所属的弹窗
- (nullable TFYPopupView *)popupView NS_SWIFT_NAME(popupView());

/// 查找弹窗视图（向上遍历视图层级）
- (nullable TFYPopupView *)findPopupView NS_SWIFT_NAME(findPopupView());

@end

NS_ASSUME_NONNULL_END
