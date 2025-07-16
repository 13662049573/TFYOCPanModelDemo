//
//  TFYTestViewPanModalController.m
//  TFYPanModalDemo
//
//  Created by heath wang on 2019/10/18.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

#import "TFYTestViewPanModalController.h"
#import <Masonry/Masonry.h>
#import "TFYSimplePanModalView.h"
#include "TFYCollectionPanModalView.h"

@interface TFYTestViewPanModalController ()

@property (nonatomic, strong) UIButton *presentButton;
@property (nonatomic, strong) UIButton *collectionViewButton;

@end

@implementation TFYTestViewPanModalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.presentButton];
    [self.view addSubview:self.collectionViewButton];

    [self.presentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(0, -40));
        make.size.mas_equalTo(CGSizeMake(120, 66));
    }];
    
    [self.collectionViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.presentButton);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.presentButton.mas_bottom).offset(0);
    }];
}

#pragma mark - touch action

- (void)didTapToPresent {
    TFYSimplePanModalView *simplePanModalView = [TFYSimplePanModalView new];
    [simplePanModalView presentInView:nil];
}

- (void)didTapToAutoSize {
    // TODO:
}

- (void)didTapCollectionViewButton {
    TFYCollectionPanModalView *collectionPanModalView = [TFYCollectionPanModalView new];
    [collectionPanModalView presentInView:nil];
}

#pragma mark - private method

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor colorWithRed:0.000 green:0.600 blue:0.800 alpha:1.00] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    return button;
}

#pragma mark - Getter

- (UIButton *)presentButton {
    if (!_presentButton) {
        _presentButton = [self buttonWithTitle:@"Present"];
        [_presentButton addTarget:self action:@selector(didTapToPresent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presentButton;
}

- (UIButton *)collectionViewButton {
    if (!_collectionViewButton) {
        _collectionViewButton = [self buttonWithTitle:@"CollectionView"];
        [_collectionViewButton addTarget:self action:@selector(didTapCollectionViewButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionViewButton;
}


@end
