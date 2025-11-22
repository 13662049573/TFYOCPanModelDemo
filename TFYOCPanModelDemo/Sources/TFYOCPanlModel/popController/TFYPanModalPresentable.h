//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。

#ifndef TFYPANMODALPRESENTABLE_H
#define TFYPANMODALPRESENTABLE_H

//
//  TFYPanModalPresentable.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TFYOCPanlModel/TFYPanModalHeight.h>
#import <TFYOCPanlModel/TFYPresentingVCAnimatedTransitioning.h>
#import <TFYOCPanlModel/TFYPanModalIndicatorProtocol.h>
#import <TFYOCPanlModel/TFYBackgroundConfig.h>
#import <TFYOCPanlModel/TFYPanModalShadow.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * PresentationState
 * 弹窗的展示状态（短/中/长）
 */
typedef NS_ENUM(NSInteger, PresentationState) {
	PresentationStateShort NS_SWIFT_NAME(short), ///< 短高度
    PresentationStateMedium NS_SWIFT_NAME(medium), ///< 中高度
	PresentationStateLong NS_SWIFT_NAME(long), ///< 长高度
};

/**
 * PresentingViewControllerAnimationStyle
 * 父控制器动画样式
 */
typedef NS_ENUM(NSInteger, PresentingViewControllerAnimationStyle) {
    PresentingViewControllerAnimationStyleNone NS_SWIFT_NAME(none), ///< 无动画
    PresentingViewControllerAnimationStylePageSheet NS_SWIFT_NAME(pageSheet), ///< iOS13风格PageSheet动画
    PresentingViewControllerAnimationStyleShoppingCart NS_SWIFT_NAME(shoppingCart), ///< 购物车风格动画
    PresentingViewControllerAnimationStyleCustom NS_SWIFT_NAME(custom), ///< 自定义动画
};

/**
 * TFYPanModalPresentable
 * PanModal弹窗核心配置协议，所有弹窗内容需实现本协议，支持高度、动画、手势、背景、事件等丰富配置。
 * 默认通过UIViewController Category实现，无需强制实现所有方法。
 */
NS_SWIFT_NAME(PanModalPresentable)
@protocol TFYPanModalPresentable <NSObject>

#pragma mark - ScrollView 配置

/**
 * 支持同步拖拽的scrollView
 * 如果ViewController中包含scrollView且希望scrollView滑动和拖拽手势共存，请返回该scrollView
 */
- (nullable UIScrollView *)panScrollable;

/**
 * 是否允许scrollView滚动，默认YES
 */
- (BOOL)isPanScrollEnabled;

/**
 * scrollView指示器insets，更新insets时请调用panModalSetNeedsLayoutUpdate()
 */
- (UIEdgeInsets)scrollIndicatorInsets;

/**
 * 是否显示垂直滚动指示器，默认YES
 */
- (BOOL)showsScrollableVerticalScrollIndicator;

/**
 * 是否自动设置scrollView的contentInset，默认YES
 */
- (BOOL)shouldAutoSetPanScrollContentInset;

/**
 * 是否允许扩展拖拽，若panScrollable存在且contentSize大于(size + bottomLayoutOffset)时返回YES，其余情况返回NO
 */
- (BOOL)allowsExtendedPanScrolling;

#pragma mark - 偏移/位置

/**
 * 距离屏幕顶部的偏移量，默认topLayoutGuide.length + 21.0
 */
- (CGFloat)topOffset;

/**
 * short状态下的高度，默认等于longFormHeight
 */
- (PanModalHeight)shortFormHeight;

/**
 * medium状态下的高度，默认等于longFormHeight
 */
- (PanModalHeight)mediumFormHeight;

/**
 * long状态下的高度
 */
- (PanModalHeight)longFormHeight;

/**
 * 初始弹出高度状态，默认shortFormHeight
 */
- (PresentationState)originPresentationState;

#pragma mark - 动画配置

/**
 * 弹性动画参数，默认0.9
 */
- (CGFloat)springDamping;

/**
 * 转场动画时长，默认0.5秒
 */
- (NSTimeInterval)transitionDuration;

/**
 * 消失动画时长，默认同transitionDuration
 */
- (NSTimeInterval)dismissalDuration;

/**
 * 转场动画options，默认UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
 */
- (UIViewAnimationOptions)transitionAnimationOptions;

#pragma mark - AppearanceTransition

/**
 * 是否启用父控制器生命周期回调，默认YES
 */
- (BOOL)shouldEnableAppearanceTransition;

#pragma mark - 背景配置

/**
 * 返回背景配置对象，用于设置遮罩透明度或毛玻璃效果
 */
- (nonnull TFYBackgroundConfig *)backgroundConfig;

#pragma mark - 用户交互

/**
 * 是否允许在long状态下继续拖拽到最大高度，默认YES
 */
- (BOOL)anchorModalToLongForm;

/**
 * 是否允许点击背景关闭弹窗，默认YES
 */
- (BOOL)allowsTapBackgroundToDismiss;

/**
 * 是否允许拖拽关闭弹窗，默认YES
 */
- (BOOL)allowsDragToDismiss;

/**
 * short状态下是否允许下拉，默认YES
 */
- (BOOL)allowsPullDownWhenShortState;

/**
 * 触发关闭的最小垂直速度，默认300.0
 */
- (CGFloat)minVerticalVelocityToTriggerDismiss;

/**
 * 是否允许用户交互，默认YES
 */
- (BOOL)isUserInteractionEnabled;

