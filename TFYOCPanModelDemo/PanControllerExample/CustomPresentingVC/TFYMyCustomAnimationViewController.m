//
//  TFYMyCustomAnimationViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/6/12.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYMyCustomAnimationViewController.h"
#import "TFYOCPanlModel.h"

// define object conforms TFYPresentingViewControllerAnimatedTransitioning
@interface TFYMyCustomAnimation : NSObject <TFYPresentingViewControllerAnimatedTransitioning>

@end

@interface TFYMyCustomAnimationViewController () <TFYPanModalPresentable>

@property (nonatomic, strong) TFYMyCustomAnimation *customAnimation;

@end

@implementation TFYMyCustomAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.600 green:1.000 blue:0.600 alpha:1.00];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return  UIStatusBarStyleLightContent;
//}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 84);
}

- (CGFloat)topOffset {
    return 0;
}


- (BOOL)allowScreenEdgeInteractive {
    return YES;
}

- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle {
    return PresentingViewControllerAnimationStyleCustom;
}

- (id<TFYPresentingViewControllerAnimatedTransitioning>)customPresentingVCAnimation {
    return self.customAnimation;
}

- (TFYMyCustomAnimation *)customAnimation {
    if (!_customAnimation) {
        _customAnimation = [TFYMyCustomAnimation new];
    }
    return _customAnimation;
}

@end

@implementation TFYMyCustomAnimation


- (void)presentAnimateTransition:(nonnull id <TFYPresentingViewControllerContextTransitioning>)context {
    NSTimeInterval duration = [context transitionDuration];
    UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissAnimateTransition:(nonnull id <TFYPresentingViewControllerContextTransitioning>)context {
    // no need for using animating block.
    UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.transform = CGAffineTransformIdentity;
}

@end
