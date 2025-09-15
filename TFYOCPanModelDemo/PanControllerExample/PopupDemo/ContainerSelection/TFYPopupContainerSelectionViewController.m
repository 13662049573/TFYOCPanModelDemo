//
//  TFYPopupContainerSelectionViewController.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗容器选择演示控制器实现
//

#import "TFYPopupContainerSelectionViewController.h"
#import "TFYPopupContainerSelectionTestViewController.h"
#import "TFYPopup.h"
#import "TFYPopupContainerManager.h"
#import "TFYPopupContainerType.h"

@interface TFYPopupContainerSelectionViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *demoContainerView;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation TFYPopupContainerSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    self.title = @"容器选择演示";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"调试信息" 
                                                                             style:UIBarButtonItemStylePlain 
                                                                            target:self 
                                                                            action:@selector(showDebugInfo)];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    // 创建堆栈视图
    self.stackView = [[UIStackView alloc] init];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = 20;
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.stackView];
    
    // 创建演示容器视图
    [self setupDemoContainerView];
    
    // 创建信息标签
    [self setupInfoLabel];
    
    // 创建按钮
    [self setupButtons];
    
    // 设置约束
    [self setupConstraints];
}

- (void)setupDemoContainerView {
    self.demoContainerView = [[UIView alloc] init];
    self.demoContainerView.backgroundColor = [UIColor systemGray6Color];
    self.demoContainerView.layer.cornerRadius = 12;
    self.demoContainerView.layer.borderWidth = 2;
    self.demoContainerView.layer.borderColor = [UIColor systemBlueColor].CGColor;
    self.demoContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.stackView addArrangedSubview:self.demoContainerView];
    
    UILabel *containerLabel = [[UILabel alloc] init];
    containerLabel.text = @"演示容器视图\n(用于测试在指定视图中弹出)";
    containerLabel.textAlignment = NSTextAlignmentCenter;
    containerLabel.numberOfLines = 0;
    containerLabel.font = [UIFont systemFontOfSize:16];
    containerLabel.textColor = [UIColor systemBlueColor];
    containerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.demoContainerView addSubview:containerLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [containerLabel.centerXAnchor constraintEqualToAnchor:self.demoContainerView.centerXAnchor],
        [containerLabel.centerYAnchor constraintEqualToAnchor:self.demoContainerView.centerYAnchor],
        [self.demoContainerView.heightAnchor constraintEqualToConstant:120]
    ]];
}

- (void)setupInfoLabel {
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.text = @"点击下方按钮测试不同的容器选择策略";
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.font = [UIFont systemFontOfSize:14];
    self.infoLabel.textColor = [UIColor secondaryLabelColor];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.stackView addArrangedSubview:self.infoLabel];
}

- (void)setupButtons {
    // 自动选择策略按钮
    UIButton *autoStrategyButton = [self createButtonWithTitle:@"自动选择策略\n(默认选择UIWindow)" 
                                                       action:@selector(testAutoStrategy)];
    [self.stackView addArrangedSubview:autoStrategyButton];
    
    // 智能选择策略按钮
    UIButton *smartStrategyButton = [self createButtonWithTitle:@"智能选择策略\n(用户指定偏好)" 
                                                        action:@selector(testSmartStrategy)];
    [self.stackView addArrangedSubview:smartStrategyButton];
    
    // 手动选择策略按钮
    UIButton *manualStrategyButton = [self createButtonWithTitle:@"手动选择策略\n(按优先级排序)" 
                                                         action:@selector(testManualStrategy)];
    [self.stackView addArrangedSubview:manualStrategyButton];
    
    // 指定容器类型按钮
    UIButton *specifyTypeButton = [self createButtonWithTitle:@"指定容器类型\n(强制使用当前控制器)" 
                                                      action:@selector(testSpecifyContainerType)];
    [self.stackView addArrangedSubview:specifyTypeButton];
    
    // 指定容器视图按钮
    UIButton *specifyViewButton = [self createButtonWithTitle:@"指定容器视图\n(使用演示容器视图)" 
                                                      action:@selector(testSpecifyContainerView)];
    [self.stackView addArrangedSubview:specifyViewButton];
    
    // 自定义选择器按钮
    UIButton *customSelectorButton = [self createButtonWithTitle:@"自定义选择器\n(自定义选择逻辑)" 
                                                         action:@selector(testCustomSelector)];
    [self.stackView addArrangedSubview:customSelectorButton];
    
    // 容器发现测试按钮
    UIButton *discoveryTestButton = [self createButtonWithTitle:@"容器发现测试\n(查看所有可用容器)" 
                                                        action:@selector(testContainerDiscovery)];
    [self.stackView addArrangedSubview:discoveryTestButton];
    
    // 自动化测试按钮
    UIButton *autoTestButton = [self createButtonWithTitle:@"自动化测试\n(运行完整的容器选择测试)" 
                                                    action:@selector(launchAutoTest)];
    [self.stackView addArrangedSubview:autoTestButton];
}

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = [UIColor systemBlueColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 8;
    
    // 使用现代的 UIButton 配置方式（iOS 15+）
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = [UIButtonConfiguration filledButtonConfiguration];
        config.contentInsets = NSDirectionalEdgeInsetsMake(12, 16, 12, 16);
        config.title = title;
        config.baseBackgroundColor = [UIColor systemBlueColor];
        config.baseForegroundColor = [UIColor whiteColor];
        button.configuration = config;
    }
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // 滚动视图约束
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        // 堆栈视图约束
        [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:20],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:20],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-20],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-20],
        [self.stackView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor constant:-40]
    ]];
}