/**
 * 是否允许触觉反馈，默认YES
 */
- (BOOL)isHapticFeedbackEnabled;

/**
 * 是否允许事件穿透到presenting ViewController/View，适用于特殊场景（如底部弹窗需操作下层view），需自行管理关闭时机
 */
- (BOOL)allowsTouchEventsPassingThroughTransitionView;

#pragma mark - 屏幕左侧边缘交互

/**
 * 是否允许屏幕左侧边缘滑动手势，默认NO，仅UIViewController生效
 */
- (BOOL)allowScreenEdgeInteractive;

/**
 * 允许边缘滑动的最大距离，默认0（不限制，整屏左侧都可触发）
 */
- (CGFloat)maxAllowedDistanceToLeftScreenEdgeForPanInteraction;

/**
 * 边缘滑动未达到0.5屏宽时，触发关闭的最小水平速度，默认500
 */
- (CGFloat)minHorizontalVelocityToTriggerScreenEdgeDismiss;

#pragma mark - 自定义presentingViewController动画

/**
 * 配置presentingViewController动画样式，present和dismiss均生效，默认PresentingViewControllerAnimationStyleNone
 */
- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle;

/**
 * 自定义presenting ViewController转场动画，默认为nil
 * 注意：如需生效，presentingVCAnimationStyle需返回PresentingViewControllerAnimationStyleCustom
 */
- (nullable id<TFYPresentingViewControllerAnimatedTransitioning>)customPresentingVCAnimation;

#pragma mark - 内容UI配置

/**
 * 是否顶部圆角，默认YES
 */
- (BOOL)shouldRoundTopCorners;

/**
 * 顶部圆角数值，默认8.0
 */
- (CGFloat)cornerRadius;

/**
 * 内容阴影配置，默认无
 */
- (nonnull TFYPanModalShadow *)contentShadow;

#pragma mark - 指示器配置

/**
 * 是否显示拖拽指示器，默认YES，依赖shouldRoundTopCorners
 */
- (BOOL)showDragIndicator;

/**
 * 自定义指示器，需实现TFYPanModalIndicatorProtocol，默认nil
 */
- (nullable __kindof UIView<TFYPanModalIndicatorProtocol> *)customIndicatorView;

#pragma mark - 键盘处理

/**
 * 是否自动处理键盘弹出，默认YES
 */
- (BOOL)isAutoHandleKeyboardEnabled;

/**
 * 键盘与输入视图底部的偏移量，默认5
 */
- (CGFloat)keyboardOffsetFromInputView;

#pragma mark - 自定义底部容器

/**
 * 自定义底部固定容器视图（可选），仅实现并返回非空view时显示，且始终固定底部不随内容滑动
 */

#pragma mark - 防频繁点击配置

/**
 * 是否启用防频繁点击功能，默认YES
 */
- (BOOL)shouldPreventFrequentTapping;

/**
 * 防频繁点击的时间间隔（秒），默认1.0秒
 */
- (NSTimeInterval)frequentTapPreventionInterval;

/**
 * 是否允许在防频繁点击期间显示提示，默认NO
 */
- (BOOL)shouldShowFrequentTapPreventionHint;

/**
 * 防频繁点击提示文本，默认"请稍后再试"
 */
- (nullable NSString *)frequentTapPreventionHintText;

/**
 * 防频繁点击状态变更回调
 * @param isPrevented 是否被阻止
 * @param remainingTime 剩余等待时间
 */
- (void)panModalFrequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime;

#pragma mark - Delegate

#pragma mark - 拖拽手势代理

/**
 * 是否允许拖拽手势生效，返回NO则禁用拖拽关闭，默认YES
 */
- (BOOL)shouldRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 拖拽手势begin/changed时回调，拖动presented View时持续回调，默认实现为空
 */
- (void)willRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 拖拽手势内部处理完成后回调，view frame可能已变化，可能多次回调
 */
- (void)didRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 拖拽手势结束后回调，view frame可能已变化，可能多次回调
 */
- (void)didEndRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 是否优先执行dismiss拖拽手势，存在panScrollable时返回YES则dismiss手势优先，scrollView本身滑动无效，默认NO
 * 典型用法：controller view上有全屏tableView，顶部有viewA，需优先拖动viewA时实现
 */
- (BOOL)shouldPrioritizePanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer;

/**
 * 拖拽关闭时，view的y<=shortFormYPos时回调，percent范围0~1，1表示已关闭
 */
- (void)panModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer dismissPercent:(CGFloat)percent;

#pragma mark - 状态变更代理
/**
 * 是否允许变更panModal状态
 */
- (BOOL)shouldTransitionToState:(PresentationState)state;

/**
 * 状态即将变更时回调
 */
- (void)willTransitionToState:(PresentationState)state;

/**
 * 状态变更完成时回调
 */
- (void)didChangeTransitionToState:(PresentationState)state;

#pragma mark - present代理

/**
 * present转场即将开始时回调
 */
- (void)panModalTransitionWillBegin;

/**
 * present转场完成时回调
 */
- (void)panModalTransitionDidFinish;

/**
 * 自定义presented vc已添加到容器时回调
 */
- (void)presentedViewDidMoveToSuperView;

#pragma mark - Dismiss代理
/**
 * 即将关闭时回调
 */
- (void)panModalWillDismiss;

/**
 * 完成关闭时回调
 */
- (void)panModalDidDismissed;

@end

NS_ASSUME_NONNULL_END


#endif /* TFYPANMODALPRESENTABLE_H */
