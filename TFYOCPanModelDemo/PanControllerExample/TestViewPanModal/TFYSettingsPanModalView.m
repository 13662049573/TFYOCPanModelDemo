//
//  TFYSettingsPanModalView.m
//  TFYPanModalDemo
//
//  Created by admin on 2025/1/16.
//

#import "TFYSettingsPanModalView.h"

@interface TFYSettingsPanModalView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// 设置项
@property (nonatomic, strong) UIView *notificationSettingView;
@property (nonatomic, strong) UIView *soundSettingView;
@property (nonatomic, strong) UIView *privacySettingView;
@property (nonatomic, strong) UIView *aboutSettingView;

@property (nonatomic, strong) UISwitch *notificationSwitch;
@property (nonatomic, strong) UISwitch *soundSwitch;
@property (nonatomic, strong) UISlider *brightnessSlider;
@property (nonatomic, strong) UILabel *brightnessLabel;

@end

@implementation TFYSettingsPanModalView

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
    self.titleLabel.text = @"设置";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor darkTextColor];
    [self addSubview:self.titleLabel];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 通知设置
    [self setupNotificationSetting];
    
    // 声音设置
    [self setupSoundSetting];
    
    // 隐私设置
    [self setupPrivacySetting];
    
    // 关于设置
    [self setupAboutSetting];
    
    [self setupConstraints];
}

- (void)setupNotificationSetting {
    self.notificationSettingView = [[UIView alloc] init];
    self.notificationSettingView.backgroundColor = [UIColor systemGray6Color];
    self.notificationSettingView.layer.cornerRadius = 12.0;
    [self.contentView addSubview:self.notificationSettingView];
    
    UILabel *notificationLabel = [[UILabel alloc] init];
    notificationLabel.text = @"推送通知";
    notificationLabel.font = [UIFont systemFontOfSize:16];
    notificationLabel.textColor = [UIColor darkTextColor];
    [self.notificationSettingView addSubview:notificationLabel];
    
    self.notificationSwitch = [[UISwitch alloc] init];
    self.notificationSwitch.on = YES;
    [self.notificationSwitch addTarget:self action:@selector(notificationSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.notificationSettingView addSubview:self.notificationSwitch];
    
    [notificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.notificationSettingView).offset(16);
        make.centerY.equalTo(self.notificationSettingView);
    }];
    
    [self.notificationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.notificationSettingView).offset(-16);
        make.centerY.equalTo(self.notificationSettingView);
    }];
}

- (void)setupSoundSetting {
    self.soundSettingView = [[UIView alloc] init];
    self.soundSettingView.backgroundColor = [UIColor systemGray6Color];
    self.soundSettingView.layer.cornerRadius = 12.0;
    [self.contentView addSubview:self.soundSettingView];
    
    UILabel *soundLabel = [[UILabel alloc] init];
    soundLabel.text = @"声音效果";
    soundLabel.font = [UIFont systemFontOfSize:16];
    soundLabel.textColor = [UIColor darkTextColor];
    [self.soundSettingView addSubview:soundLabel];
    
    self.soundSwitch = [[UISwitch alloc] init];
    self.soundSwitch.on = NO;
    [self.soundSwitch addTarget:self action:@selector(soundSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.soundSettingView addSubview:self.soundSwitch];
    
    [soundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.soundSettingView).offset(16);
        make.centerY.equalTo(self.soundSettingView);
    }];
    
    [self.soundSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.soundSettingView).offset(-16);
        make.centerY.equalTo(self.soundSettingView);
    }];
}

