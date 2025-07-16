//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  UIViewController+PanModalDefault.m
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "UIViewController+PanModalDefault.h"
#import "UIViewController+LayoutHelper.h"

@implementation UIViewController (PanModalDefault)

- (UIScrollView *)panScrollable {
	return nil;
}

- (CGFloat)topOffset {
	return self.topLayoutOffset + 21.f;
}

- (PanModalHeight)shortFormHeight {
	return [self longFormHeight];
}

- (PanModalHeight)mediumFormHeight {
    return [self longFormHeight];
}

- (PanModalHeight)longFormHeight {
    if ([self panScrollable]) {
        UIScrollView *scrollable = [self panScrollable];
        if (!scrollable) return PanModalHeightMake(PanModalHeightTypeMax, 0);
        [scrollable layoutIfNeeded];
        return PanModalHeightMake(PanModalHeightTypeContent, MAX(scrollable.contentSize.height, scrollable.bounds.size.height));
    } else {
        return PanModalHeightMake(PanModalHeightTypeMax, 0);
    }
}

- (PresentationState)originPresentationState {
	return PresentationStateShort;
}

- (CGFloat)springDamping {
	return 0.8;
}

- (NSTimeInterval)transitionDuration {
	return 0.5;
}

- (NSTimeInterval)dismissalDuration {
	return [self transitionDuration];
}

- (UIViewAnimationOptions)transitionAnimationOptions {
	return UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;
}

- (CGFloat)backgroundAlpha {
	return 0.7;
}

- (CGFloat)backgroundBlurRadius {
	return 0;
}

- (nonnull UIColor *)backgroundBlurColor {
    return [UIColor whiteColor];
}

- (TFYBackgroundConfig *)backgroundConfig {
    return [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorDefault];
}

- (UIEdgeInsets)scrollIndicatorInsets {
	CGFloat top = [self shouldRoundTopCorners] ? [self cornerRadius] : 0;
	if (!self.view) return UIEdgeInsetsZero;
	return UIEdgeInsetsMake(top, 0, self.bottomLayoutOffset, 0);
}

- (BOOL)showsScrollableVerticalScrollIndicator {
	return YES;
}

- (BOOL)shouldAutoSetPanScrollContentInset {
    return YES;
}

- (BOOL)anchorModalToLongForm {
	return YES;
}

- (BOOL)allowsExtendedPanScrolling {
    if ([self panScrollable]) {
        UIScrollView *scrollable = [self panScrollable];
        if (!scrollable.superview || !scrollable.window) return NO;
        [scrollable layoutIfNeeded];
        return scrollable.contentSize.height > (scrollable.frame.size.height - self.bottomLayoutOffset);
    }
    return NO;
}

- (BOOL)allowsDragToDismiss {
	return YES;
}

- (CGFloat)minVerticalVelocityToTriggerDismiss {
    return 300;
}

- (BOOL)allowsTapBackgroundToDismiss {
	return YES;
}

- (BOOL)allowScreenEdgeInteractive {
	return NO;
}

- (CGFloat)maxAllowedDistanceToLeftScreenEdgeForPanInteraction {
	return 0;
}

- (CGFloat)minHorizontalVelocityToTriggerScreenEdgeDismiss {
    return 500;
}

- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle {
	return PresentingViewControllerAnimationStyleNone;
}

- (BOOL)shouldEnableAppearanceTransition {
    return YES;
}

- (BOOL)shouldAnimatePresentingVC {
    return NO;
}

- (id <TFYPresentingViewControllerAnimatedTransitioning>)customPresentingVCAnimation {
	return nil;
}

- (BOOL)isPanScrollEnabled {
	return YES;
}

- (BOOL)isUserInteractionEnabled {
	return YES;
}

- (BOOL)allowsPullDownWhenShortState {
    return YES;
}

- (BOOL)isHapticFeedbackEnabled {
	return YES;
}

- (BOOL)allowsTouchEventsPassingThroughTransitionView {
	return NO;
}

- (BOOL)shouldRoundTopCorners {
	return YES;
}

- (CGFloat)cornerRadius {
	return 8;
}

- (TFYPanModalShadow *)contentShadow {
    return [TFYPanModalShadow panModalShadowNil];
}

- (BOOL)showDragIndicator {
    if ([self allowsTouchEventsPassingThroughTransitionView]) {
        return NO;
    }
	return YES;
}

- (nullable UIView <TFYPanModalIndicatorProtocol> *)customIndicatorView {
	return nil;
}

- (BOOL)isAutoHandleKeyboardEnabled {
	return YES;
}

- (CGFloat)keyboardOffsetFromInputView {
    return 5;
}

- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
	return YES;
}

- (void)willRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {

}

- (void)didRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    
}

- (void)didEndRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer {
	
}

- (BOOL)shouldPrioritizePanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
	return NO;
}

- (BOOL)shouldTransitionToState:(PresentationState)state {
	return YES;
}

- (void)willTransitionToState:(PresentationState)state {
}

- (void)didChangeTransitionToState:(PresentationState)state {
}

- (void)panModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer dismissPercent:(CGFloat)percent {

}

- (void)panModalWillDismiss {
    
}

- (void)panModalDidDismissed {
    
}

- (void)panModalTransitionWillBegin {
    
}

- (void)panModalTransitionDidFinish {
    
}

- (void)presentedViewDidMoveToSuperView {
    
}

//#pragma mark - TFYPanModalPanGestureDelegate 默认实现
//
//- (BOOL)tfy_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    return YES;
//}
//
//- (BOOL)tfy_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
//
//- (BOOL)tfy_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
//
//- (BOOL)tfy_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}

@end

