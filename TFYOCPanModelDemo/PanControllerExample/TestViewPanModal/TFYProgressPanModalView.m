//
//  TFYProgressPanModalView.m
//  TFYPanModalDemo
//
//  Created by admin on 2025/1/16.
//

#import "TFYProgressPanModalView.h"
#import <Masonry/Masonry.h>

@interface TFYProgressPanModalView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *statusIcon;
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, assign) float currentProgress;

@end

@implementation TFYProgressPanModalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self startProgressSimulation];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"正在处理...";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor darkTextColor];
    [self addSubview:self.titleLabel];
    
    // 状态图标
    self.statusIcon = [[UIImageView alloc] init];
    self.statusIcon.image = [UIImage systemImageNamed:@"arrow.clockwise"];
    self.statusIcon.tintColor = [UIColor systemBlueColor];
    self.statusIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.statusIcon];
    
    // 状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"准备中...";
    self.statusLabel.font = [UIFont systemFontOfSize:16];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.textColor = [UIColor systemGrayColor];
    [self addSubview:self.statusLabel];
    
    // 进度条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progressTintColor = [UIColor systemBlueColor];
    self.progressView.trackTintColor = [UIColor systemGray5Color];
    self.progressView.layer.cornerRadius = 2.0;
    self.progressView.clipsToBounds = YES;
    [self addSubview:self.progressView];
    
    // 进度标签
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.text = @"0%";
    self.progressLabel.font = [UIFont systemFontOfSize:14];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.textColor = [UIColor systemGrayColor];
    [self addSubview:self.progressLabel];
    
    // 取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancelButton setTitleColor:[UIColor systemRedColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.left.right.equalTo(self).inset(20);
        make.height.equalTo(@30);
    }];
    
    [self.statusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusIcon.mas_bottom).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.height.equalTo(@20);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).offset(30);
        make.left.right.equalTo(self).inset(40);
        make.height.equalTo(@4);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.height.equalTo(@20);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.height.equalTo(@44);
    }];
}

- (void)startProgressSimulation {
    self.currentProgress = 0.0;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)updateProgress {
    self.currentProgress += 0.01;
    
    if (self.currentProgress >= 1.0) {
        self.currentProgress = 1.0;
        [self.progressTimer invalidate];
        self.progressTimer = nil;
        [self progressCompleted];
    }
    
    [self.progressView setProgress:self.currentProgress animated:YES];
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", self.currentProgress * 100];
    
    // 更新状态
    if (self.currentProgress < 0.3) {
        self.statusLabel.text = @"准备中...";
        self.statusIcon.image = [UIImage systemImageNamed:@"arrow.clockwise"];
        self.statusIcon.tintColor = [UIColor systemBlueColor];
    } else if (self.currentProgress < 0.7) {
        self.statusLabel.text = @"处理中...";
        self.statusIcon.image = [UIImage systemImageNamed:@"gearshape"];
        self.statusIcon.tintColor = [UIColor systemOrangeColor];
    } else if (self.currentProgress < 1.0) {
        self.statusLabel.text = @"即将完成...";
        self.statusIcon.image = [UIImage systemImageNamed:@"checkmark.circle"];
        self.statusIcon.tintColor = [UIColor systemGreenColor];
    }
}

- (void)progressCompleted {
    self.statusLabel.text = @"处理完成！";
    self.statusIcon.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
    self.statusIcon.tintColor = [UIColor systemGreenColor];
    
    // 自动关闭
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissAnimated:YES completion:^{}];
    });
}

#pragma mark - Actions

- (void)cancelAction {
    if (self.progressTimer) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
    [self dismissAnimated:YES completion:^{}];
}

- (void)dealloc {
    if (self.progressTimer) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 350);
}

- (PanModalHeight)mediumFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 400);
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 450);
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
    return PresentationStateShort;
}

- (CGFloat)springDamping {
    return 0.9;
}

- (BOOL)allowsDragToDismiss {
    return NO; // 进度中不允许拖拽关闭
}

- (BOOL)allowsTapBackgroundToDismiss {
    return NO; // 进度中不允许点击背景关闭
}

- (TFYBackgroundConfig *)backgroundConfig {
    return [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorDefault];
}

@end
