//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  UIViewController+Presentation.m
//  TFYPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "UIViewController+Presentation.h"
#import "UIViewController+LayoutHelper.h"
#import "TFYPanModalPresentationController.h"

@interface UIViewController ()

@end

@implementation UIViewController (Presentation)

- (void)pan_panModalTransitionTo:(PresentationState)state {
    if (!self.pan_presentedVC) return;
    [self.pan_presentedVC transitionToState:state animated:YES];
}

- (void)pan_panModalTransitionTo:(PresentationState)state animated:(BOOL)animated {
    if (!self.pan_presentedVC) return;
    [self.pan_presentedVC transitionToState:state animated:animated];
}

- (void)pan_panModalSetContentOffset:(CGPoint)offset animated:(BOOL)animated {
    if (!self.pan_presentedVC) return;
    [self.pan_presentedVC setScrollableContentOffset:offset animated:animated];
}


- (void)pan_panModalSetContentOffset:(CGPoint)offset {
    if (!self.pan_presentedVC) return;
    [self.pan_presentedVC setScrollableContentOffset:offset animated:YES];
}

- (void)pan_panModalSetNeedsLayoutUpdate {
    if (!self.pan_presentedVC) return;
    [self.pan_presentedVC setNeedsLayoutUpdate];
}

- (void)pan_panModalUpdateUserHitBehavior {
    if (!self.pan_presentedVC) return;
    [self.pan_presentedVC updateUserHitBehavior];
}

- (void)pan_dismissAnimated:(BOOL)animated completion:(void (^)(void))completion{
    if (!self.pan_presentedVC) { if (completion) completion(); return; }
    [self.pan_presentedVC dismissAnimated:animated completion:completion];
}

- (TFYDimmedView *)pan_dimmedView {
    if (!self.pan_presentedVC) return nil;
    return self.pan_presentedVC.backgroundView;
}

- (UIView *)pan_rootContainerView {
    if (!self.pan_presentedVC) return nil;
    return self.pan_presentedVC.containerView;
}

- (UIView *)pan_contentView {
    if (!self.pan_presentedVC) return nil;
    return self.pan_presentedVC.presentedView;
}

- (PresentationState)pan_presentationState {
    if (!self.pan_presentedVC) return PresentationStateShort;
    return self.pan_presentedVC.currentPresentationState;
}

@end
