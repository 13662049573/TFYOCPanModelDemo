//
//  TFYColorDetailViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYColorDetailViewController.h"
#import <Masonry/View+MASAdditions.h>

@interface TFYColorDetailViewController () <TFYPanModalPresentable>

@end

@implementation TFYColorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Detail";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [UIView new];
    view.backgroundColor = self.color;
	[self.view addSubview:view];
	[view mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(200, 200));
		make.top.equalTo(@88);
		make.centerX.equalTo(@0);
	}];
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 250);
}

- (BOOL)anchorModalToLongForm {
    return NO;
}

@end