#pragma mark - Test Methods

- (void)testAutoStrategy {
    [self showPopupWithConfiguration:^{
        TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
        config.containerSelectionStrategy = TFYPopupContainerSelectionStrategyAuto;
        config.enableContainerDebugMode = YES;
        // 默认会选择UIWindow，这是最安全的选择
        return config;
    } title:@"自动选择策略\n(默认选择UIWindow)"];
}

- (void)testSmartStrategy {
    [self showPopupWithConfiguration:^{
        TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
        config.containerSelectionStrategy = TFYPopupContainerSelectionStrategySmart;
        config.preferredContainerType = TFYPopupContainerTypeViewController; // 用户明确指定偏好
        config.enableContainerDebugMode = YES;
        return config;
    } title:@"智能选择策略\n(用户指定偏好当前控制器)"];
}

- (void)testManualStrategy {
    [self showPopupWithConfiguration:^{
        TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
        config.containerSelectionStrategy = TFYPopupContainerSelectionStrategyManual;
        config.enableContainerDebugMode = YES;
        return config;
    } title:@"手动选择策略"];
}

- (void)testSpecifyContainerType {
    [self showPopupWithConfiguration:^{
        TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
        config.containerSelectionStrategy = TFYPopupContainerSelectionStrategySmart;
        config.preferredContainerType = TFYPopupContainerTypeViewController;
        config.allowContainerFallback = NO; // 不允许降级
        config.enableContainerDebugMode = YES;
        return config;
    } title:@"指定容器类型"];
}

- (void)testSpecifyContainerView {
    // 直接指定容器视图
    UIView *contentView = [self createTestContentViewWithTitle:@"指定容器视图测试"];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.enableContainerDebugMode = YES;
    
    [TFYPopupView showContentView:contentView
                    containerView:self.view
                    configuration:config
                         animator:[[TFYPopupFadeInOutAnimator alloc] init]
                         animated:YES
                       completion:^{
        NSLog(@"弹窗在指定容器视图中显示完成");
    }];
}

- (void)testCustomSelector {
    // 创建自定义选择器
    TFYPopupDefaultContainerSelector *customSelector = [[TFYPopupDefaultContainerSelector alloc] initWithStrategy:TFYPopupContainerSelectionStrategyCustom];
    customSelector.preferCurrentViewController = YES;
    customSelector.preferWindowContainer = NO;
    
    // 设置自定义优先级计算
    customSelector.customPriorityCalculator = ^NSInteger(TFYPopupContainerInfo *containerInfo) {
        NSInteger baseScore = containerInfo.priority;
        
        // 大幅提高UIViewController的优先级
        if (containerInfo.type == TFYPopupContainerTypeViewController) {
            baseScore += 200;
        }
        
        // 降低UIWindow的优先级
        if (containerInfo.type == TFYPopupContainerTypeWindow) {
            baseScore -= 50;
        }
        
        return baseScore;
    };
    
    // 设置自定义选择器
    [[TFYPopupContainerManager sharedManager] setDefaultContainerSelector:customSelector];
    
    [self showPopupWithConfiguration:^{
        TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
        config.containerSelectionStrategy = TFYPopupContainerSelectionStrategyCustom;
        config.customContainerSelector = customSelector;
        config.enableContainerDebugMode = YES;
        return config;
    } title:@"自定义选择器"];
}

- (void)testContainerDiscovery {
    [[TFYPopupContainerManager sharedManager] discoverAvailableContainersWithCompletion:^(NSArray<TFYPopupContainerInfo *> *containers, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self showAlertWithTitle:@"容器发现失败" message:error.localizedDescription];
                return;
            }
            
            NSMutableString *message = [NSMutableString stringWithString:@"发现的容器:\n\n"];
            for (TFYPopupContainerInfo *container in containers) {
                [message appendFormat:@"• %@ (%@)\n", container.name, [TFYPopupContainerManager descriptionForContainerType:container.type]];
                [message appendFormat:@"  描述: %@\n", container.containerDescription];
                [message appendFormat:@"  可用: %@\n\n", container.isAvailable ? @"是" : @"否"];
            }
            
            [self showAlertWithTitle:@"容器发现结果" message:message];
        });
    }];
}

