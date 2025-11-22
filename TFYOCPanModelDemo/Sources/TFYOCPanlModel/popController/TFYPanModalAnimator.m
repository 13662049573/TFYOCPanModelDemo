//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalAnimator.m
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <TFYOCPanlModel/TFYPanModalAnimator.h>

@implementation TFYPanModalAnimator

+ (void)animate:(AnimationBlockType)animations config:(nullable id<TFYPanModalPresentable>)config completion:(AnimationCompletionType)completion {
	[TFYPanModalAnimator animate:animations config:config startingFromPercent:1 isPresentation:YES completion:completion];
}

+ (void)dismissAnimate:(AnimationBlockType)animations config:(nullable id<TFYPanModalPresentable>)config completion:(AnimationCompletionType)completion {
    [TFYPanModalAnimator animate:animations config:config startingFromPercent:1 isPresentation:NO completion:completion];
}

+ (void)animate:(AnimationBlockType)animations config:(nullable id <TFYPanModalPresentable>)config startingFromPercent:(CGFloat)animationPercent isPresentation:(BOOL)flag completion:(AnimationCompletionType)completion {

    NSTimeInterval duration;
    if  (flag) {
        duration = config ? [config transitionDuration] : kTransitionDuration;
    } else {
        duration = config ? [config dismissalDuration] : kTransitionDuration;
    }

    duration = duration * MAX(animationPercent, 0);
    CGFloat springDamping = config ? [config springDamping] : 1.0;
    UIViewAnimationOptions options = config ? [config transitionAnimationOptions] : UIViewAnimationOptionPreferredFramesPerSecondDefault;

    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:springDamping initialSpringVelocity:0 options:options animations:animations ? animations : ^{} completion:completion ? completion : nil];
}

+ (void)smoothAnimate:(AnimationBlockType)animations duration:(NSTimeInterval)duration completion:(nullable AnimationCompletionType)completion {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:animations ? animations : ^{} completion:completion ? completion : nil];
}

@end
