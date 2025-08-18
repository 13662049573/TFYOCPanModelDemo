//
//  TFYFrequentTapPreventionExampleViewController.m
//  TFYOCPanModelDemo
//
//  Created by admin on 2025/7/16.
//

#import "TFYFrequentTapPreventionExampleViewController.h"
#import "TFYPanModalFrequentTapPrevention.h"

@interface TFYFrequentTapPreventionExampleViewController () <TFYPanModalPresentable, TFYPanModalFrequentTapPreventionDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *configCardView;
@property (nonatomic, strong) UILabel *configTitleLabel;
@property (nonatomic, strong) UIView *switchContainerView;
@property (nonatomic, strong) UILabel *switchLabel;
@property (nonatomic, strong) UISwitch *preventionSwitch;
@property (nonatomic, strong) UIView *sliderContainerView;
@property (nonatomic, strong) UILabel *sliderLabel;
@property (nonatomic, strong) UISlider *intervalSlider;
@property (nonatomic, strong) UILabel *intervalValueLabel;
@property (nonatomic, strong) UIView *statusCardView;
@property (nonatomic, strong) UILabel *statusTitleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *showModalButton;
@property (nonatomic, strong) UIView *demoCardView;
@property (nonatomic, strong) UILabel *demoTitleLabel;
@property (nonatomic, strong) UILabel *demoDescriptionLabel;
@property (nonatomic, strong) UIView *testCardView;
@property (nonatomic, strong) UILabel *testTitleLabel;
@property (nonatomic, strong) UIButton *autoTestButton;
@property (nonatomic, strong) UIButton *manualTriggerButton;
@property (nonatomic, strong) NSTimer *autoTestTimer;
@property (nonatomic, assign) NSInteger testClickCount;

@end

@implementation TFYFrequentTapPreventionExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.title = @"防频繁点击演示";
    
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    // 创建内容视图
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];
    
    [self setupTitleSection];
    [self setupConfigSection];
    [self setupStatusSection];
    [self setupDemoSection];
    [self setupTestSection];
    [self setupConstraints];
}

- (void)setupTitleSection {
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"防频繁点击功能演示";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    self.titleLabel.textColor = [UIColor labelColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    
    // 描述
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.text = @"本示例演示防频繁点击功能，防止用户频繁点击触发多次弹窗，提升用户体验和应用稳定性。";
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.font = [UIFont systemFontOfSize:16];
    self.descriptionLabel.textColor = [UIColor secondaryLabelColor];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.descriptionLabel];
}

- (void)setupConfigSection {
    // 配置卡片
    self.configCardView = [[UIView alloc] init];
    self.configCardView.backgroundColor = [UIColor systemBackgroundColor];
    self.configCardView.layer.cornerRadius = 12;
    self.configCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.configCardView.layer.shadowOffset = CGSizeMake(0, 2);
    self.configCardView.layer.shadowOpacity = 0.1;
    self.configCardView.layer.shadowRadius = 4;
    self.configCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.configCardView];
    
    // 配置标题
    self.configTitleLabel = [[UILabel alloc] init];
    self.configTitleLabel.text = @"功能配置";
    self.configTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.configTitleLabel.textColor = [UIColor labelColor];
    self.configTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.configCardView addSubview:self.configTitleLabel];
    
    // 开关容器
    self.switchContainerView = [[UIView alloc] init];
    self.switchContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.configCardView addSubview:self.switchContainerView];
    
    self.switchLabel = [[UILabel alloc] init];
    self.switchLabel.text = @"启用防频繁点击";
    self.switchLabel.font = [UIFont systemFontOfSize:16];
    self.switchLabel.textColor = [UIColor labelColor];
    self.switchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.switchContainerView addSubview:self.switchLabel];
    
    self.preventionSwitch = [[UISwitch alloc] init];
    self.preventionSwitch.on = YES;
    [self.preventionSwitch addTarget:self action:@selector(preventionSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    self.preventionSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.switchContainerView addSubview:self.preventionSwitch];
    
    // 滑块容器
    self.sliderContainerView = [[UIView alloc] init];
    self.sliderContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.configCardView addSubview:self.sliderContainerView];
    
    self.sliderLabel = [[UILabel alloc] init];
    self.sliderLabel.text = @"防频繁点击时间间隔";
    self.sliderLabel.font = [UIFont systemFontOfSize:16];
    self.sliderLabel.textColor = [UIColor labelColor];
    self.sliderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sliderContainerView addSubview:self.sliderLabel];
    
    self.intervalSlider = [[UISlider alloc] init];
    self.intervalSlider.minimumValue = 0.5;
    self.intervalSlider.maximumValue = 5.0;
    self.intervalSlider.value = 1.0;
    [self.intervalSlider addTarget:self action:@selector(intervalSliderChanged:) forControlEvents:UIControlEventValueChanged];
    self.intervalSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sliderContainerView addSubview:self.intervalSlider];
    
    self.intervalValueLabel = [[UILabel alloc] init];
    self.intervalValueLabel.text = @"1.0秒";
    self.intervalValueLabel.font = [UIFont systemFontOfSize:14];
    self.intervalValueLabel.textColor = [UIColor systemBlueColor];
    self.intervalValueLabel.textAlignment = NSTextAlignmentCenter;
    self.intervalValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sliderContainerView addSubview:self.intervalValueLabel];
}

