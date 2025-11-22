//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalContentView.m
//  TFYPanModal
//
//  Created by heath wang on 2019/10/17.
//

#import "TFYPanModalContentView.h"
#import "TFYPanModalContainerView.h"

@interface TFYPanModalContentView ()

@property (nonatomic, weak) TFYPanModalContainerView *containerView;

@end

@implementation TFYPanModalContentView

#pragma mark - public method

- (void)presentInView:(UIView *)view {
    if (!view) {
        view = [self findKeyWindow];
    }
    if (self.containerView) {
        // 已经present，先移除旧containerView，防止重复present和内存泄漏
        [self.containerView removeFromSuperview];
        _containerView = nil;
    }
    if (!view) return; // 防御性编程，找不到window时直接返回
    TFYPanModalContainerView *containerView = [[TFYPanModalContainerView alloc] initWithPresentingView:view contentView:self];
    [containerView show];
}

- (void)dismissAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (!self.containerView) { if (completion) completion(); return; }
    __weak typeof(self) weakSelf = self;
    [self.containerView dismissAnimated:flag completion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (completion) completion();
        // 移除containerView，防止悬挂指针
        strongSelf->_containerView = nil;
    }];
}

#pragma mark - TFYPanModalPresentationUpdateProtocol

- (void)pan_panModalTransitionTo:(PresentationState)state {
    [self.containerView transitionToState:state animated:YES];
}

- (void)pan_panModalSetContentOffset:(CGPoint)offset {
    [self.containerView setScrollableContentOffset:offset animated:YES];
}

- (void)pan_panModalSetNeedsLayoutUpdate {
    [self.containerView setNeedsLayoutUpdate];
}

- (void)pan_panModalUpdateUserHitBehavior {
    [self.containerView updateUserHitBehavior];
}

- (void)pan_panModalTransitionTo:(PresentationState)state animated:(BOOL)animated {
    [self.containerView transitionToState:state animated:animated];
}

- (void)pan_panModalSetContentOffset:(CGPoint)offset animated:(BOOL)animated {
    [self.containerView setScrollableContentOffset:offset animated:animated];
}

- (void)pan_dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self dismissAnimated:animated completion:completion];
}

- (TFYDimmedView *)pan_dimmedView {
    return self.containerView.backgroundView;
}

- (UIView *)pan_rootContainerView {
    return self.containerView;
}

- (UIView *)pan_contentView {
    return (UIView *)self.containerView.panContainerView;
}

- (PresentationState)pan_presentationState {
    return self.containerView.currentPresentationState;
}

#pragma mark - TFYPanModalPresentable

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
        [[self panScrollable] layoutIfNeeded];
        return PanModalHeightMake(PanModalHeightTypeContent, MAX([self panScrollable].contentSize.height, [self panScrollable].bounds.size.height));
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
        [scrollable layoutIfNeeded];
        return scrollable.contentSize.height > (scrollable.frame.size.height - self.bottomLayoutOffset);
    } else {
        return NO;
    }
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

- (BOOL)allowsPullDownWhenShortState {
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
    return [self shouldRoundTopCorners];
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

- (BOOL)shouldEnableAppearanceTransition {
    return YES;
}

#pragma mark - TFYPanModalPresentableLayoutProtocol

- (CGFloat)topLayoutOffset {
    return 0;
}

- (CGFloat)bottomLayoutOffset {
    return 0;
}

- (CGFloat)shortFormYPos {
    CGFloat shortFormYPos = [self topMarginFromPanModalHeight:[self shortFormHeight]] + [self topOffset];
    return MAX(shortFormYPos, self.longFormYPos);
}

- (CGFloat)mediumFormYPos {
    CGFloat mediumFormYPos = [self topMarginFromPanModalHeight:[self mediumFormHeight]] + [self topOffset];
    return MAX(mediumFormYPos, self.longFormYPos);
}

- (CGFloat)longFormYPos {
    CGFloat longFrom = MAX([self topMarginFromPanModalHeight:[self longFormHeight]], [self topMarginFromPanModalHeight:PanModalHeightMake(PanModalHeightTypeMax, 0)]) + [self topOffset];
    return longFrom;
}

- (CGFloat)bottomYPos {
    if (self.containerView) {
        return self.containerView.bounds.size.height - [self topOffset];
    }
    return self.bounds.size.height;
}

- (CGFloat)topMarginFromPanModalHeight:(PanModalHeight)panModalHeight {
    switch (panModalHeight.heightType) {
        case PanModalHeightTypeMax:
            return 0.0f;
        case PanModalHeightTypeMaxTopInset:
            return panModalHeight.height;
        case PanModalHeightTypeContent:
            return self.bottomYPos - (panModalHeight.height + self.bottomLayoutOffset);
        case PanModalHeightTypeContentIgnoringSafeArea:
            return self.bottomYPos - panModalHeight.height;
        case PanModalHeightTypeIntrinsic: {
            [self layoutIfNeeded];

            CGSize targetSize = CGSizeMake(self.containerView ? self.containerView.bounds.size.width : [UIScreen mainScreen].bounds.size.width, UILayoutFittingCompressedSize.height);
            CGFloat intrinsicHeight = [self systemLayoutSizeFittingSize:targetSize].height;
            return self.bottomYPos - (intrinsicHeight + self.bottomLayoutOffset);
        }
        default:
            return 0;
    }
}

#pragma mark - Getter

- (TFYPanModalContainerView *)containerView {
    // we assume the container view will not change after we got it.
    if (!_containerView) {
        UIView *fatherView = self.superview;
        while (fatherView) {
            if ([fatherView isKindOfClass:TFYPanModalContainerView.class]) {
                _containerView = (TFYPanModalContainerView *) fatherView;
                break;
            }
            fatherView = fatherView.superview;
        }
    }

    return _containerView;
}

- (UIView *)findKeyWindow {
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if ([scene isKindOfClass:UIWindowScene.class]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *tmpWindow in windowScene.windows) {
                    if ([tmpWindow isKeyWindow]) {
                        return tmpWindow;
                    }
                }
            }
        }
    } 
    return nil;
}

#pragma mark - 防频繁点击配置

- (BOOL)shouldPreventFrequentTapping {
    return YES; // 默认不启用防频繁点击
}

- (NSTimeInterval)frequentTapPreventionInterval {
    return 1.0; // 默认1秒间隔
}

- (BOOL)shouldShowFrequentTapPreventionHint {
    return NO; // 默认不显示提示
}

- (nullable NSString *)frequentTapPreventionHintText {
    return @"请稍后再试"; // 默认提示文本
}

- (void)panModalFrequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime {
    // 默认实现为空，子类可以重写
}

- (void)dealloc {
    if (_containerView) {
        [_containerView removeFromSuperview];
        _containerView = nil;
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