- (void)showPopupWithConfiguration:(TFYPopupViewConfiguration *(^)(void))configBlock title:(NSString *)title {
    UIView *contentView = [self createTestContentViewWithTitle:title];
    TFYPopupViewConfiguration *config = configBlock();
    
    [TFYPopupView showContentViewWithContainerSelection:contentView
                                          configuration:config
                                               animator:[[TFYPopupFadeInOutAnimator alloc] init]
                                               animated:YES
                                             completion:^{
        NSLog(@"弹窗显示完成 - %@", title);
    }];
}

- (UIView *)createTestContentViewWithTitle:(NSString *)title {
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
    
    // 描述标签
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"这是一个测试弹窗，用于演示容器选择功能。\n点击背景或此弹窗外部区域可以关闭。";
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.numberOfLines = 0;
    descLabel.textColor = [UIColor secondaryLabelColor];
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:descLabel];
    
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor systemBlueColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 6;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton addTarget:self action:@selector(closeCurrentPopup) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeButton];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [contentView.widthAnchor constraintEqualToConstant:280],
        [contentView.heightAnchor constraintEqualToConstant:200],
        
        [titleLabel.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        [descLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:12],
        [descLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [descLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        [closeButton.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-20],
        [closeButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [closeButton.widthAnchor constraintEqualToConstant:80],
        [closeButton.heightAnchor constraintEqualToConstant:32]
    ]];
    
    return contentView;
}

- (void)closeCurrentPopup {
    NSLog(@"TFYPopupContainerSelectionViewController: 开始关闭所有弹窗");
    
    // 先检查当前弹窗数量
    NSInteger currentCount = [TFYPopupView currentPopupCount];
    NSLog(@"TFYPopupContainerSelectionViewController: 当前弹窗数量: %ld", (long)currentCount);
    
    // 获取当前弹窗列表
    NSArray<TFYPopupView *> *currentPopups = [TFYPopupView allCurrentPopups];
    NSLog(@"TFYPopupContainerSelectionViewController: 当前弹窗列表: %@", currentPopups);
    
    [TFYPopupView dismissAllAnimated:YES completion:^{
        NSLog(@"TFYPopupContainerSelectionViewController: 弹窗关闭完成");
        
        // 再次检查弹窗数量
        NSInteger afterCount = [TFYPopupView currentPopupCount];
        NSLog(@"TFYPopupContainerSelectionViewController: 关闭后弹窗数量: %ld", (long)afterCount);
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showDebugInfo {
    [[TFYPopupContainerManager sharedManager] logCurrentContainerStates];
    
    // 显示当前弹窗信息
    NSArray<TFYPopupView *> *currentPopups = [TFYPopupView allCurrentPopups];
    NSMutableString *message = [NSMutableString stringWithFormat:@"当前弹窗数量: %lu\n\n", (unsigned long)currentPopups.count];
    
    for (NSInteger i = 0; i < currentPopups.count; i++) {
        TFYPopupView *popup = currentPopups[i];
        [message appendFormat:@"弹窗 %ld: %@\n", (long)(i + 1), popup.class];
        [message appendFormat:@"容器: %@\n", popup.superview.class];
        [message appendFormat:@"是否正在显示: %@\n\n", popup.isPresenting ? @"是" : @"否"];
    }
    
    // 添加测试关闭按钮
    [message appendString:@"\n点击确定后测试关闭功能"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"调试信息" 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 测试关闭功能
        [self testCloseFunction];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)testCloseFunction {
    NSLog(@"=== 开始测试关闭功能 ===");
    
    // 显示一个测试弹窗
    UIView *testContentView = [self createTestContentViewWithTitle:@"测试关闭功能"];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.enableContainerDebugMode = YES;
    
    [TFYPopupView showContentViewWithContainerSelection:testContentView
                                          configuration:config
                                               animator:[[TFYPopupFadeInOutAnimator alloc] init]
                                               animated:YES
                                             completion:^{
        NSLog(@"测试弹窗显示完成");
        
        // 延迟2秒后测试关闭
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"开始测试关闭功能");
            [self closeCurrentPopup];
        });
    }];
}

- (void)launchAutoTest {
    NSLog(@"启动自动化容器选择测试");
    
    // 创建测试控制器
    TFYPopupContainerSelectionTestViewController *testVC = [[TFYPopupContainerSelectionTestViewController alloc] init];
    
    // 包装在导航控制器中
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:testVC];
    
    // 添加关闭按钮
    testVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(dismissTestViewController)];
    
    // 模态展示
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)dismissTestViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
