//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalPresentationDelegate.m
//  TFYPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "TFYPanModalPresentationDelegate.h"
#import "TFYPanModalPresentationAnimator.h"
#import "TFYPanModalPresentationController.h"
#import "TFYPanModalInteractiveAnimator.h"

/**
 * @brief PanModal弹窗的转场代理实现，负责动画与交互的管理。
 * @discussion 实现UIViewControllerTransitioningDelegate等协议，统一管理present/dismiss动画与交互。
 */

@interface TFYPanModalPresentationDelegate ()

@property (nonatomic, strong) TFYPanModalInteractiveAnimator *interactiveDismissalAnimator;

@end

@implementation TFYPanModalPresentationDelegate

/**
 * @brief 返回present动画控制器
 * @return present动画控制器对象
 */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	return [[TFYPanModalPresentationAnimator alloc] initWithTransitionStyle:TransitionStylePresentation interactiveMode:PanModalInteractiveModeNone];
}

/**
 * @brief 返回dismiss动画控制器
 * @return dismiss动画控制器对象
 */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	return [[TFYPanModalPresentationAnimator alloc] initWithTransitionStyle:TransitionStyleDismissal interactiveMode:self.interactiveMode];
}

/**
 * @brief 返回交互式关闭的动画控制器
 * @return 交互式动画控制器对象，若非交互式则为nil
 */
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
	if (self.interactive) {
		return self.interactiveDismissalAnimator;
	}

	return nil;
}

/**
 * @brief 返回自定义的UIPresentationController
 * @return 自定义的presentationController对象
 */
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    TFYPanModalPresentationController *controller = [[TFYPanModalPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    controller.delegate = self;
    self.strongPresentationController = controller; // 强引用，防止提前释放
    return controller;
}

#pragma mark - UIAdaptivePresentationControllerDelegate

/**
 * @brief 指定自适应时的展示样式（始终不自适应）
 * @return UIModalPresentationNone
 */
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
	return UIModalPresentationNone;
}

#pragma mark - Getter

/**
 * @brief 懒加载交互式关闭动画器
 * @return 交互式关闭动画器对象
 */
- (TFYPanModalInteractiveAnimator *)interactiveDismissalAnimator {
	if (!_interactiveDismissalAnimator) {
		_interactiveDismissalAnimator = [[TFYPanModalInteractiveAnimator alloc] init];
	}
	return _interactiveDismissalAnimator;
}

#ifdef DEBUG

/**
 * @brief 调试模式下析构日志，便于排查内存问题
 */
- (void)dealloc {
    self.strongPresentationController = nil; // 释放引用，防止悬挂指针
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

#endif

@end
