//
//  TFYSimpleFrequentTapPreventionViewController.m
//  TFYOCPanModelDemo
//
//  Created by admin on 2025/7/16.
//

#import "TFYSimpleFrequentTapPreventionViewController.h"

@interface TFYSimpleFrequentTapPreventionViewController () <TFYPanModalPresentable, TFYPanModalFrequentTapPreventionDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *statusCardView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *showModalButton;
@property (nonatomic, strong) UIView *infoCardView;
@property (nonatomic, strong) UILabel *infoTitleLabel;
@property (nonatomic, strong) UILabel *infoDescriptionLabel;
@property (nonatomic, strong) UIView *testCardView;
@property (nonatomic, strong) UIButton *autoTestButton;
@property (nonatomic, strong) UIButton *manualTriggerButton;
@property (nonatomic, strong) NSTimer *autoTestTimer;
@property (nonatomic, assign) NSInteger testClickCount;

@end

@implementation TFYSimpleFrequentTapPreventionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.title = @"简单防频繁点击演示";
    
    // 创建容器视图
    self.containerView = [[UIView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];
    
    [self setupTitleSection];
    [self setupInfoSection];
    [self setupStatusSection];
    [self setupDemoSection];
    [self setupTestSection];
    [self setupConstraints];
}

- (void)setupTitleSection {
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"简单防频繁点击演示";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    self.titleLabel.textColor = [UIColor labelColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.titleLabel];
    
    // 描述
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.text = @"这是一个简单的防频繁点击演示。快速点击下方按钮，观察防频繁点击功能的效果。";
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.font = [UIFont systemFontOfSize:16];
    self.descriptionLabel.textColor = [UIColor secondaryLabelColor];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.descriptionLabel];
}

- (void)setupInfoSection {
    // 信息卡片
    self.infoCardView = [[UIView alloc] init];
    self.infoCardView.backgroundColor = [UIColor systemBackgroundColor];
    self.infoCardView.layer.cornerRadius = 16;
    self.infoCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.infoCardView.layer.shadowOffset = CGSizeMake(0, 4);
    self.infoCardView.layer.shadowOpacity = 0.15;
    self.infoCardView.layer.shadowRadius = 8;
    self.infoCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.infoCardView];
    
    // 信息标题
    self.infoTitleLabel = [[UILabel alloc] init];
    self.infoTitleLabel.text = @"功能特点";
    self.infoTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.infoTitleLabel.textColor = [UIColor labelColor];
    self.infoTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.infoTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.infoCardView addSubview:self.infoTitleLabel];
    
    // 信息描述
    self.infoDescriptionLabel = [[UILabel alloc] init];
    self.infoDescriptionLabel.text = @"• 默认防频繁点击间隔：1.0秒\n• 自动显示提示信息\n• 实时状态反馈\n• 简单易用的演示界面";
    self.infoDescriptionLabel.numberOfLines = 0;
    self.infoDescriptionLabel.font = [UIFont systemFontOfSize:16];
    self.infoDescriptionLabel.textColor = [UIColor secondaryLabelColor];
    self.infoDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.infoDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.infoCardView addSubview:self.infoDescriptionLabel];
}

- (void)setupStatusSection {
    // 状态卡片
    self.statusCardView = [[UIView alloc] init];
    self.statusCardView.backgroundColor = [UIColor systemBackgroundColor];
    self.statusCardView.layer.cornerRadius = 16;
    self.statusCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.statusCardView.layer.shadowOffset = CGSizeMake(0, 4);
    self.statusCardView.layer.shadowOpacity = 0.15;
    self.statusCardView.layer.shadowRadius = 8;
    self.statusCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.statusCardView];
    
    // 状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"未触发防频繁点击";
    self.statusLabel.font = [UIFont boldSystemFontOfSize:18];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.backgroundColor = [UIColor systemGreenColor];
    self.statusLabel.layer.cornerRadius = 12;
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.statusCardView addSubview:self.statusLabel];
}

