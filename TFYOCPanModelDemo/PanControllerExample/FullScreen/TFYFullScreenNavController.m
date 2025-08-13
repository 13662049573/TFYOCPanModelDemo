//
//  TFYFullScreenNavController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/5/13.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYFullScreenNavController.h"
#import <Masonry/View+MASAdditions.h>

@interface TFYFullScreenViewController : UIViewController

@end

@interface TFYFullScreenNavController () <TFYPanModalPresentable>

@end

@implementation TFYFullScreenNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pushViewController:[TFYFullScreenViewController new] animated:NO];
}

#pragma mark - overridden to update panModal

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self pan_panModalSetNeedsLayoutUpdate];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *controller = [super popViewControllerAnimated:animated];
    [self pan_panModalSetNeedsLayoutUpdate];
    return controller;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *viewControllers = [super popToViewController:viewController animated:animated];
    [self pan_panModalSetNeedsLayoutUpdate];
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *viewControllers = [super popToRootViewControllerAnimated:animated];
    [self pan_panModalSetNeedsLayoutUpdate];
    return viewControllers;
}

#pragma mark - TFYPanModalPresentable

- (CGFloat)topOffset {
    return 0;
}

- (NSTimeInterval)transitionDuration {
    return 0.4;
}

- (CGFloat)springDamping {
    return 1;
}

- (BOOL)shouldRoundTopCorners {
    return NO;
}

- (BOOL)showDragIndicator {
    return NO;
}

- (BOOL)allowScreenEdgeInteractive {
    return YES;
}

- (CGFloat)maxAllowedDistanceToLeftScreenEdgeForPanInteraction {
    return 0;
}


@end


@implementation TFYFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"Full Screen";

    UILabel *label = [UILabel new];
    label.text = @"Drag to Dismiss!";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
    }];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"NEXT" style:UIBarButtonItemStylePlain target:self action:@selector(nextPage)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)nextPage {
	TFYFullScreenViewController *pageOneViewController = [TFYFullScreenViewController new];
	[self.navigationController pushViewController:pageOneViewController animated:YES];
}


@end
