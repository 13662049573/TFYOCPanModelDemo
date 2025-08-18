//
//  TFYAlertViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYAlertViewController.h"
#import "TFYAlertView.h"
#import "TFYOCPanlModel.h"
#import <Masonry/View+MASAdditions.h>

@interface TFYAlertViewController () <TFYPanModalPresentable>

@property (nonatomic, strong) TFYAlertView *alertView;

@end

@implementation TFYAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.top.equalTo(@0);
        make.height.mas_equalTo(kAlertHeight);
    }];
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, kAlertHeight);
}

- (PanModalHeight)longFormHeight {
    return [self shortFormHeight];
}

- (BOOL)shouldRoundTopCorners {
    return NO;
}

- (BOOL)showDragIndicator {
    return YES;
}

- (BOOL)anchorModalToLongForm {
    return NO;
}

- (BOOL)isUserInteractionEnabled {
    
    return YES;
}

#pragma mark - Getter

- (TFYAlertView *)alertView {
    if (!_alertView) {
        _alertView = [TFYAlertView new];
        _alertView.layer.cornerRadius = 8;
    }
    return _alertView;
}


@end