- (void)setupDemoSection {
    // 显示弹窗按钮
    self.showModalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showModalButton setTitle:@"显示弹窗（快速点击测试）" forState:UIControlStateNormal];
    self.showModalButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.showModalButton.backgroundColor = [UIColor systemBlueColor];
    [self.showModalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showModalButton.layer.cornerRadius = 16;
    self.showModalButton.layer.shadowColor = [UIColor systemBlueColor].CGColor;
    self.showModalButton.layer.shadowOffset = CGSizeMake(0, 6);
    self.showModalButton.layer.shadowOpacity = 0.4;
    self.showModalButton.layer.shadowRadius = 12;
    [self.showModalButton addTarget:self action:@selector(showModalButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.showModalButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.showModalButton];
}

- (void)setupTestSection {
    // 测试卡片
    self.testCardView = [[UIView alloc] init];
    self.testCardView.backgroundColor = [UIColor systemBackgroundColor];
    self.testCardView.layer.cornerRadius = 16;
    self.testCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.testCardView.layer.shadowOffset = CGSizeMake(0, 4);
    self.testCardView.layer.shadowOpacity = 0.15;
    self.testCardView.layer.shadowRadius = 8;
    self.testCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.testCardView];
    
    // 自动测试按钮
    self.autoTestButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.autoTestButton setTitle:@"开始自动测试" forState:UIControlStateNormal];
    self.autoTestButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.autoTestButton.backgroundColor = [UIColor systemOrangeColor];
    [self.autoTestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.autoTestButton.layer.cornerRadius = 12;
    [self.autoTestButton addTarget:self action:@selector(autoTestButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.autoTestButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.testCardView addSubview:self.autoTestButton];
    
    // 手动触发按钮
    self.manualTriggerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.manualTriggerButton setTitle:@"手动触发防频繁点击" forState:UIControlStateNormal];
    self.manualTriggerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.manualTriggerButton.backgroundColor = [UIColor systemPurpleColor];
    [self.manualTriggerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.manualTriggerButton.layer.cornerRadius = 12;
    [self.manualTriggerButton addTarget:self action:@selector(manualTriggerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.manualTriggerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.testCardView addSubview:self.manualTriggerButton];
}

- (void)setupConstraints {
    // 容器视图约束
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
    ]];
    
    // 标题部分约束
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        
        [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:16],
        [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.descriptionLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
    ]];
    
    // 信息卡片约束
    [NSLayoutConstraint activateConstraints:@[
        [self.infoCardView.topAnchor constraintEqualToAnchor:self.descriptionLabel.bottomAnchor constant:32],
        [self.infoCardView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.infoCardView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        
        [self.infoTitleLabel.topAnchor constraintEqualToAnchor:self.infoCardView.topAnchor constant:20],
        [self.infoTitleLabel.leadingAnchor constraintEqualToAnchor:self.infoCardView.leadingAnchor constant:20],
        [self.infoTitleLabel.trailingAnchor constraintEqualToAnchor:self.infoCardView.trailingAnchor constant:-20],
        
        [self.infoDescriptionLabel.topAnchor constraintEqualToAnchor:self.infoTitleLabel.bottomAnchor constant:16],
        [self.infoDescriptionLabel.leadingAnchor constraintEqualToAnchor:self.infoCardView.leadingAnchor constant:20],
        [self.infoDescriptionLabel.trailingAnchor constraintEqualToAnchor:self.infoCardView.trailingAnchor constant:-20],
        [self.infoDescriptionLabel.bottomAnchor constraintEqualToAnchor:self.infoCardView.bottomAnchor constant:-20],
    ]];
    
    // 状态卡片约束
    [NSLayoutConstraint activateConstraints:@[
        [self.statusCardView.topAnchor constraintEqualToAnchor:self.infoCardView.bottomAnchor constant:24],
        [self.statusCardView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.statusCardView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.statusCardView.topAnchor constant:16],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.statusCardView.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.statusCardView.trailingAnchor constant:-20],
        [self.statusLabel.heightAnchor constraintEqualToConstant:50],
        [self.statusLabel.bottomAnchor constraintEqualToAnchor:self.statusCardView.bottomAnchor constant:-16],
    ]];
    
         // 测试卡片约束
     [NSLayoutConstraint activateConstraints:@[
         [self.testCardView.topAnchor constraintEqualToAnchor:self.statusCardView.bottomAnchor constant:24],
         [self.testCardView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
         [self.testCardView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
         
         [self.autoTestButton.topAnchor constraintEqualToAnchor:self.testCardView.topAnchor constant:16],
         [self.autoTestButton.leadingAnchor constraintEqualToAnchor:self.testCardView.leadingAnchor constant:16],
         [self.autoTestButton.trailingAnchor constraintEqualToAnchor:self.testCardView.trailingAnchor constant:-16],
         [self.autoTestButton.heightAnchor constraintEqualToConstant:50],
         
         [self.manualTriggerButton.topAnchor constraintEqualToAnchor:self.autoTestButton.bottomAnchor constant:12],
         [self.manualTriggerButton.leadingAnchor constraintEqualToAnchor:self.testCardView.leadingAnchor constant:16],
         [self.manualTriggerButton.trailingAnchor constraintEqualToAnchor:self.testCardView.trailingAnchor constant:-16],
         [self.manualTriggerButton.heightAnchor constraintEqualToConstant:50],
         [self.manualTriggerButton.bottomAnchor constraintEqualToAnchor:self.testCardView.bottomAnchor constant:-16],
     ]];
     
     // 按钮约束
     [NSLayoutConstraint activateConstraints:@[
         [self.showModalButton.topAnchor constraintEqualToAnchor:self.testCardView.bottomAnchor constant:24],
         [self.showModalButton.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
         [self.showModalButton.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
         [self.showModalButton.heightAnchor constraintEqualToConstant:60],
         [self.showModalButton.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor],
     ]];
}

#pragma mark - Actions

- (void)showModalButtonTapped:(UIButton *)sender {
    // 创建弹窗控制器
    UIViewController *modalVC = [[UIViewController alloc] init];
    modalVC.view.backgroundColor = [UIColor systemGreenColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"防频繁点击演示";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [modalVC.view addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"这是一个防频繁点击演示弹窗\n\n快速点击按钮测试防频繁点击功能\n\n点击背景或拖拽可关闭";
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 0;
    [modalVC.view addSubview:contentLabel];
    
    // 设置约束
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:modalVC.view.safeAreaLayoutGuide.topAnchor constant:40],
        [titleLabel.leadingAnchor constraintEqualToAnchor:modalVC.view.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:modalVC.view.trailingAnchor constant:-20],
        
        [contentLabel.centerYAnchor constraintEqualToAnchor:modalVC.view.centerYAnchor],
        [contentLabel.leadingAnchor constraintEqualToAnchor:modalVC.view.leadingAnchor constant:20],
        [contentLabel.trailingAnchor constraintEqualToAnchor:modalVC.view.trailingAnchor constant:-20],
    ]];
    
    // 使用PanModal展示
    [self presentPanModal:modalVC];
}

#pragma mark - TFYPanModalPresentable

- (BOOL)shouldPreventFrequentTapping {
    return YES; // 启用防频繁点击
}

- (NSTimeInterval)frequentTapPreventionInterval {
    return 1.0; // 1秒间隔
}

- (BOOL)shouldShowFrequentTapPreventionHint {
    return YES; // 显示提示
}

- (nullable NSString *)frequentTapPreventionHintText {
    return @"请等待1秒后再试"; // 提示文本
}

- (void)panModalFrequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isPrevented) {
            self.statusLabel.text = [NSString stringWithFormat:@"防频繁点击中，剩余 %.1f 秒", remainingTime];
            self.statusLabel.backgroundColor = [UIColor systemRedColor];
        } else {
            self.statusLabel.text = @"未触发防频繁点击";
            self.statusLabel.backgroundColor = [UIColor systemGreenColor];
        }
    });
}

