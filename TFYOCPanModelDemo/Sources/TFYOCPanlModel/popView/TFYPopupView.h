//
//  TFYPopupView.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：主要弹窗视图类，提供完整的弹窗功能
//

#import <UIKit/UIKit.h>
#import <TFYOCPanlModel/TFYPopupViewConfiguration.h>
#import <TFYOCPanlModel/TFYPopupViewAnimator.h>
#import <TFYOCPanlModel/TFYPopupViewDelegate.h>
#import <TFYOCPanlModel/TFYPopupBackgroundView.h>
#import <TFYOCPanlModel/TFYPopupContainerType.h>

NS_ASSUME_NONNULL_BEGIN

@class TFYPopupBaseAnimator;

/// 回调 block 类型定义
typedef void (^TFYPopupViewCallback)(void) NS_SWIFT_NAME(PopupViewCallback);

/// 主要弹窗视图类
/// 提供完整的弹窗功能，支持多种动画效果、优先级管理、容器自动发现等特性
NS_SWIFT_NAME(PopupView)
@interface TFYPopupView : UIView

#pragma mark - Properties

/// 是否可消失
/// @discussion 设置为NO时，弹窗无法通过手势、背景点击等方式关闭
@property (nonatomic, assign) BOOL isDismissible;

/// 是否可交互
/// @discussion 设置为NO时，弹窗内容区域不响应用户交互
@property (nonatomic, assign, readonly) BOOL isInteractive;

/// 是否可穿透
/// @discussion 设置为YES时，背景区域的事件会穿透到下层视图
@property (nonatomic, assign, readonly) BOOL isPenetrable;

/// 是否正在展示中
/// @discussion 表示弹窗当前是否处于显示状态
@property (nonatomic, assign, readonly) BOOL isPresenting;

/// 背景视图
/// @discussion 弹窗的背景视图，支持模糊、纯色等效果
@property (nonatomic, strong, readonly) TFYPopupBackgroundView *backgroundView;

/// 代理
/// @discussion 用于接收弹窗生命周期事件和用户交互事件
@property (nonatomic, weak, nullable) id<TFYPopupViewDelegate> delegate;

#pragma mark - Callbacks

/// 即将显示回调
/// @discussion 在弹窗开始显示动画前调用
@property (nonatomic, copy, nullable) TFYPopupViewCallback willDisplayCallback;

/// 已经显示回调
/// @discussion 在弹窗显示动画完成后调用
@property (nonatomic, copy, nullable) TFYPopupViewCallback didDisplayCallback;

/// 即将消失回调
/// @discussion 在弹窗开始消失动画前调用
@property (nonatomic, copy, nullable) TFYPopupViewCallback willDismissCallback;

/// 已经消失回调
/// @discussion 在弹窗消失动画完成后调用
@property (nonatomic, copy, nullable) TFYPopupViewCallback didDismissCallback;

#pragma mark - Initialization

/// 指定初始化方法
/// @param containerView 容器视图，弹窗将显示在此视图上
/// @param contentView 内容视图，弹窗的主要内容
/// @param animator 动画器，控制弹窗的显示和消失动画
/// @param configuration 配置对象，包含弹窗的各种配置参数
/// @return 初始化后的弹窗实例
- (instancetype)initWithContainerView:(UIView *)containerView
                          contentView:(UIView *)contentView
                             animator:(id<TFYPopupViewAnimator>)animator
                        configuration:(TFYPopupViewConfiguration *)configuration NS_SWIFT_NAME(init(containerView:contentView:animator:configuration:));

/// 便利初始化方法（使用默认配置）
/// @param containerView 容器视图，弹窗将显示在此视图上
/// @param contentView 内容视图，弹窗的主要内容
/// @param animator 动画器，控制弹窗的显示和消失动画
/// @return 初始化后的弹窗实例
- (instancetype)initWithContainerView:(UIView *)containerView
                          contentView:(UIView *)contentView
                             animator:(id<TFYPopupViewAnimator>)animator NS_SWIFT_NAME(init(containerView:contentView:animator:));

#pragma mark - Configuration

/// 配置弹窗
/// @param configuration 配置对象，包含弹窗的各种配置参数
/// @return 返回自身，支持链式调用
- (instancetype)configureWithConfiguration:(TFYPopupViewConfiguration *)configuration NS_SWIFT_NAME(configure(configuration:));

/// 配置背景样式
/// @param style 背景样式（纯色、模糊等）
/// @param color 背景颜色
/// @param blurStyle 模糊样式（仅在style为模糊时有效）
/// @return 返回自身，支持链式调用
- (instancetype)configureBackgroundWithStyle:(TFYPopupBackgroundStyle)style
                                        color:(UIColor *)color
                                    blurStyle:(UIBlurEffectStyle)blurStyle NS_SWIFT_NAME(configureBackground(style:color:blurStyle:));

