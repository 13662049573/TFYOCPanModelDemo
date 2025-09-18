//
//  TFYPopupContainerSelectionTestViewController.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：容器选择功能测试控制器实现
//

#import "TFYPopupContainerSelectionTestViewController.h"
#import "TFYPopup.h"
#import "TFYPopupContainerManager.h"
#import "TFYPopupContainerType.h"

@interface TFYPopupContainerSelectionTestViewController ()

@property (nonatomic, strong) UIView *testContainerView;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIButton *restartTestButton;

@end

@implementation TFYPopupContainerSelectionTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    // 延迟启动测试，让用户先看到界面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self runContainerSelectionTest];
    });
}

- (void)setupUI {
    self.title = @"容器选择测试";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // 创建测试容器视图
    self.testContainerView = [[UIView alloc] init];
    self.testContainerView.backgroundColor = [UIColor systemYellowColor];
    self.testContainerView.layer.cornerRadius = 12;
    self.testContainerView.layer.borderWidth = 3;
    self.testContainerView.layer.borderColor = [UIColor systemRedColor].CGColor;
    self.testContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.testContainerView];
    
    // 创建结果标签
    self.resultLabel = [[UILabel alloc] init];
    self.resultLabel.text = @"准备开始容器选择功能测试...";
    self.resultLabel.font = [UIFont systemFontOfSize:16];
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.numberOfLines = 0;
    self.resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.resultLabel];
    
    // 创建重新测试按钮
    self.restartTestButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.restartTestButton setTitle:@"重新运行测试" forState:UIControlStateNormal];
    self.restartTestButton.backgroundColor = [UIColor systemBlueColor];
    [self.restartTestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.restartTestButton.layer.cornerRadius = 8;
    self.restartTestButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.restartTestButton addTarget:self action:@selector(restartTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.restartTestButton];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [self.testContainerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.testContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.testContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.testContainerView.heightAnchor constraintEqualToConstant:200],
        
        [self.resultLabel.topAnchor constraintEqualToAnchor:self.testContainerView.bottomAnchor constant:20],
        [self.resultLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.resultLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.restartTestButton.topAnchor constraintEqualToAnchor:self.resultLabel.bottomAnchor constant:20],
        [self.restartTestButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.restartTestButton.widthAnchor constraintEqualToConstant:150],
        [self.restartTestButton.heightAnchor constraintEqualToConstant:44]
    ]];
}

- (void)runContainerSelectionTest {
    // 测试1：自动选择策略（应该优先选择当前视图控制器）
    [self testAutoStrategy];
    
    // 延迟执行其他测试
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testSmartStrategy];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testSpecifyContainerView];
    });
}

- (void)testAutoStrategy {
    self.resultLabel.text = @"测试1: 自动选择策略\n(默认选择UIWindow，这是正确的行为)";
    
    UIView *contentView = [self createTestContentViewWithTitle:@"自动选择测试" 
                                                      message:@"默认行为：弹窗应该显示在UIWindow中，这是最安全的选择"];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerSelectionStrategy = TFYPopupContainerSelectionStrategyAuto;
    
    [TFYPopupView showContentViewWithContainerSelection:contentView
                                          configuration:config
                                               animator:[[TFYPopupFadeInOutAnimator alloc] init]
                                               animated:YES
                                             completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)testSmartStrategy {
    self.resultLabel.text = @"测试2: 智能选择策略\n(用户指定偏好当前视图控制器)";
    
    UIView *contentView = [self createTestContentViewWithTitle:@"智能选择测试" 
                                                      message:@"用户明确指定偏好：应该优先选择当前视图控制器"];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerSelectionStrategy = TFYPopupContainerSelectionStrategySmart;
    config.preferredContainerType = TFYPopupContainerTypeViewController; // 用户明确指定偏好
    
    [TFYPopupView showContentViewWithContainerSelection:contentView
                                          configuration:config
                                               animator:[[TFYPopupZoomInOutAnimator alloc] init]
                                               animated:YES
                                             completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)testSpecifyContainerView {
    self.resultLabel.text = @"测试3: 指定容器视图\n(应该显示在黄色测试容器中)";
    
    UIView *contentView = [self createTestContentViewWithTitle:@"指定容器测试" 
                                                      message:@"这个弹窗应该显示在黄色的测试容器视图中"];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    
    [TFYPopupView showContentView:contentView
                    containerView:self.testContainerView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (UIView *)createTestContentViewWithTitle:(NSString *)title message:(NSString *)message {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 12;
    contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    contentView.layer.shadowOffset = CGSizeMake(0, 2);
    contentView.layer.shadowRadius = 8;
    contentView.layer.shadowOpacity = 0.3;
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:titleLabel];
    
    // 消息标签
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.textColor = [UIColor secondaryLabelColor];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:messageLabel];
    
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor systemBlueColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 6;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 使用现代的 UIButton 配置方式（iOS 15+）
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = [UIButtonConfiguration filledButtonConfiguration];
        config.title = @"关闭";
        config.baseBackgroundColor = [UIColor systemBlueColor];
        config.baseForegroundColor = [UIColor whiteColor];
        closeButton.configuration = config;
    }
    
    [closeButton addTarget:self action:@selector(closeCurrentPopup) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeButton];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [contentView.widthAnchor constraintEqualToConstant:280],
        [contentView.heightAnchor constraintEqualToConstant:180],
        
        [titleLabel.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        [messageLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:12],
        [messageLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [messageLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        [closeButton.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-20],
        [closeButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [closeButton.widthAnchor constraintEqualToConstant:80],
        [closeButton.heightAnchor constraintEqualToConstant:32]
    ]];
    
    return contentView;
}

- (void)closeCurrentPopup {
    [TFYPopupView dismissAllAnimated:YES completion:nil];
}

- (void)restartTest {
    NSLog(@"重新运行容器选择测试");
    
    // 先关闭所有现有弹窗
    [TFYPopupView dismissAllAnimated:YES completion:^ {
        // 重置状态
        self.resultLabel.text = @"准备重新开始容器选择功能测试...";
        
        // 延迟1秒后重新开始测试
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self runContainerSelectionTest];
        });
    }];
}

@end
