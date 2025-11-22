//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPageSheetPresentingAnimation.m
//  TFYPanModal
//
//  Created by heath wang on 2019/9/5.
//

#import <Foundation/Foundation.h>
#import <TFYOCPanlModel/TFYPageSheetPresentingAnimation.h>

@implementation TFYPageSheetPresentingAnimation

/**
 * @brief present动画实现，仿iOS页面表单弹窗缩放。
 * @param context 转场上下文，提供动画所需信息。
 */
- (void)presentAnimateTransition:(nonnull id <TFYPresentingViewControllerContextTransitioning>)context {
    if (!context) return;
    NSTimeInterval duration = [context transitionDuration];
    UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    // 使用弹簧动画实现fromVC缩放，突出弹窗效果
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        CGFloat statusBarHeight = statusBarManager.statusBarFrame.size.height;
        CGFloat scale = 1 - statusBarHeight * 2 / CGRectGetHeight(fromVC.view.bounds);
        fromVC.view.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        // 动画完成后可扩展处理
    }];
}

/**
 * @brief dismiss动画实现，恢复原始缩放。
 * @param context 转场上下文，提供动画所需信息。
 */
- (void)dismissAnimateTransition:(nonnull id <TFYPresentingViewControllerContextTransitioning>)context {
    if (!context) return;
    UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.transform = CGAffineTransformIdentity;
}

@end