#pragma mark - Display & Dismiss

/// 显示弹窗
/// @param animated 是否使用动画显示
/// @param completion 显示完成后的回调，参数为弹窗实例
- (void)displayAnimated:(BOOL)animated completion:(void (^)(TFYPopupView * _Nullable pop))completion NS_SWIFT_NAME(display(animated:completion:));

/// 消失弹窗
/// @param animated 是否使用动画消失
/// @param completion 消失完成后的回调，参数为弹窗实例
- (void)dismissAnimated:(BOOL)animated completion:(nullable TFYPopupViewCallback)completion NS_SWIFT_NAME(dismiss(animated:completion:));

#pragma mark - Static Display Methods

/// 显示弹窗（便利方法）
/// @param contentView 内容视图
/// @param configuration 配置对象
/// @param animator 动画器
/// @param animated 是否动画
/// @param completion 完成回调
+ (void)showContentView:(UIView *)contentView
                  configuration:(TFYPopupViewConfiguration *)configuration
                       animator:(id<TFYPopupViewAnimator>)animator
                       animated:(BOOL)animated
                     completion:(void (^)(TFYPopupView * _Nullable pop))completion NS_SWIFT_NAME(show(contentView:configuration:animator:animated:completion:));

/// 显示弹窗（使用容器选择）
/// @param contentView 内容视图
/// @param configuration 配置对象
/// @param animator 动画器
/// @param animated 是否动画
/// @param completion 完成回调
+ (void)showContentViewWithContainerSelection:(UIView *)contentView
                                        configuration:(TFYPopupViewConfiguration *)configuration
                                             animator:(id<TFYPopupViewAnimator>)animator
                                             animated:(BOOL)animated
                                           completion:(void (^)(TFYPopupView * _Nullable pop))completion NS_SWIFT_NAME(showWithContainerSelection(contentView:configuration:animator:animated:completion:));

/// 显示弹窗（使用指定容器信息）
/// @param contentView 内容视图
/// @param containerInfo 容器信息
/// @param configuration 配置对象
/// @param animator 动画器
/// @param animated 是否动画
/// @param completion 完成回调
+ (instancetype)showContentView:(UIView *)contentView
                  containerInfo:(TFYPopupContainerInfo *)containerInfo
                  configuration:(TFYPopupViewConfiguration *)configuration
                       animator:(id<TFYPopupViewAnimator>)animator
                       animated:(BOOL)animated
                     completion:(void (^)(TFYPopupView * _Nullable pop))completion NS_SWIFT_NAME(show(contentView:containerInfo:configuration:animator:animated:completion:));

/// 显示弹窗（使用指定容器视图）
/// @param contentView 内容视图
/// @param containerView 容器视图
/// @param configuration 配置对象
/// @param animator 动画器
/// @param animated 是否动画
/// @param completion 完成回调
+ (void)showContentView:(UIView *)contentView
                  containerView:(UIView *)containerView
                  configuration:(TFYPopupViewConfiguration *)configuration
                       animator:(id<TFYPopupViewAnimator>)animator
                       animated:(BOOL)animated
                     completion:(void (^)(TFYPopupView * _Nullable pop))completion NS_SWIFT_NAME(show(contentView:containerView:configuration:animator:animated:completion:));

#pragma mark - Priority Methods

/// 显示弹窗（带优先级）
/// @param contentView 内容视图
/// @param priority 优先级
/// @param strategy 处理策略
/// @param animated 是否动画
/// @param completion 完成回调
+ (void)showContentViewWithPriority:(UIView *)contentView
                                   priority:(TFYPopupPriority)priority
                                   strategy:(TFYPopupPriorityStrategy)strategy
                                   animated:(BOOL)animated
                                 completion:(void (^)(TFYPopupView * _Nullable pop))completion NS_SWIFT_NAME(showWithPriority(contentView:priority:strategy:animated:completion:));

/// 显示弹窗（带优先级和基础配置）
/// @param contentView 内容视图
/// @param baseConfiguration 基础配置（可为nil，为nil时使用默认配置）
/// @param priority 优先级
/// @param strategy 处理策略
/// @param animated 是否动画
/// @param completion 完成回调
+ (void)showContentViewWithPriority:(UIView *)contentView
                           baseConfiguration:(nullable TFYPopupViewConfiguration *)baseConfiguration
                                    priority:(TFYPopupPriority)priority
                                    strategy:(TFYPopupPriorityStrategy)strategy
                                    animated:(BOOL)animated
                                  completion:(void (^)(TFYPopupView * _Nullable pop))completion NS_SWIFT_NAME(showWithPriority(contentView:baseConfiguration:priority:strategy:animated:completion:));