#pragma mark - 测试方法

- (void)autoTestButtonTapped:(UIButton *)sender {
    if (self.autoTestTimer) {
        // 停止自动测试
        [self.autoTestTimer invalidate];
        self.autoTestTimer = nil;
        [self.autoTestButton setTitle:@"开始自动测试" forState:UIControlStateNormal];
        self.autoTestButton.backgroundColor = [UIColor systemOrangeColor];
        self.testClickCount = 0;
    } else {
        // 开始自动测试
        [self.autoTestButton setTitle:@"停止自动测试" forState:UIControlStateNormal];
        self.autoTestButton.backgroundColor = [UIColor systemRedColor];
        self.testClickCount = 0;
        
        // 创建定时器，每0.2秒点击一次（更快的频率）
        self.autoTestTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                             target:self
                                                           selector:@selector(autoTestClick)
                                                           userInfo:nil
                                                            repeats:YES];
    }
}

- (void)autoTestClick {
    self.testClickCount++;
    NSLog(@"简单版本自动测试点击 #%ld", (long)self.testClickCount);
    
    // 模拟点击显示弹窗按钮
    [self showModalButtonTapped:nil];
    
    // 15次点击后自动停止
    if (self.testClickCount >= 15) {
        [self.autoTestTimer invalidate];
        self.autoTestTimer = nil;
        [self.autoTestButton setTitle:@"开始自动测试" forState:UIControlStateNormal];
        self.autoTestButton.backgroundColor = [UIColor systemOrangeColor];
        self.testClickCount = 0;
    }
}

- (void)manualTriggerButtonTapped:(UIButton *)sender {
    // 手动触发防频繁点击
    NSLog(@"简单版本手动触发防频繁点击");
    
    // 创建临时的防频繁点击管理器
    TFYPanModalFrequentTapPrevention *prevention = [TFYPanModalFrequentTapPrevention preventionWithInterval:1.0];
    prevention.delegate = self;
    prevention.enabled = YES;
    prevention.shouldShowHint = YES;
    prevention.hintText = @"手动触发：请等待1秒";
    
    // 触发防频繁点击
    [prevention triggerPrevention];
    
    // 显示提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手动触发"
                                                                 message:@"已手动触发防频繁点击，间隔：1.0秒"
                                                          preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TFYPanModalFrequentTapPreventionDelegate

- (void)frequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isPrevented) {
            self.statusLabel.text = [NSString stringWithFormat:@"手动触发防频繁点击中，剩余 %.1f 秒", remainingTime];
            self.statusLabel.backgroundColor = [UIColor systemRedColor];
        } else {
            self.statusLabel.text = @"手动触发防频繁点击已结束";
            self.statusLabel.backgroundColor = [UIColor systemGreenColor];
        }
    });
}

- (void)showFrequentTapPreventionHint:(NSString *)hintText {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"防频繁点击提示"
                                                                     message:hintText
                                                              preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
