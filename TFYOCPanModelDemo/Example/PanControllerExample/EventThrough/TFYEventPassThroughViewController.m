//
//  TFYEventPassThroughViewController.m
//  TFYPanModalDemo
//
//  Created by heath wang on 2019/9/27.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYEventPassThroughViewController.h"

@interface TFYEventPassThroughViewController () <TFYPanModalPresentable>


@end

@implementation TFYEventPassThroughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.200 green:0.000 blue:0.800 alpha:1.00];
    
    
    UILabel *label = [UILabel new];
    label.text = @"You can try to tap/pan/rotate/pin the view that beyond the blue view.\n As you see, the event can pass through.";
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.centerY.equalTo(@0);
    }];
}

#pragma mark - TFYMapViewControllerDelegate

- (void)userMoveMapView:(TFYMapViewController *)mapViewController {
    [self pan_panModalTransitionTo:PresentationStateShort];
}

- (void)didRelease:(TFYMapViewController *)mapController {
    [self pan_dismissAnimated:YES completion:NULL];
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 220);
}

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 49);
}

- (PresentationState)originPresentationState {
    return PresentationStateLong;
}

- (BOOL)allowsTouchEventsPassingThroughTransitionView {
    return YES;
}

- (void)willTransitionToState:(PresentationState)state {
    switch (state) {
        case PresentationStateLong:
            self.view.backgroundColor = [UIColor colorWithRed:0.200 green:0.000 blue:0.800 alpha:1.00];
            break;
            
        default:
            self.view.backgroundColor = [UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1.00];
            break;
    }
}

@end
