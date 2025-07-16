//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalPresentationAnimator.m
//  TFYPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "TFYPanModalPresentationAnimator.h"
#import "TFYPanModalAnimator.h"
#import "UIViewController+LayoutHelper.h"
#import "TFYPanContainerView.h"
#import "UIView+TFY_Frame.h"
#import "TFYPageSheetPresentingAnimation.h"
#import "TFYShoppingCartPresentingAnimation.h"

// =====================
// 详细中文注释与健壮性补充
// =====================
//
// 1. 构造方法、转场动画、交互动画、回调等关键方法补充中文注释
// 2. 重要属性、内部状态、回调点补充注释
// 3. 关键分支、易混淆逻辑增加注释说明
//
// 转场动画器
@interface TFYPresentingVCTransitionContext : NSObject <TFYPresentingViewControllerContextTransitioning>

@property (nonatomic, weak) UIViewController *fromVC;
@property (nonatomic, weak) UIViewController *toVC;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) UIView *containerView;

- (instancetype)initWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC duration:(NSTimeInterval)duration containerView:(UIView *)containerView;

@end

@interface TFYPanModalPresentationAnimator ()

@property (nonatomic, assign) TransitionStyle transitionStyle;

@property (nullable, nonatomic, strong) UISelectionFeedbackGenerator *feedbackGenerator API_AVAILABLE(ios(10.0));
@property (nonatomic, strong) TFYPresentingVCTransitionContext *presentingVCTransitionContext;
@property (nonatomic, assign) PanModalInteractiveMode interactiveMode;

@end

@implementation TFYPanModalPresentationAnimator

- (instancetype)initWithTransitionStyle:(TransitionStyle)transitionStyle interactiveMode:(PanModalInteractiveMode)mode {
	self = [super init];
	if (self) {
		_transitionStyle = transitionStyle;
		_interactiveMode = mode;
		if (transitionStyle == TransitionStylePresentation) {
			if (@available(iOS 10.0, *)) {
				_feedbackGenerator = [UISelectionFeedbackGenerator new];
				[_feedbackGenerator prepare];
			} else {
				// Fallback on earlier versions
			}
		}
	}

	return self;
}

/**
 * 弹出controller动画
 */
- (void)animatePresentation:(id<UIViewControllerContextTransitioning>)context {

	UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
	if (!toVC && !fromVC)
		return;
    
    UIViewController<TFYPanModalPresentable> *presentable = [self panModalViewController:context];

    if ([presentable shouldEnableAppearanceTransition]) {
        // If you are implementing a custom container controller, use this method to tell the child that its views are about to appear or disappear.
        [fromVC beginAppearanceTransition:NO animated:YES];
        [self beginAppearanceTransitionForController:toVC isAppearing:YES animated:YES];
    }
    
    
	CGFloat yPos = presentable.shortFormYPos;
	if ([presentable originPresentationState] == PresentationStateLong) {
		yPos = presentable.longFormYPos;
    } else if ([presentable originPresentationState] == PresentationStateMedium) {
        yPos = presentable.mediumFormYPos;
    }

	UIView *panView = context.containerView.panContainerView ?: toVC.view;
	panView.frame = [context finalFrameForViewController:toVC];
	panView.tfy_top = context.containerView.frame.size.height;

	if ([presentable isHapticFeedbackEnabled]) {
        if (@available(iOS 10.0, *)) {
            [self.feedbackGenerator selectionChanged];
        }
	}

	[TFYPanModalAnimator animate:^{
		panView.tfy_top = yPos;
	} config:presentable completion:^(BOOL completion) {
        
        if ([presentable shouldEnableAppearanceTransition]) {
            [fromVC endAppearanceTransition];
            [self endAppearanceTransitionForController:toVC];
        }
		
        if (@available(iOS 10.0, *)) {
            self.feedbackGenerator = nil;
        }

		[context completeTransition:completion];
	}];

	self.presentingVCTransitionContext = [[TFYPresentingVCTransitionContext alloc] initWithFromVC:fromVC toVC:toVC duration:[presentable transitionDuration] containerView:context.containerView];
	[self presentAnimationForPresentingVC:presentable];
}

/**
 * 使弹出controller消失动画
 */
- (void)animateDismissal:(id<UIViewControllerContextTransitioning>)context {

	UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
	if (!fromVC && !toVC)
		return;
    
    UIViewController<TFYPanModalPresentable> *presentable = [self panModalViewController:context];

    
    if ([presentable shouldEnableAppearanceTransition]) {
        [self beginAppearanceTransitionForController:fromVC isAppearing:NO animated:YES];
        [toVC beginAppearanceTransition:YES animated:YES];
    }
	
	UIView *panView = context.containerView.panContainerView ?: fromVC.view;
    self.presentingVCTransitionContext = [[TFYPresentingVCTransitionContext alloc] initWithFromVC:fromVC toVC:toVC duration:[presentable transitionDuration] containerView:context.containerView];

    // user toggle pan gesture to dismiss.
	if ([context isInteractive]) {
		[self interactionDismiss:context fromVC:fromVC toVC:toVC presentable:presentable panView:panView];
	} else {
		[self springDismiss:context fromVC:fromVC toVC:toVC presentable:presentable panView:panView];
	}
}

