//
//  TFYImagePickerPanModalView.m
//  TFYPanModalDemo
//
//  Created by admin on 2025/1/16.
//

#import "TFYImagePickerPanModalView.h"
#import <Masonry/Masonry.h>

@interface TFYImagePickerPanModalView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *cameraOptionView;
@property (nonatomic, strong) UIView *photoLibraryOptionView;
@property (nonatomic, strong) UIView *documentOptionView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *cameraIcon;
@property (nonatomic, strong) UIImageView *photoIcon;
@property (nonatomic, strong) UIImageView *documentIcon;

@end

@implementation TFYImagePickerPanModalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"选择图片来源";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor darkTextColor];
    [self addSubview:self.titleLabel];
    
    // 相机选项
    self.cameraOptionView = [[UIView alloc] init];
    self.cameraOptionView.backgroundColor = [UIColor systemBlueColor];
    self.cameraOptionView.layer.cornerRadius = 12.0;
    [self addSubview:self.cameraOptionView];
    
    self.cameraIcon = [[UIImageView alloc] init];
    self.cameraIcon.image = [UIImage systemImageNamed:@"camera.fill"];
    self.cameraIcon.tintColor = [UIColor whiteColor];
    self.cameraIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.cameraOptionView addSubview:self.cameraIcon];
    
    UILabel *cameraLabel = [[UILabel alloc] init];
    cameraLabel.text = @"相机";
    cameraLabel.font = [UIFont boldSystemFontOfSize:16];
    cameraLabel.textColor = [UIColor whiteColor];
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    [self.cameraOptionView addSubview:cameraLabel];
    
    UITapGestureRecognizer *cameraTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraAction)];
    [self.cameraOptionView addGestureRecognizer:cameraTap];
    
    // 相册选项
    self.photoLibraryOptionView = [[UIView alloc] init];
    self.photoLibraryOptionView.backgroundColor = [UIColor systemGreenColor];
    self.photoLibraryOptionView.layer.cornerRadius = 12.0;
    [self addSubview:self.photoLibraryOptionView];
    
    self.photoIcon = [[UIImageView alloc] init];
    self.photoIcon.image = [UIImage systemImageNamed:@"photo.on.rectangle"];
    self.photoIcon.tintColor = [UIColor whiteColor];
    self.photoIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.photoLibraryOptionView addSubview:self.photoIcon];
    
    UILabel *photoLabel = [[UILabel alloc] init];
    photoLabel.text = @"相册";
    photoLabel.font = [UIFont boldSystemFontOfSize:16];
    photoLabel.textColor = [UIColor whiteColor];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    [self.photoLibraryOptionView addSubview:photoLabel];
    
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoLibraryAction)];
    [self.photoLibraryOptionView addGestureRecognizer:photoTap];
    
    // 文档选项
    self.documentOptionView = [[UIView alloc] init];
    self.documentOptionView.backgroundColor = [UIColor systemOrangeColor];
    self.documentOptionView.layer.cornerRadius = 12.0;
    [self addSubview:self.documentOptionView];
    
    self.documentIcon = [[UIImageView alloc] init];
    self.documentIcon.image = [UIImage systemImageNamed:@"doc.text"];
    self.documentIcon.tintColor = [UIColor whiteColor];
    self.documentIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.documentOptionView addSubview:self.documentIcon];
    
    UILabel *documentLabel = [[UILabel alloc] init];
    documentLabel.text = @"文档";
    documentLabel.font = [UIFont boldSystemFontOfSize:16];
    documentLabel.textColor = [UIColor whiteColor];
    documentLabel.textAlignment = NSTextAlignmentCenter;
    [self.documentOptionView addSubview:documentLabel];
    
    UITapGestureRecognizer *documentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(documentAction)];
    [self.documentOptionView addGestureRecognizer:documentTap];
    
    // 取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.cancelButton setTitleColor:[UIColor systemGrayColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    [self setupConstraints];
    
    // 设置图标和标签的约束
    [self.cameraIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cameraOptionView);
        make.top.equalTo(self.cameraOptionView).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [cameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cameraOptionView);
        make.top.equalTo(self.cameraIcon.mas_bottom).offset(10);
        make.bottom.equalTo(self.cameraOptionView).offset(-20);
    }];
    
    [self.photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.photoLibraryOptionView);
        make.top.equalTo(self.photoLibraryOptionView).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.photoLibraryOptionView);
        make.top.equalTo(self.photoIcon.mas_bottom).offset(10);
        make.bottom.equalTo(self.photoLibraryOptionView).offset(-20);
    }];
    
    [self.documentIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.documentOptionView);
        make.top.equalTo(self.documentOptionView).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [documentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.documentOptionView);
        make.top.equalTo(self.documentIcon.mas_bottom).offset(10);
        make.bottom.equalTo(self.documentOptionView).offset(-20);
    }];
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.height.equalTo(@30);
    }];
    
    [self.cameraOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.equalTo(self).offset(20);
        make.width.equalTo(self).multipliedBy(0.25);
        make.height.equalTo(@120);
    }];
    
    [self.photoLibraryOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraOptionView);
        make.centerX.equalTo(self);
        make.width.height.equalTo(self.cameraOptionView);
    }];
    
    [self.documentOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraOptionView);
        make.right.equalTo(self).offset(-20);
        make.width.height.equalTo(self.cameraOptionView);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraOptionView.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.height.equalTo(@44);
    }];
}

#pragma mark - Actions

- (void)cameraAction {
    NSLog(@"选择相机");
    [self dismissAnimated:YES completion:^{}];
}

- (void)photoLibraryAction {
    NSLog(@"选择相册");
    [self dismissAnimated:YES completion:^{}];
}

- (void)documentAction {
    NSLog(@"选择文档");
    [self dismissAnimated:YES completion:^{}];
}

- (void)cancelAction {
    [self dismissAnimated:YES completion:^{}];
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 280);
}

- (PanModalHeight)mediumFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 350);
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 400);
}

- (CGFloat)topOffset {
    return self.safeAreaInsets.top + 21;
}

- (BOOL)shouldRoundTopCorners {
    return YES;
}

- (CGFloat)cornerRadius {
    return 20.0;
}

- (PresentationState)originPresentationState {
    return PresentationStateShort;
}

- (CGFloat)springDamping {
    return 0.9;
}

- (TFYBackgroundConfig *)backgroundConfig {
    return [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorSystemVisualEffect];
}

@end