- (void)setupStatusSection {
    // 状态卡片
    self.statusCardView = [[UIView alloc] init];
    self.statusCardView.backgroundColor = [UIColor systemBackgroundColor];
    self.statusCardView.layer.cornerRadius = 12;
    self.statusCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.statusCardView.layer.shadowOffset = CGSizeMake(0, 2);
    self.statusCardView.layer.shadowOpacity = 0.1;
    self.statusCardView.layer.shadowRadius = 4;
    self.statusCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.statusCardView];
    
    // 状态标题
    self.statusTitleLabel = [[UILabel alloc] init];
    self.statusTitleLabel.text = @"当前状态";
    self.statusTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.statusTitleLabel.textColor = [UIColor labelColor];
    self.statusTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.statusCardView addSubview:self.statusTitleLabel];
    
    // 状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"未触发防频繁点击";
    self.statusLabel.font = [UIFont systemFontOfSize:16];
    self.statusLabel.textColor = [UIColor systemGreenColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.backgroundColor = [UIColor systemGreenColor];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.layer.cornerRadius = 8;
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.statusCardView addSubview:self.statusLabel];
}

- (void)setupDemoSection {
    // 演示卡片
    self.demoCardView = [[UIView alloc] init];
    self.demoCardView.backgroundColor = [UIColor systemBackgroundColor];
    self.demoCardView.layer.cornerRadius = 12;
    self.demoCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.demoCardView.layer.shadowOffset = CGSizeMake(0, 2);
    self.demoCardView.layer.shadowOpacity = 0.1;
    self.demoCardView.layer.shadowRadius = 4;
    self.demoCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.demoCardView];
    
    // 演示标题
    self.demoTitleLabel = [[UILabel alloc] init];
    self.demoTitleLabel.text = @"功能演示";
    self.demoTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.demoTitleLabel.textColor = [UIColor labelColor];
    self.demoTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.demoCardView addSubview:self.demoTitleLabel];
    
    // 演示描述
    self.demoDescriptionLabel = [[UILabel alloc] init];
    self.demoDescriptionLabel.text = @"点击下方按钮测试防频繁点击功能。快速连续点击按钮，观察防频繁点击的效果。";
    self.demoDescriptionLabel.numberOfLines = 0;
    self.demoDescriptionLabel.font = [UIFont systemFontOfSize:14];
    self.demoDescriptionLabel.textColor = [UIColor secondaryLabelColor];
    self.demoDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.demoCardView addSubview:self.demoDescriptionLabel];
    
    // 显示弹窗按钮
    self.showModalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showModalButton setTitle:@"显示弹窗（快速点击测试）" forState:UIControlStateNormal];
    self.showModalButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.showModalButton.backgroundColor = [UIColor systemBlueColor];
    [self.showModalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showModalButton.layer.cornerRadius = 12;
    self.showModalButton.layer.shadowColor = [UIColor systemBlueColor].CGColor;
    self.showModalButton.layer.shadowOffset = CGSizeMake(0, 4);
    self.showModalButton.layer.shadowOpacity = 0.3;
    self.showModalButton.layer.shadowRadius = 8;
    [self.showModalButton addTarget:self action:@selector(showModalButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.showModalButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.demoCardView addSubview:self.showModalButton];
}

- (void)setupTestSection {
    // 测试卡片
    self.testCardView = [[UIView alloc] init];
    self.testCardView.backgroundColor = [UIColor systemBackgroundColor];
    self.testCardView.layer.cornerRadius = 12;
    self.testCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.testCardView.layer.shadowOffset = CGSizeMake(0, 2);
    self.testCardView.layer.shadowOpacity = 0.1;
    self.testCardView.layer.shadowRadius = 4;
    self.testCardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.testCardView];
    
    // 测试标题
    self.testTitleLabel = [[UILabel alloc] init];
    self.testTitleLabel.text = @"模拟测试";
    self.testTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.testTitleLabel.textColor = [UIColor labelColor];
    self.testTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.testCardView addSubview:self.testTitleLabel];
    
    // 自动测试按钮
    self.autoTestButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.autoTestButton setTitle:@"开始自动测试" forState:UIControlStateNormal];
    self.autoTestButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.autoTestButton.backgroundColor = [UIColor systemOrangeColor];
    [self.autoTestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.autoTestButton.layer.cornerRadius = 8;
    [self.autoTestButton addTarget:self action:@selector(autoTestButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.autoTestButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.testCardView addSubview:self.autoTestButton];
    
    // 手动触发按钮
    self.manualTriggerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.manualTriggerButton setTitle:@"手动触发防频繁点击" forState:UIControlStateNormal];
    self.manualTriggerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.manualTriggerButton.backgroundColor = [UIColor systemPurpleColor];
    [self.manualTriggerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.manualTriggerButton.layer.cornerRadius = 8;
    [self.manualTriggerButton addTarget:self action:@selector(manualTriggerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.manualTriggerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.testCardView addSubview:self.manualTriggerButton];
}

- (void)setupConstraints {
    // 滚动视图约束
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor],
    ]];
    
    // 标题部分约束
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        
        [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:16],
        [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.descriptionLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
    ]];
    
    // 配置卡片约束
    [NSLayoutConstraint activateConstraints:@[
        [self.configCardView.topAnchor constraintEqualToAnchor:self.descriptionLabel.bottomAnchor constant:24],
        [self.configCardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.configCardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        
        [self.configTitleLabel.topAnchor constraintEqualToAnchor:self.configCardView.topAnchor constant:16],
        [self.configTitleLabel.leadingAnchor constraintEqualToAnchor:self.configCardView.leadingAnchor constant:16],
        [self.configTitleLabel.trailingAnchor constraintEqualToAnchor:self.configCardView.trailingAnchor constant:-16],
        
        [self.switchContainerView.topAnchor constraintEqualToAnchor:self.configTitleLabel.bottomAnchor constant:16],
        [self.switchContainerView.leadingAnchor constraintEqualToAnchor:self.configCardView.leadingAnchor constant:16],
        [self.switchContainerView.trailingAnchor constraintEqualToAnchor:self.configCardView.trailingAnchor constant:-16],
        [self.switchContainerView.heightAnchor constraintEqualToConstant:44],
        
        [self.switchLabel.leadingAnchor constraintEqualToAnchor:self.switchContainerView.leadingAnchor],
        [self.switchLabel.centerYAnchor constraintEqualToAnchor:self.switchContainerView.centerYAnchor],
        
        [self.preventionSwitch.trailingAnchor constraintEqualToAnchor:self.switchContainerView.trailingAnchor],
        [self.preventionSwitch.centerYAnchor constraintEqualToAnchor:self.switchContainerView.centerYAnchor],
        
        [self.sliderContainerView.topAnchor constraintEqualToAnchor:self.switchContainerView.bottomAnchor constant:16],
        [self.sliderContainerView.leadingAnchor constraintEqualToAnchor:self.configCardView.leadingAnchor constant:16],
        [self.sliderContainerView.trailingAnchor constraintEqualToAnchor:self.configCardView.trailingAnchor constant:-16],
        [self.sliderContainerView.heightAnchor constraintEqualToConstant:60],
        [self.sliderContainerView.bottomAnchor constraintEqualToAnchor:self.configCardView.bottomAnchor constant:-16],
        
        [self.sliderLabel.topAnchor constraintEqualToAnchor:self.sliderContainerView.topAnchor],
        [self.sliderLabel.leadingAnchor constraintEqualToAnchor:self.sliderContainerView.leadingAnchor],
        
        [self.intervalSlider.topAnchor constraintEqualToAnchor:self.sliderLabel.bottomAnchor constant:8],
        [self.intervalSlider.leadingAnchor constraintEqualToAnchor:self.sliderContainerView.leadingAnchor],
        [self.intervalSlider.trailingAnchor constraintEqualToAnchor:self.intervalValueLabel.leadingAnchor constant:-16],
        
        [self.intervalValueLabel.topAnchor constraintEqualToAnchor:self.sliderLabel.bottomAnchor constant:8],
        [self.intervalValueLabel.trailingAnchor constraintEqualToAnchor:self.sliderContainerView.trailingAnchor],
        [self.intervalValueLabel.widthAnchor constraintEqualToConstant:60],
    ]];
    
    // 状态卡片约束
    [NSLayoutConstraint activateConstraints:@[
        [self.statusCardView.topAnchor constraintEqualToAnchor:self.configCardView.bottomAnchor constant:16],
        [self.statusCardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.statusCardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        
        [self.statusTitleLabel.topAnchor constraintEqualToAnchor:self.statusCardView.topAnchor constant:16],
        [self.statusTitleLabel.leadingAnchor constraintEqualToAnchor:self.statusCardView.leadingAnchor constant:16],
        [self.statusTitleLabel.trailingAnchor constraintEqualToAnchor:self.statusCardView.trailingAnchor constant:-16],
        
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.statusTitleLabel.bottomAnchor constant:16],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.statusCardView.leadingAnchor constant:16],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.statusCardView.trailingAnchor constant:-16],
        [self.statusLabel.heightAnchor constraintEqualToConstant:40],
        [self.statusLabel.bottomAnchor constraintEqualToAnchor:self.statusCardView.bottomAnchor constant:-16],
    ]];
    
    // 演示卡片约束
    [NSLayoutConstraint activateConstraints:@[
        [self.demoCardView.topAnchor constraintEqualToAnchor:self.statusCardView.bottomAnchor constant:16],
        [self.demoCardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.demoCardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        
        [self.demoTitleLabel.topAnchor constraintEqualToAnchor:self.demoCardView.topAnchor constant:16],
        [self.demoTitleLabel.leadingAnchor constraintEqualToAnchor:self.demoCardView.leadingAnchor constant:16],
        [self.demoTitleLabel.trailingAnchor constraintEqualToAnchor:self.demoCardView.trailingAnchor constant:-16],
        
        [self.demoDescriptionLabel.topAnchor constraintEqualToAnchor:self.demoTitleLabel.bottomAnchor constant:12],
        [self.demoDescriptionLabel.leadingAnchor constraintEqualToAnchor:self.demoCardView.leadingAnchor constant:16],
        [self.demoDescriptionLabel.trailingAnchor constraintEqualToAnchor:self.demoCardView.trailingAnchor constant:-16],
        
        [self.showModalButton.topAnchor constraintEqualToAnchor:self.demoDescriptionLabel.bottomAnchor constant:20],
        [self.showModalButton.leadingAnchor constraintEqualToAnchor:self.demoCardView.leadingAnchor constant:16],
        [self.showModalButton.trailingAnchor constraintEqualToAnchor:self.demoCardView.trailingAnchor constant:-16],
                 [self.showModalButton.heightAnchor constraintEqualToConstant:50],
         [self.showModalButton.bottomAnchor constraintEqualToAnchor:self.demoCardView.bottomAnchor constant:-16],
     ]];
     
     // 测试卡片约束
     [NSLayoutConstraint activateConstraints:@[
         [self.testCardView.topAnchor constraintEqualToAnchor:self.demoCardView.bottomAnchor constant:16],
         [self.testCardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
         [self.testCardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
         
         [self.testTitleLabel.topAnchor constraintEqualToAnchor:self.testCardView.topAnchor constant:16],
         [self.testTitleLabel.leadingAnchor constraintEqualToAnchor:self.testCardView.leadingAnchor constant:16],
         [self.testTitleLabel.trailingAnchor constraintEqualToAnchor:self.testCardView.trailingAnchor constant:-16],
         
         [self.autoTestButton.topAnchor constraintEqualToAnchor:self.testTitleLabel.bottomAnchor constant:16],
         [self.autoTestButton.leadingAnchor constraintEqualToAnchor:self.testCardView.leadingAnchor constant:16],
         [self.autoTestButton.trailingAnchor constraintEqualToAnchor:self.testCardView.trailingAnchor constant:-16],
         [self.autoTestButton.heightAnchor constraintEqualToConstant:44],
         
         [self.manualTriggerButton.topAnchor constraintEqualToAnchor:self.autoTestButton.bottomAnchor constant:12],
         [self.manualTriggerButton.leadingAnchor constraintEqualToAnchor:self.testCardView.leadingAnchor constant:16],
         [self.manualTriggerButton.trailingAnchor constraintEqualToAnchor:self.testCardView.trailingAnchor constant:-16],
         [self.manualTriggerButton.heightAnchor constraintEqualToConstant:44],
         [self.manualTriggerButton.bottomAnchor constraintEqualToAnchor:self.testCardView.bottomAnchor constant:-16],
     ]];
     
     // 内容视图底部约束
     [NSLayoutConstraint activateConstraints:@[
         [self.contentView.bottomAnchor constraintEqualToAnchor:self.testCardView.bottomAnchor constant:20],
     ]];
}

#pragma mark - Actions

- (void)preventionSwitchChanged:(UISwitch *)sender {
    // 开关状态改变时的处理
    if (sender.isOn) {
        self.statusLabel.text = @"防频繁点击已启用";
        self.statusLabel.backgroundColor = [UIColor systemGreenColor];
    } else {
        self.statusLabel.text = @"防频繁点击已禁用";
        self.statusLabel.backgroundColor = [UIColor systemGrayColor];
    }
}

- (void)intervalSliderChanged:(UISlider *)sender {
    self.intervalValueLabel.text = [NSString stringWithFormat:@"%.1f秒", sender.value];
}

- (void)showModalButtonTapped:(UIButton *)sender {
    // 创建弹窗控制器
    UIViewController *modalVC = [[UIViewController alloc] init];
    modalVC.view.backgroundColor = [UIColor systemBlueColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"防频繁点击演示弹窗";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
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
        [titleLabel.topAnchor constraintEqualToAnchor:modalVC.view.safeAreaLayoutGuide.topAnchor constant:30],
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
    return self.preventionSwitch.isOn;
}

- (NSTimeInterval)frequentTapPreventionInterval {
    return self.intervalSlider.value;
}

- (BOOL)shouldShowFrequentTapPreventionHint {
    return YES;
}

- (nullable NSString *)frequentTapPreventionHintText {
    return [NSString stringWithFormat:@"请等待 %.1f 秒后再试", self.intervalSlider.value];
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
        
        // 创建定时器，每0.3秒点击一次
        self.autoTestTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                             target:self
                                                           selector:@selector(autoTestClick)
                                                           userInfo:nil
                                                            repeats:YES];
    }
}

- (void)autoTestClick {
    self.testClickCount++;
    NSLog(@"自动测试点击 #%ld", (long)self.testClickCount);
    
    // 模拟点击显示弹窗按钮
    [self showModalButtonTapped:nil];
    
    // 10次点击后自动停止
    if (self.testClickCount >= 10) {
        [self.autoTestTimer invalidate];
        self.autoTestTimer = nil;
        [self.autoTestButton setTitle:@"开始自动测试" forState:UIControlStateNormal];
        self.autoTestButton.backgroundColor = [UIColor systemOrangeColor];
        self.testClickCount = 0;
    }
}

- (void)manualTriggerButtonTapped:(UIButton *)sender {
    // 手动触发防频繁点击
    NSLog(@"手动触发防频繁点击");
    
    // 创建临时的防频繁点击管理器
    TFYPanModalFrequentTapPrevention *prevention = [TFYPanModalFrequentTapPrevention preventionWithInterval:self.intervalSlider.value];
    prevention.delegate = self;
    prevention.enabled = self.preventionSwitch.isOn;
    prevention.shouldShowHint = YES;
    prevention.hintText = [NSString stringWithFormat:@"手动触发：请等待 %.1f 秒", self.intervalSlider.value];
    
    // 触发防频繁点击
    [prevention triggerPrevention];
    
    // 显示提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手动触发"
                                                                 message:[NSString stringWithFormat:@"已手动触发防频繁点击，间隔：%.1f秒", self.intervalSlider.value]
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
