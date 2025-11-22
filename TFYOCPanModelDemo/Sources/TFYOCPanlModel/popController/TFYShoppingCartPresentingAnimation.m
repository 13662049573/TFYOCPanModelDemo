//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYShoppingCartPresentingAnimation.m
//  TFYPanModal
//
//  Created by heath wang on 2019/9/5.
//

#import <TFYOCPanlModel/TFYShoppingCartPresentingAnimation.h>

@implementation TFYShoppingCartPresentingAnimation

/**
 * @brief present动画实现，分两段动画实现购物车弹窗的立体缩放。
 * @param context 转场上下文，提供动画所需信息。
 */
- (void)presentAnimateTransition:(nonnull id <TFYPresentingViewControllerContextTransitioning>)context {
    if (!context) return;
    NSTimeInterval duration = [context transitionDuration];
    UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
    UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
    CGFloat statusBarHeight = statusBarManager.statusBarFrame.size.height;
    CGFloat scale = 1 - statusBarHeight * 2 / CGRectGetHeight(fromVC.view.bounds);
    // 第一段动画：3D旋转和Z轴平移，突出立体感
    [UIView animateWithDuration:duration * 0.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D tran = CATransform3DIdentity;
        tran.m34 = -1 / 1000.0f; // 透视效果
        tran = CATransform3DRotate(tran, M_PI / 16, 1, 0, 0);
        tran = CATransform3DTranslate(tran, 0, 0, -100);
        fromVC.view.layer.transform = tran;
    } completion:^(BOOL finished) {
        // 第二段动画：缩放到目标比例
        [UIView animateWithDuration:duration * 0.6 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromVC.view.layer.transform = CATransform3DMakeScale(scale, scale, 1);
        } completion:^(BOOL finished) {
            // 动画完成后可扩展处理
        }];
    }];
}

/**
 * @brief dismiss动画实现，恢复原始3D变换。
 * @param context 转场上下文，提供动画所需信息。
 */
- (void)dismissAnimateTransition:(nonnull id <TFYPresentingViewControllerContextTransitioning>)context {
    if (!context) return;
    UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.layer.transform = CATransform3DIdentity;
}

@end