- (void)setupPrivacySetting {
    UIView *privacyContainer = [[UIView alloc] init];
    privacyContainer.backgroundColor = [UIColor systemGray6Color];
    privacyContainer.layer.cornerRadius = 12.0;
    [self.contentView addSubview:privacyContainer];
    
    UILabel *privacyLabel = [[UILabel alloc] init];
    privacyLabel.text = @"隐私设置";
    privacyLabel.font = [UIFont systemFontOfSize:16];
    privacyLabel.textColor = [UIColor darkTextColor];
    [privacyContainer addSubview:privacyLabel];
    
    self.brightnessLabel = [[UILabel alloc] init];
    self.brightnessLabel.text = @"亮度: 50%";
    self.brightnessLabel.font = [UIFont systemFontOfSize:14];
    self.brightnessLabel.textColor = [UIColor systemGrayColor];
    [privacyContainer addSubview:self.brightnessLabel];
    
    self.brightnessSlider = [[UISlider alloc] init];
    self.brightnessSlider.minimumValue = 0.0;
    self.brightnessSlider.maximumValue = 100.0;
    self.brightnessSlider.value = 50.0;
    [self.brightnessSlider addTarget:self action:@selector(brightnessSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [privacyContainer addSubview:self.brightnessSlider];
    
    [privacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(privacyContainer).offset(16);
        make.top.equalTo(privacyContainer).offset(16);
    }];
    
    [self.brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(privacyContainer).inset(16);
        make.top.equalTo(privacyLabel.mas_bottom).offset(12);
        make.height.equalTo(@30);
    }];
    
    [self.brightnessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(privacyContainer).offset(16);
        make.top.equalTo(self.brightnessSlider.mas_bottom).offset(8);
        make.bottom.equalTo(privacyContainer).offset(-16);
    }];
    
    self.privacySettingView = privacyContainer;
}

- (void)setupAboutSetting {
    self.aboutSettingView = [[UIView alloc] init];
    self.aboutSettingView.backgroundColor = [UIColor systemGray6Color];
    self.aboutSettingView.layer.cornerRadius = 12.0;
    [self.contentView addSubview:self.aboutSettingView];
    
    UILabel *aboutLabel = [[UILabel alloc] init];
    aboutLabel.text = @"关于应用";
    aboutLabel.font = [UIFont systemFontOfSize:16];
    aboutLabel.textColor = [UIColor darkTextColor];
    [self.aboutSettingView addSubview:aboutLabel];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = @"版本 1.0.0";
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.textColor = [UIColor systemGrayColor];
    [self.aboutSettingView addSubview:versionLabel];
    
    [aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aboutSettingView).offset(16);
        make.centerY.equalTo(self.aboutSettingView);
    }];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.aboutSettingView).offset(-16);
        make.centerY.equalTo(self.aboutSettingView);
    }];
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.height.equalTo(@30);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.notificationSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.equalTo(@60);
    }];
    
    [self.soundSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.notificationSettingView.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.equalTo(@60);
    }];
    
    [self.privacySettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.soundSettingView.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.equalTo(@100);
    }];
    
    [self.aboutSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.privacySettingView.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.equalTo(@60);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

#pragma mark - Actions

- (void)notificationSwitchChanged:(UISwitch *)sender {
    NSLog(@"推送通知: %@", sender.isOn ? @"开启" : @"关闭");
}

- (void)soundSwitchChanged:(UISwitch *)sender {
    NSLog(@"声音效果: %@", sender.isOn ? @"开启" : @"关闭");
}

- (void)brightnessSliderChanged:(UISlider *)sender {
    int value = (int)sender.value;
    self.brightnessLabel.text = [NSString stringWithFormat:@"亮度: %d%%", value];
    NSLog(@"亮度设置: %d%%", value);
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 400);
}

- (PanModalHeight)mediumFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 500);
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 600);
}

- (CGFloat)topOffset {
    return self.safeAreaInsets.top + 21;
}

- (BOOL)shouldRoundTopCorners {
    return YES;
}

- (CGFloat)cornerRadius {
    return 16.0;
}

- (PresentationState)originPresentationState {
    return PresentationStateMedium;
}

- (CGFloat)springDamping {
    return 0.8;
}

- (UIScrollView *)panScrollable {
    return self.scrollView;
}

- (TFYBackgroundConfig *)backgroundConfig {
    return [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorSystemVisualEffect];
}

@end