/// 显示弹窗（带优先级、基础配置和自定义动画器）
/// @param contentView 内容视图
/// @param baseConfiguration 基础配置（可为nil，为nil时使用默认配置）
/// @param animator 动画器（可为nil，为nil时使用默认淡入淡出动画器）
/// @param priority 优先级
/// @param strategy 处理策略
/// @param animated 是否动画
/// @param completion 完成回调
+ (void)showContentViewWithPriority:(UIView *)contentView
                           baseConfiguration:(nullable TFYPopupViewConfiguration *)baseConfiguration
                                    animator:(nullable id<TFYPopupViewAnimator>)animator
                                    priority:(TFYPopupPriority)priority
                                    strategy:(TFYPopupPriorityStrategy)strategy
                                    animated:(BOOL)animated
                                  completion:(void (^)(TFYPopupView * _Nullable pop))completion NS_SWIFT_NAME(showWithPriority(contentView:baseConfiguration:animator:priority:strategy:animated:completion:));

/// 显示弹窗（带优先级和完整配置）
/// @param contentView 内容视图
/// @param configuration 配置对象
/// @param animator 动画器
/// @param priority 优先级
/// @param strategy 处理策略
/// @param animated 是否动画
/// @param completion 完成回调
+ (void)showPriorityContentView:(UIView *)contentView
                          configuration:(TFYPopupViewConfiguration *)configuration
                               animator:(id<TFYPopupViewAnimator>)animator
                               priority:(TFYPopupPriority)priority
                               strategy:(TFYPopupPriorityStrategy)strategy
                               animated:(BOOL)animated
                             completion:(void (^)(TFYPopupView * _Nullable pop))completion NS_SWIFT_NAME(showPriority(contentView:configuration:animator:priority:strategy:animated:completion:));

/// 显示弹窗（使用默认配置）
/// @param contentView 内容视图
/// @param animated 是否动画
/// @param completion 完成回调
+ (void)showContentViewWithDefaultConfig:(UIView *)contentView
                                        animated:(BOOL)animated
                                      completion:(void (^)(TFYPopupView * _Nullable pop))completion NS_SWIFT_NAME(showWithDefaultConfig(contentView:animated:completion:));

/// 消失所有弹窗
/// @param animated 是否动画
/// @param completion 完成回调
// 消失所有弹窗（修正 Swift 名称，避免与 display 冲突）
+ (void)dismissAllAnimated:(BOOL)animated completion:(nullable TFYPopupViewCallback)completion NS_SWIFT_NAME(dismissAll(animated:completion:));

/// 获取当前弹窗数量
+ (NSInteger)currentPopupCount NS_SWIFT_NAME(currentCount());

/// 获取所有当前弹窗
+ (NSArray<TFYPopupView *> *)allCurrentPopups NS_SWIFT_NAME(allCurrent());

#pragma mark - Priority Query Methods

/// 获取弹窗的优先级
/// @discussion 返回当前弹窗实例的优先级
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

#pragma mark - Bottom Sheet Convenience Methods

/// 显示底部弹出框（便利方法）
/// @param contentView 内容视图
/// @param animated 是否动画
/// @param completion 完成回调
+ (void)showBottomSheetWithContentView:(UIView *)contentView
                                      animated:(BOOL)animated
                                    completion:(void (^)(TFYPopupView * _Nullable pop))completion NS_SWIFT_NAME(showBottomSheet(contentView:animated:completion:));

/// 启用底部弹出框手势功能
/// @discussion 如果当前使用的是底部弹出框动画器，则启用手势交互
- (void)enableBottomSheetGestures NS_SWIFT_NAME(enableBottomSheetGestures());

/// 禁用底部弹出框手势功能
/// @discussion 如果当前使用的是底部弹出框动画器，则禁用手势交互
- (void)disableBottomSheetGestures NS_SWIFT_NAME(disableBottomSheetGestures());

/// 检查底部弹出框手势是否已启用
/// @discussion 返回当前弹窗是否启用了底部弹出框手势功能
@property (nonatomic, assign, readonly) BOOL isBottomSheetGesturesEnabled;

@end

#pragma mark - UIView Category

/// UIView 扩展
/// 提供便捷的弹窗查找方法
@interface UIView (TFYPopupView)

/// 查找当前视图所属的弹窗
/// @discussion 检查当前视图的直接父视图是否为TFYPopupView
/// @return 如果父视图是TFYPopupView则返回该实例，否则返回nil
- (nullable TFYPopupView *)popupView NS_SWIFT_NAME(popupView());

/// 查找弹窗视图（向上遍历视图层级）
/// @discussion 从当前视图开始向上遍历视图层级，查找TFYPopupView实例
/// @return 找到的第一个TFYPopupView实例，如果没找到则返回nil
- (nullable TFYPopupView *)findPopupView NS_SWIFT_NAME(findPopupView());

@end

NS_ASSUME_NONNULL_END
