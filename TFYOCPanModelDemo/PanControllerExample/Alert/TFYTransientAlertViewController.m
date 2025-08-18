//
//  TFYTransientAlertViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYTransientAlertViewController.h"
#import "TFYAlertView.h"
#import <Masonry/View+MASAdditions.h>

@interface TFYTransientAlertViewController () <TFYPanModalPresentable>

@end

@implementation TFYTransientAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - TFYPanModalPresentable

- (BOOL)showDragIndicator {
    return NO;
}

- (BOOL)anchorModalToLongForm {
    return YES;
}

- (BOOL)isUserInteractionEnabled {
    return NO;
}

@end
