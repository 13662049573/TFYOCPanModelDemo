//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYCustomPresentingVCAnimatedTransitioning.h
//  TFYPanModal
//
//  Created by heath wang on 2019/6/12.
//

#ifndef TFYCustomPresentingVCAnimatedTransitioning_h
#define TFYCustomPresentingVCAnimatedTransitioning_h

/**
 * @protocol TFYPresentingViewControllerContextTransitioning
 * @brief 自定义转场动画上下文协议，提供转场相关的上下文信息。
 */
@protocol TFYPresentingViewControllerContextTransitioning <NSObject>

/**
 * 获取转场相关的控制器。
 * @param key 控制器对应的key（如UITransitionContextFromViewControllerKey等）
 * @return 返回对应的控制器对象，若未找到则为nil。
 */
- (__kindof  UIViewController * _Nullable )viewControllerForKey:(nonnull UITransitionContextViewControllerKey)key;

/**
 * 获取转场动画时长。
 * @return 返回动画持续时间（秒）。
 */
- (NSTimeInterval)transitionDuration;

/**
 * 转场容器视图，参照UIViewControllerContextTransitioning协议。
 */
@property(nonnull, nonatomic, readonly) UIView *containerView;

@end

/**
 * @protocol TFYPresentingViewControllerAnimatedTransitioning
 * @brief 自定义present/dismiss动画协议。
 */
@protocol TFYPresentingViewControllerAnimatedTransitioning <NSObject>

/**
 * 自定义present动画实现。
 * @param context 转场上下文，提供动画所需信息。
 */
- (void)presentAnimateTransition:(nonnull id<TFYPresentingViewControllerContextTransitioning>)context NS_SWIFT_NAME(presentTransition(context:));
/**
 * 自定义dismiss动画实现。
 * @param context 转场上下文，提供动画所需信息。
 */
- (void)dismissAnimateTransition:(nonnull id<TFYPresentingViewControllerContextTransitioning>)context NS_SWIFT_NAME(dismissTransition(context:));

@end


#endif /* TFYCustomPresentingVCAnimatedTransitioning_h */