- (void)springDismiss:(id <UIViewControllerContextTransitioning>)context fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC presentable:(UIViewController <TFYPanModalPresentable> *)presentable panView:(UIView *)panView {
	CGFloat offsetY = 0;
	TFYPanModalShadow *shadowConfig = [presentable contentShadow];
	if (shadowConfig.shadowColor) {
		// we should make the panView move further to hide the shadow effect.
		offsetY = offsetY + shadowConfig.shadowRadius + shadowConfig.shadowOffset.height;
		if ([presentable showDragIndicator]) {
			offsetY += [presentable customIndicatorView] ? [presentable customIndicatorView].indicatorSize.height : 13;
		}
	}

	[TFYPanModalAnimator dismissAnimate:^{
		[self dismissAnimationForPresentingVC:presentable];
		panView.tfy_top = (context.containerView.frame.size.height + offsetY);
	} config:presentable completion:^(BOOL completion) {
		[fromVC.view removeFromSuperview];
        
        if ([presentable shouldEnableAppearanceTransition]) {
            [self endAppearanceTransitionForController:fromVC];
            [toVC endAppearanceTransition];
        }
		
		[context completeTransition:completion];
	}];
}

- (void)interactionDismiss:(id <UIViewControllerContextTransitioning>)context fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC presentable:(UIViewController <TFYPanModalPresentable> *)presentable panView:(UIView *)panView {
	[TFYPanModalAnimator smoothAnimate:^{
		if (self.interactiveMode == PanModalInteractiveModeSideslip) {
			panView.tfy_left = panView.tfy_width;
		}

		[self dismissAnimationForPresentingVC:presentable];
	} duration:[presentable dismissalDuration] completion:^(BOOL completion) {
		// 因为会有手势交互，所以需要判断transitions是否cancel
		BOOL finished = ![context transitionWasCancelled];

		if (finished) {
			[fromVC.view removeFromSuperview];
            
            if ([presentable shouldEnableAppearanceTransition]) {
                [self endAppearanceTransitionForController:fromVC];
                [toVC endAppearanceTransition];
            }
			
			context.containerView.userInteractionEnabled = YES;
		}
		[context completeTransition:finished];
	}];
}

#pragma mark - presenting VC animation

- (void)presentAnimationForPresentingVC:(UIViewController<TFYPanModalPresentable> *)presentable {
	id<TFYPresentingViewControllerAnimatedTransitioning> presentingAnimation = [self presentingVCAnimation:presentable];
	if (presentingAnimation) {
		[presentingAnimation presentAnimateTransition:self.presentingVCTransitionContext];
	}
}

- (void)dismissAnimationForPresentingVC:(UIViewController<TFYPanModalPresentable> *)presentable {
    id<TFYPresentingViewControllerAnimatedTransitioning> presentingAnimation = [self presentingVCAnimation:presentable];
    if (presentingAnimation) {
        [presentingAnimation dismissAnimateTransition:self.presentingVCTransitionContext];
    }
}

- (UIViewController <TFYPanModalPresentable> *)panModalViewController:(id <UIViewControllerContextTransitioning>)context {
	switch (self.transitionStyle) {
		case TransitionStylePresentation: {
			UIViewController *controller = [context viewControllerForKey:UITransitionContextToViewControllerKey];
			if ([controller conformsToProtocol:@protocol(TFYPanModalPresentable)]) {
				return (UIViewController <TFYPanModalPresentable> *) controller;
			} else {
				return nil;
			}
		}
		case TransitionStyleDismissal: {
			UIViewController *controller = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
			if ([controller conformsToProtocol:@protocol(TFYPanModalPresentable)]) {
				return (UIViewController <TFYPanModalPresentable> *) controller;
			} else {
				return nil;
			}
		}
	}
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext { 
	switch (self.transitionStyle) {
		case TransitionStylePresentation: {
			[self animatePresentation:transitionContext];
		}
			break;
		case TransitionStyleDismissal: {
			[self animateDismissal:transitionContext];
		}
		default:
			break;
	}
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
	if (transitionContext && [self panModalViewController:transitionContext]) {
		UIViewController<TFYPanModalPresentable> *controller = [self panModalViewController:transitionContext];
		return [controller transitionDuration];
	}
	return kTransitionDuration;
}

#pragma mark - presenting animated transition

- (id<TFYPresentingViewControllerAnimatedTransitioning>)presentingVCAnimation:(UIViewController<TFYPanModalPresentable> *)presentable {
	switch ([presentable presentingVCAnimationStyle]) {
		case PresentingViewControllerAnimationStylePageSheet:
			return [TFYPageSheetPresentingAnimation new];
		case PresentingViewControllerAnimationStyleShoppingCart:
			return [TFYShoppingCartPresentingAnimation new];
		case PresentingViewControllerAnimationStyleCustom:
			return [presentable customPresentingVCAnimation];
		default:
			return nil;
	}
}

#pragma mark - private method

- (void)beginAppearanceTransitionForController:(UIViewController *)viewController isAppearing:(BOOL)isAppearing animated:(BOOL)animated {
    // Fix `The unbalanced calls to begin/end appearance transitions` warning.
    if (![viewController isKindOfClass:UINavigationController.class]) {
        [viewController beginAppearanceTransition:isAppearing animated:animated];
    }
}

- (void)endAppearanceTransitionForController:(UIViewController *)viewController {
    if (![viewController isKindOfClass:UINavigationController.class]) {
        [viewController endAppearanceTransition];
    }
}

- (void)dealloc {
    self.feedbackGenerator = nil;
    self.presentingVCTransitionContext = nil;
}

@end

@implementation TFYPresentingVCTransitionContext

- (instancetype)initWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC duration:(NSTimeInterval)duration containerView:(UIView *)containerView {
	self = [super init];
	if (self) {
		_fromVC = fromVC;
		_toVC = toVC;
		_duration = duration;
		_containerView = containerView;
	}

	return self;
}


- (__kindof UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key {
    if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
        return self.fromVC;
    } else if ([key isEqualToString:UITransitionContextToViewControllerKey]) {
        return self.toVC;
    }
	return nil;
}

- (NSTimeInterval)transitionDuration {
	return self.duration;
}

@end
