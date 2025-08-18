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
#import "TFYCollectionPanModalView.h"
#import "TFYFormInputPanModalView.h"
#import "TFYImagePickerPanModalView.h"
#import "TFYSettingsPanModalView.h"
#import "TFYProgressPanModalView.h"
#import "TFYCardStylePanModalView.h"

@interface TFYTestViewPanModalController ()

@property (nonatomic, strong) UIButton *presentButton;
@property (nonatomic, strong) UIButton *collectionViewButton;
@property (nonatomic, strong) UIButton *formInputButton;
@property (nonatomic, strong) UIButton *imagePickerButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UIButton *progressButton;
@property (nonatomic, strong) UIButton *cardStyleButton;

@end

@implementation TFYTestViewPanModalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.presentButton];
    [self.view addSubview:self.collectionViewButton];
    [self.view addSubview:self.formInputButton];
    [self.view addSubview:self.imagePickerButton];
    [self.view addSubview:self.settingsButton];
    [self.view addSubview:self.progressButton];
    [self.view addSubview:self.cardStyleButton];

    // 第一行按钮
    [self.presentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.view).offset(88);
        make.size.mas_equalTo(CGSizeMake(120, 66));
    }];
    
    [self.collectionViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.presentButton);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.presentButton.mas_bottom).offset(20);
    }];
    
    // 第二行按钮
    [self.formInputButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.presentButton);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.collectionViewButton.mas_bottom).offset(20);
    }];
    
    [self.imagePickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.presentButton);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.formInputButton.mas_bottom).offset(20);
    }];
    
    // 第三行按钮
    [self.settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.presentButton);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.imagePickerButton.mas_bottom).offset(20);
    }];
    
    [self.progressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.presentButton);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.settingsButton.mas_bottom).offset(20);
    }];
    
    [self.cardStyleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.presentButton);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.progressButton.mas_bottom).offset(20);
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

- (void)didTapFormInputButton {
    TFYFormInputPanModalView *formInputPanModalView = [TFYFormInputPanModalView new];
    [formInputPanModalView presentInView:nil];
}

- (void)didTapImagePickerButton {
    TFYImagePickerPanModalView *imagePickerPanModalView = [TFYImagePickerPanModalView new];
    [imagePickerPanModalView presentInView:nil];
}

- (void)didTapSettingsButton {
    TFYSettingsPanModalView *settingsPanModalView = [TFYSettingsPanModalView new];
    [settingsPanModalView presentInView:nil];
}

- (void)didTapProgressButton {
    TFYProgressPanModalView *progressPanModalView = [TFYProgressPanModalView new];
    [progressPanModalView presentInView:nil];
}

- (void)didTapCardStyleButton {
    TFYCardStylePanModalView *cardStylePanModalView = [TFYCardStylePanModalView new];
    [cardStylePanModalView presentInView:nil];
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

- (UIButton *)formInputButton {
    if (!_formInputButton) {
        _formInputButton = [self buttonWithTitle:@"表单输入"];
        [_formInputButton addTarget:self action:@selector(didTapFormInputButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _formInputButton;
}

- (UIButton *)imagePickerButton {
    if (!_imagePickerButton) {
        _imagePickerButton = [self buttonWithTitle:@"图片选择"];
        [_imagePickerButton addTarget:self action:@selector(didTapImagePickerButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imagePickerButton;
}

- (UIButton *)settingsButton {
    if (!_settingsButton) {
        _settingsButton = [self buttonWithTitle:@"设置选项"];
        [_settingsButton addTarget:self action:@selector(didTapSettingsButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingsButton;
}

- (UIButton *)progressButton {
    if (!_progressButton) {
        _progressButton = [self buttonWithTitle:@"进度展示"];
        [_progressButton addTarget:self action:@selector(didTapProgressButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _progressButton;
}

- (UIButton *)cardStyleButton {
    if (!_cardStyleButton) {
        _cardStyleButton = [self buttonWithTitle:@"卡片样式"];
        [_cardStyleButton addTarget:self action:@selector(didTapCardStyleButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cardStyleButton;
}


@end
