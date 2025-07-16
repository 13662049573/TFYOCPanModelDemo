//
//  TFYNavViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYNavViewController.h"
#import "TFYOCPanlModel.h"
#import "TFYFetchDataViewController.h"

@interface TFYNavViewController () <TFYPanModalPresentable>

@end

@implementation TFYNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // use custom navigation bar
    self.navigationBarHidden = YES;
    TFYFetchDataViewController *fetchDataVC = [TFYFetchDataViewController new];
//    [self pushViewController:fetchDataVC animated:YES];
    self.viewControllers = @[fetchDataVC];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

#pragma mark - overridden to update panModal

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self tfy_panModalSetNeedsLayoutUpdate];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *controller = [super popViewControllerAnimated:animated];
    [self tfy_panModalSetNeedsLayoutUpdate];
    return controller;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *viewControllers = [super popToViewController:viewController animated:animated];
    [self tfy_panModalSetNeedsLayoutUpdate];
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *viewControllers = [super popToRootViewControllerAnimated:animated];
    [self tfy_panModalSetNeedsLayoutUpdate];
    return viewControllers;
}

#pragma mark - TFYPanModalPresentable

- (UIScrollView *)panScrollable {
    UIViewController *VC = self.topViewController;
    if ([VC conformsToProtocol:@protocol(TFYPanModalPresentable)]) {
        id<TFYPanModalPresentable> obj = VC;
        return [obj panScrollable];
    }
    return nil;
}

- (CGFloat)topOffset {
    return 0;
}

- (PanModalHeight)longFormHeight {
    // we will let child vc to config panModal
    UIViewController *VC = self.topViewController;
    if ([VC conformsToProtocol:@protocol(TFYPanModalPresentable)]) {
        id<TFYPanModalPresentable> obj = VC;
        return [obj longFormHeight];
    }
    CGFloat statusBarHeight = 0;
    if (@available(iOS 15.0, *)) {
        UIWindow *keyWindow = nil;
        for (UIWindow *window in [UIApplication sharedApplication].connectedScenes) {
            if ([window isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)window;
                for (UIWindow *w in windowScene.windows) {
                    if (w.isKeyWindow) {
                        keyWindow = w;
                        break;
                    }
                }
                if (keyWindow) break;
            }
        }
        if (keyWindow && keyWindow.windowScene.statusBarManager) {
            statusBarHeight = keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;
        }
    }
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, statusBarHeight + 20);
}

- (BOOL)allowScreenEdgeInteractive {
    return YES;
}

- (BOOL)showDragIndicator {
    return NO;
}

// let the navigation stack top VC handle it.
- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIViewController *VC = self.topViewController;
    if ([VC conformsToProtocol:@protocol(TFYPanModalPresentable)]) {
        id<TFYPanModalPresentable> obj = VC;
        return [obj shouldRespondToPanModalGestureRecognizer:panGestureRecognizer];
    }
    return YES;
}


@end
