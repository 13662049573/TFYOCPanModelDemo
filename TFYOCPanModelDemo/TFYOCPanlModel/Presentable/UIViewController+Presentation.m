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

- (void)tfy_panModalTransitionTo:(PresentationState)state {
    if (!self.tfy_presentedVC) return;
    [self.tfy_presentedVC transitionToState:state animated:YES];
}

- (void)tfy_panModalTransitionTo:(PresentationState)state animated:(BOOL)animated {
    if (!self.tfy_presentedVC) return;
    [self.tfy_presentedVC transitionToState:state animated:animated];
}

- (void)tfy_panModalSetContentOffset:(CGPoint)offset animated:(BOOL)animated {
    if (!self.tfy_presentedVC) return;
    [self.tfy_presentedVC setScrollableContentOffset:offset animated:animated];
}


- (void)tfy_panModalSetContentOffset:(CGPoint)offset {
    if (!self.tfy_presentedVC) return;
    [self.tfy_presentedVC setScrollableContentOffset:offset animated:YES];
}

- (void)tfy_panModalSetNeedsLayoutUpdate {
    if (!self.tfy_presentedVC) return;
    [self.tfy_presentedVC setNeedsLayoutUpdate];
}

- (void)tfy_panModalUpdateUserHitBehavior {
    if (!self.tfy_presentedVC) return;
    [self.tfy_presentedVC updateUserHitBehavior];
}

- (void)tfy_dismissAnimated:(BOOL)animated completion:(void (^)(void))completion{
    if (!self.tfy_presentedVC) { if (completion) completion(); return; }
    [self.tfy_presentedVC dismissAnimated:animated completion:completion];
}

- (TFYDimmedView *)tfy_dimmedView {
    if (!self.tfy_presentedVC) return nil;
    return self.tfy_presentedVC.backgroundView;
}

- (UIView *)tfy_rootContainerView {
    if (!self.tfy_presentedVC) return nil;
    return self.tfy_presentedVC.containerView;
}

- (UIView *)tfy_contentView {
    if (!self.tfy_presentedVC) return nil;
    return self.tfy_presentedVC.presentedView;
}

- (PresentationState)tfy_presentationState {
    if (!self.tfy_presentedVC) return PresentationStateShort;
    return self.tfy_presentedVC.currentPresentationState;
}

@end
