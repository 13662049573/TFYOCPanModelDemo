//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  UIViewController+LayoutHelper.m
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "UIViewController+LayoutHelper.h"
#import "TFYPanModalPresentationController.h"
#import "UIViewController+PanModalDefault.h"

@implementation UIViewController (LayoutHelper)

- (CGFloat)topLayoutOffset {
    if (@available(iOS 15.0, *)) {
        UIWindow *window = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                if (window) break;
            }
        }
        if (!window) return 0;
        return window.safeAreaInsets.top;
    } else {
        return 0;
    }
}

- (CGFloat)bottomLayoutOffset {
    if (@available(iOS 15.0, *)) {
        UIWindow *window = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                if (window) break;
            }
        }
        if (!window) return 0;
        return window.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}

- (TFYPanModalPresentationController *)pan_presentedVC {
    if (self.presentingViewController) {
        return [self pan_getPanModalPresentationController];
    } else {
        return nil;
    }
}

- (TFYPanModalPresentationController *)pan_getPanModalPresentationController {
    UIViewController *ancestorsVC;
    
    // seeking for the root presentation VC.
    if (self.splitViewController) {
        ancestorsVC = self.splitViewController;
    } else if (self.navigationController) {
        ancestorsVC = self.navigationController;
    } else if (self.tabBarController) {
        ancestorsVC = self.tabBarController;
    } else {
        ancestorsVC = self;
    }
    
    if ([ancestorsVC.presentationController isMemberOfClass:TFYPanModalPresentationController.class]) {
        return (TFYPanModalPresentationController *) ancestorsVC.presentationController;
    }
    return nil;
}

/**
 Returns the short form Y postion

 - Note: If voiceover is on, the `longFormYPos` is returned.
 We do not support short form when voiceover is on as it would make it difficult for user to navigate.
*/
- (CGFloat)shortFormYPos {
    if (UIAccessibilityIsVoiceOverRunning()) {
        return self.longFormYPos;
    } else {
        if (!self.view) return 0;
        CGFloat shortFormYPos = [self topMarginFromPanModalHeight:[self shortFormHeight]] + [self topOffset];
		return MAX(shortFormYPos, self.longFormYPos);
    }
}

- (CGFloat)mediumFormYPos {
    if (UIAccessibilityIsVoiceOverRunning()) {
        return self.longFormYPos;
    } else {
        if (!self.view) return 0;
        CGFloat mediumFormYPos = [self topMarginFromPanModalHeight:[self mediumFormHeight]] + [self topOffset];
        return MAX(mediumFormYPos, self.longFormYPos);
    }
}

- (CGFloat)longFormYPos {
    if (!self.view) return 0;
	return MAX([self topMarginFromPanModalHeight:[self longFormHeight]], [self topMarginFromPanModalHeight:PanModalHeightMake(PanModalHeightTypeMax, 0)]) + [self topOffset];
}

/**
 * Use the container view for relative positioning as this view's frame
   is adjusted in PanModalPresentationController
 */
- (CGFloat)bottomYPos {
    if (self.pan_presentedVC && self.pan_presentedVC.containerView) {
        return self.pan_presentedVC.containerView.bounds.size.height - [self topOffset];
    }
    if (!self.view) return 0;
	return self.view.bounds.size.height;
}

- (CGFloat)topMarginFromPanModalHeight:(PanModalHeight)panModalHeight {
    if (!self.view) return 0;
	switch (panModalHeight.heightType) {
		case PanModalHeightTypeMax:
			return 0.0f;
		case PanModalHeightTypeMaxTopInset:
			return panModalHeight.height;
		case PanModalHeightTypeContent:
			return self.bottomYPos - (panModalHeight.height + self.bottomLayoutOffset);
		case PanModalHeightTypeContentIgnoringSafeArea:
			return self.bottomYPos - panModalHeight.height;
		case PanModalHeightTypeIntrinsic:
		{
			[self.view layoutIfNeeded];

            CGSize targetSize = CGSizeMake(self.pan_presentedVC && self.pan_presentedVC.containerView ? self.pan_presentedVC.containerView.bounds.size.width : [UIScreen mainScreen].bounds.size.width, UILayoutFittingCompressedSize.height);
            CGFloat intrinsicHeight = [self.view systemLayoutSizeFittingSize:targetSize].height;
			return self.bottomYPos - (intrinsicHeight + self.bottomLayoutOffset);
		}
		default:
			return 0;
	}
}

@end
