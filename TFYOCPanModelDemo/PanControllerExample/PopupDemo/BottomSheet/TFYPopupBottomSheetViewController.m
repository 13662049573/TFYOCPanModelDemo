//
//  TFYPopupBottomSheetViewController.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：底部弹出框演示控制器实现
//

#import "TFYPopupBottomSheetViewController.h"
#import "TFYPopup.h"
#import <Masonry/Masonry.h>

/// 底部弹出框演示类型
typedef NS_ENUM(NSInteger, TFYBottomSheetDemoType) {
    TFYBottomSheetDemoTypeBasic = 0,        // 基础底部弹出框
    TFYBottomSheetDemoTypeGestureEnabled,   // 启用手势的底部弹出框
    TFYBottomSheetDemoTypeCustomHeight,     // 自定义高度
    TFYBottomSheetDemoTypeWithScrollView,   // 包含滚动视图
    TFYBottomSheetDemoTypeWithForm,         // 表单输入
    TFYBottomSheetDemoTypeWithNavigation    // 带导航的底部弹出框
};

/// 底部弹出框演示模型
@interface TFYBottomSheetDemoModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailDescription;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) TFYBottomSheetDemoType type;
@property (nonatomic, strong) UIColor *backgroundColor;

+ (instancetype)modelWithTitle:(NSString *)title
                   description:(NSString *)description
                          icon:(NSString *)icon
                          type:(TFYBottomSheetDemoType)type
               backgroundColor:(UIColor *)backgroundColor;

@end

@implementation TFYBottomSheetDemoModel

+ (instancetype)modelWithTitle:(NSString *)title
                   description:(NSString *)description
                          icon:(NSString *)icon
                          type:(TFYBottomSheetDemoType)type
               backgroundColor:(UIColor *)backgroundColor {
    TFYBottomSheetDemoModel *model = [[TFYBottomSheetDemoModel alloc] init];
    model.title = title;
    model.detailDescription = description;
    model.icon = icon;
    model.type = type;
    model.backgroundColor = backgroundColor;
    return model;
}

@end

@interface TFYPopupBottomSheetViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<TFYBottomSheetDemoModel *> *demoModels;

@end

@implementation TFYPopupBottomSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupDemoModels];
}

- (void)setupUI {
    self.title = @"底部弹出框演示";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    // 添加帮助按钮
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithTitle:@"帮助"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(showHelpInfo)];
    self.navigationItem.rightBarButtonItem = helpButton;
}

- (void)setupDemoModels {
    NSMutableArray *models = [NSMutableArray array];
    
    [models addObject:[TFYBottomSheetDemoModel modelWithTitle:@"基础底部弹出框"
                                                  description:@"最简单的底部弹出框实现"
                                                         icon:@"📋"
                                                         type:TFYBottomSheetDemoTypeBasic
                                              backgroundColor:[UIColor systemBlueColor]]];
    
    [models addObject:[TFYBottomSheetDemoModel modelWithTitle:@"手势交互弹出框"
                                                  description:@"支持拖拽手势调整高度"
                                                         icon:@"☝️"
                                                         type:TFYBottomSheetDemoTypeGestureEnabled
                                              backgroundColor:[UIColor systemGreenColor]]];
    
    [models addObject:[TFYBottomSheetDemoModel modelWithTitle:@"自定义高度"
                                                  description:@"设置默认、最小、最大高度"
                                                         icon:@"📏"
                                                         type:TFYBottomSheetDemoTypeCustomHeight
                                              backgroundColor:[UIColor systemOrangeColor]]];
    
    [models addObject:[TFYBottomSheetDemoModel modelWithTitle:@"滚动视图内容"
                                                  description:@"包含可滚动内容的弹出框"
                                                         icon:@"📜"
                                                         type:TFYBottomSheetDemoTypeWithScrollView
                                              backgroundColor:[UIColor systemPurpleColor]]];
    
    [models addObject:[TFYBottomSheetDemoModel modelWithTitle:@"表单输入"
                                                  description:@"包含输入框的弹出框，支持键盘适配"
                                                         icon:@"📝"
                                                         type:TFYBottomSheetDemoTypeWithForm
                                              backgroundColor:[UIColor systemRedColor]]];
    
    [models addObject:[TFYBottomSheetDemoModel modelWithTitle:@"带导航弹出框"
                                                  description:@"包含导航栏的底部弹出框"
                                                         icon:@"🧭"
                                                         type:TFYBottomSheetDemoTypeWithNavigation
                                              backgroundColor:[UIColor systemTealColor]]];
    
    self.demoModels = [models copy];
}

#pragma mark - Actions

- (void)showHelpInfo {
    UIView *helpView = [self createHelpView];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.dismissOnBackgroundTap = YES;
    config.enableHapticFeedback = YES;
    
    [TFYPopupView showContentView:helpView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (UIView *)createHelpView {
    UIView *helpView = [[UIView alloc] init];
    helpView.backgroundColor = [UIColor systemBackgroundColor];
    helpView.layer.cornerRadius = 16;
    helpView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"底部弹出框使用说明";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [helpView addSubview:titleLabel];
    
    // 说明文本
    NSString *helpText = @"• 点击列表项查看不同类型的底部弹出框\n• 支持手势的弹出框可以上下拖拽调整高度\n• 向下拖拽到阈值可以关闭弹出框\n• 快速向上滑动可以展开到最大高度\n• 点击背景区域或按钮可以关闭弹出框";
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = helpText;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor labelColor];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [helpView addSubview:contentLabel];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // helpView 尺寸
        [helpView.widthAnchor constraintEqualToConstant:320],
        [helpView.heightAnchor constraintGreaterThanOrEqualToConstant:200],
        
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:helpView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:helpView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:helpView.trailingAnchor constant:-20],
        
        // contentLabel
        [contentLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [contentLabel.leadingAnchor constraintEqualToAnchor:helpView.leadingAnchor constant:20],
        [contentLabel.trailingAnchor constraintEqualToAnchor:helpView.trailingAnchor constant:-20],
        [contentLabel.bottomAnchor constraintEqualToAnchor:helpView.bottomAnchor constant:-20]
    ]];
    
    return helpView;
}

- (void)showDemoWithModel:(TFYBottomSheetDemoModel *)model {
    switch (model.type) {
        case TFYBottomSheetDemoTypeBasic:
            [self showBasicBottomSheet];
            break;
        case TFYBottomSheetDemoTypeGestureEnabled:
            [self showGestureEnabledBottomSheet];
            break;
        case TFYBottomSheetDemoTypeCustomHeight:
            [self showCustomHeightBottomSheet];
            break;
        case TFYBottomSheetDemoTypeWithScrollView:
            [self showScrollViewBottomSheet];
            break;
        case TFYBottomSheetDemoTypeWithForm:
            [self showFormBottomSheet];
            break;
        case TFYBottomSheetDemoTypeWithNavigation:
            [self showNavigationBottomSheet];
            break;
    }
}

- (void)showBasicBottomSheet {
    UIView *contentView = [self createBasicContentView];
    
    [TFYPopupView showBottomSheetWithContentView:contentView
                                        animated:YES
                                      completion:^{
        NSLog(@"基础底部弹出框显示完成");
    }];
}

- (void)showGestureEnabledBottomSheet {
    UIView *contentView = [self createGestureContentView];
    
    // 创建底部弹出框配置
    TFYPopupBottomSheetConfiguration *config = [[TFYPopupBottomSheetConfiguration alloc] init];
    config.defaultHeight = 350;
    config.minimumHeight = 200;
    config.maximumHeight = [UIScreen mainScreen].bounds.size.height - 100;
    config.enableGestures = YES; // 启用手势
    config.allowsFullScreen = YES;
    
    // 创建动画器
    TFYPopupBottomSheetAnimator *animator = [[TFYPopupBottomSheetAnimator alloc] initWithConfiguration:config];
    
    TFYPopupViewConfiguration *popupConfig = [[TFYPopupViewConfiguration alloc] init];
    popupConfig.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:popupConfig
                         animator:animator
                         animated:YES
                       completion:^{
        NSLog(@"手势底部弹出框显示完成");
    }];
}

- (void)showCustomHeightBottomSheet {
    UIView *contentView = [self createCustomHeightContentView];
    
    // 自定义高度配置
    TFYPopupBottomSheetConfiguration *config = [[TFYPopupBottomSheetConfiguration alloc] init];
    config.defaultHeight = 500;
    config.minimumHeight = 300;
    config.maximumHeight = 700;
    config.allowsFullScreen = NO; // 不允许全屏
    
    TFYPopupBottomSheetAnimator *animator = [[TFYPopupBottomSheetAnimator alloc] initWithConfiguration:config];
    
    [TFYPopupView showContentView:contentView
                    configuration:[[TFYPopupViewConfiguration alloc] init]
                         animator:animator
                         animated:YES
                       completion:nil];
}

- (void)showScrollViewBottomSheet {
    UIView *contentView = [self createScrollViewContentView];
    
    TFYPopupBottomSheetConfiguration *config = [[TFYPopupBottomSheetConfiguration alloc] init];
    config.defaultHeight = 400;
    config.enableGestures = YES;
    
    TFYPopupBottomSheetAnimator *animator = [[TFYPopupBottomSheetAnimator alloc] initWithConfiguration:config];
    
    [TFYPopupView showContentView:contentView
                    configuration:[[TFYPopupViewConfiguration alloc] init]
                         animator:animator
                         animated:YES
                       completion:nil];
}

- (void)showFormBottomSheet {
    UIView *contentView = [self createFormContentView];
    
    TFYPopupBottomSheetConfiguration *config = [[TFYPopupBottomSheetConfiguration alloc] init];
    config.defaultHeight = 300;
    config.enableGestures = YES;
    
    // 启用键盘适配
    TFYPopupViewConfiguration *popupConfig = [[TFYPopupViewConfiguration alloc] init];
    popupConfig.keyboardConfiguration.isEnabled = YES;
    popupConfig.keyboardConfiguration.avoidingMode = TFYKeyboardAvoidingModeTransform;
    
    TFYPopupBottomSheetAnimator *animator = [[TFYPopupBottomSheetAnimator alloc] initWithConfiguration:config];
    
    [TFYPopupView showContentView:contentView
                    configuration:popupConfig
                         animator:animator
                         animated:YES
                       completion:nil];
}

- (void)showNavigationBottomSheet {
    UIView *contentView = [self createNavigationContentView];
    
    TFYPopupBottomSheetConfiguration *config = [[TFYPopupBottomSheetConfiguration alloc] init];
    config.defaultHeight = 450;
    config.enableGestures = YES;
    config.allowsFullScreen = YES;
    
    TFYPopupBottomSheetAnimator *animator = [[TFYPopupBottomSheetAnimator alloc] initWithConfiguration:config];
    
    [TFYPopupView showContentView:contentView
                    configuration:[[TFYPopupViewConfiguration alloc] init]
                         animator:animator
                         animated:YES
                       completion:nil];
}

#pragma mark - Content View Creation Methods

- (UIView *)createBasicContentView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor systemBackgroundColor];
    
    // 顶部指示器
    UIView *indicator = [[UIView alloc] init];
    indicator.backgroundColor = [UIColor tertiaryLabelColor];
    indicator.layer.cornerRadius = 2;
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:indicator];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"基础底部弹出框";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:titleLabel];
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"这是一个最基础的底部弹出框示例。\n\n它包含简单的文本内容，没有特殊的交互功能。\n\n点击背景或按钮可以关闭。";
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = [UIColor secondaryLabelColor];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:contentLabel];
    
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    closeButton.backgroundColor = [UIColor systemBlueColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(closeCurrentPopup:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // indicator
        [indicator.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:8],
        [indicator.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [indicator.widthAnchor constraintEqualToConstant:36],
        [indicator.heightAnchor constraintEqualToConstant:4],
        
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:indicator.bottomAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        // contentLabel
        [contentLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:20],
        [contentLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [contentLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        // closeButton
        [closeButton.topAnchor constraintGreaterThanOrEqualToAnchor:contentLabel.bottomAnchor constant:20],
        [closeButton.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [closeButton.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [closeButton.bottomAnchor constraintEqualToAnchor:contentView.safeAreaLayoutGuide.bottomAnchor constant:-20],
        [closeButton.heightAnchor constraintEqualToConstant:50]
    ]];
    
    return contentView;
}

- (UIView *)createGestureContentView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor systemBackgroundColor];
    
    // 顶部指示器
    UIView *indicator = [[UIView alloc] init];
    indicator.backgroundColor = [UIColor systemGreenColor];
    indicator.layer.cornerRadius = 3;
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:indicator];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"手势交互弹出框 ☝️";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor systemGreenColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:titleLabel];
    
    // 手势说明
    UILabel *gestureLabel = [[UILabel alloc] init];
    gestureLabel.text = @"📖 手势使用说明：\n\n• 上下拖拽调整高度\n• 快速向上滑动展开到最大高度\n• 向下拖拽到阈值关闭弹出框";
    gestureLabel.font = [UIFont systemFontOfSize:16];
    gestureLabel.numberOfLines = 0;
    gestureLabel.textColor = [UIColor labelColor];
    gestureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:gestureLabel];
    
    // 状态显示
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = @"💡 提示：此弹出框已启用手势交互";
    statusLabel.font = [UIFont systemFontOfSize:14];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = [UIColor secondaryLabelColor];
    statusLabel.backgroundColor = [[UIColor systemGreenColor] colorWithAlphaComponent:0.1];
    statusLabel.layer.cornerRadius = 8;
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:statusLabel];
    
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    closeButton.backgroundColor = [UIColor systemGreenColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(closeCurrentPopup:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // indicator
        [indicator.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:8],
        [indicator.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [indicator.widthAnchor constraintEqualToConstant:50],
        [indicator.heightAnchor constraintEqualToConstant:6],
        
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:indicator.bottomAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        // gestureLabel
        [gestureLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:20],
        [gestureLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [gestureLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        // statusLabel
        [statusLabel.topAnchor constraintEqualToAnchor:gestureLabel.bottomAnchor constant:20],
        [statusLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [statusLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [statusLabel.heightAnchor constraintEqualToConstant:40],
        
        // closeButton
        [closeButton.topAnchor constraintGreaterThanOrEqualToAnchor:statusLabel.bottomAnchor constant:20],
        [closeButton.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [closeButton.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [closeButton.bottomAnchor constraintEqualToAnchor:contentView.safeAreaLayoutGuide.bottomAnchor constant:-20],
        [closeButton.heightAnchor constraintEqualToConstant:50]
    ]];
    
    return contentView;
}

- (UIView *)createCustomHeightContentView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor systemBackgroundColor];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"自定义高度弹出框 📏";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor systemOrangeColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:titleLabel];
    
    // 高度信息
    UILabel *heightInfoLabel = [[UILabel alloc] init];
    heightInfoLabel.text = @"📊 高度配置：\n• 默认高度：500pt\n• 最小高度：300pt\n• 最大高度：700pt\n• 不允许全屏展开";
    heightInfoLabel.font = [UIFont systemFontOfSize:16];
    heightInfoLabel.numberOfLines = 0;
    heightInfoLabel.textColor = [UIColor labelColor];
    heightInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:heightInfoLabel];
    
    // 功能说明
    UILabel *featureLabel = [[UILabel alloc] init];
    featureLabel.text = @"这个示例展示了如何自定义底部弹出框的高度参数。通过配置不同的高度值，可以精确控制弹出框的显示效果。";
    featureLabel.font = [UIFont systemFontOfSize:14];
    featureLabel.numberOfLines = 0;
    featureLabel.textAlignment = NSTextAlignmentCenter;
    featureLabel.textColor = [UIColor secondaryLabelColor];
    featureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:featureLabel];
    
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    closeButton.backgroundColor = [UIColor systemOrangeColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(closeCurrentPopup:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:30],
        [titleLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        // heightInfoLabel
        [heightInfoLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:20],
        [heightInfoLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [heightInfoLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        // featureLabel
        [featureLabel.topAnchor constraintEqualToAnchor:heightInfoLabel.bottomAnchor constant:20],
        [featureLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [featureLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        // closeButton
        [closeButton.topAnchor constraintGreaterThanOrEqualToAnchor:featureLabel.bottomAnchor constant:20],
        [closeButton.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [closeButton.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [closeButton.bottomAnchor constraintEqualToAnchor:contentView.safeAreaLayoutGuide.bottomAnchor constant:-20],
        [closeButton.heightAnchor constraintEqualToConstant:50]
    ]];
    
    return contentView;
}

- (UIView *)createScrollViewContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"滚动内容弹出框 📜";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor systemPurpleColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:titleLabel];
    
    // 滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [[UIColor systemPurpleColor] colorWithAlphaComponent:0.05];
    scrollView.layer.cornerRadius = 8;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:scrollView];
    
    // 滚动内容
    UIView *scrollContentView = [[UIView alloc] init];
    scrollContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:scrollContentView];
    
    // 添加大量内容项
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 12;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollContentView addSubview:stackView];
    
    for (int i = 1; i <= 20; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = [UIColor systemBackgroundColor];
        itemView.layer.cornerRadius = 8;
        itemView.layer.borderWidth = 1;
        itemView.layer.borderColor = [[UIColor systemPurpleColor] colorWithAlphaComponent:0.2].CGColor;
        
        UILabel *itemLabel = [[UILabel alloc] init];
        itemLabel.text = [NSString stringWithFormat:@"📦 滚动项目 %d", i];
        itemLabel.font = [UIFont systemFontOfSize:16];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        itemLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [itemView addSubview:itemLabel];
        
        [NSLayoutConstraint activateConstraints:@[
            [itemView.heightAnchor constraintEqualToConstant:50],
            [itemLabel.centerXAnchor constraintEqualToAnchor:itemView.centerXAnchor],
            [itemLabel.centerYAnchor constraintEqualToAnchor:itemView.centerYAnchor]
        ]];
        
        [stackView addArrangedSubview:itemView];
    }
    
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    closeButton.backgroundColor = [UIColor systemPurpleColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(closeCurrentPopup:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        // scrollView
        [scrollView.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [scrollView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [scrollView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        [scrollView.bottomAnchor constraintEqualToAnchor:closeButton.topAnchor constant:-16],
        
        // scrollContentView
        [scrollContentView.topAnchor constraintEqualToAnchor:scrollView.topAnchor],
        [scrollContentView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor],
        [scrollContentView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor],
        [scrollContentView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor],
        [scrollContentView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor],
        
        // stackView
        [stackView.topAnchor constraintEqualToAnchor:scrollContentView.topAnchor constant:16],
        [stackView.leadingAnchor constraintEqualToAnchor:scrollContentView.leadingAnchor constant:16],
        [stackView.trailingAnchor constraintEqualToAnchor:scrollContentView.trailingAnchor constant:-16],
        [stackView.bottomAnchor constraintEqualToAnchor:scrollContentView.bottomAnchor constant:-16],
        
        // closeButton
        [closeButton.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [closeButton.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        [closeButton.bottomAnchor constraintEqualToAnchor:containerView.safeAreaLayoutGuide.bottomAnchor constant:-20],
        [closeButton.heightAnchor constraintEqualToConstant:50]
    ]];
    
    return containerView;
}

- (UIView *)createFormContentView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor systemBackgroundColor];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"表单输入弹出框 📝";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor systemRedColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:titleLabel];
    
    // 姓名输入
    UITextField *nameField = [[UITextField alloc] init];
    nameField.placeholder = @"请输入姓名";
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.font = [UIFont systemFontOfSize:16];
    nameField.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:nameField];
    
    // 邮箱输入
    UITextField *emailField = [[UITextField alloc] init];
    emailField.placeholder = @"请输入邮箱";
    emailField.borderStyle = UITextBorderStyleRoundedRect;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.font = [UIFont systemFontOfSize:16];
    emailField.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:emailField];
    
    // 备注输入
    UITextView *noteTextView = [[UITextView alloc] init];
    noteTextView.font = [UIFont systemFontOfSize:16];
    noteTextView.layer.borderColor = [[UIColor systemGray4Color] CGColor];
    noteTextView.layer.borderWidth = 1;
    noteTextView.layer.cornerRadius = 8;
    noteTextView.text = @"请输入备注信息...";
    noteTextView.textColor = [UIColor placeholderTextColor];
    noteTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:noteTextView];
    
    // 提交和关闭按钮
    UIStackView *buttonStack = [[UIStackView alloc] init];
    buttonStack.axis = UILayoutConstraintAxisHorizontal;
    buttonStack.spacing = 12;
    buttonStack.distribution = UIStackViewDistributionFillEqually;
    buttonStack.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:buttonStack];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    submitButton.backgroundColor = [UIColor systemRedColor];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.layer.cornerRadius = 8;
    [buttonStack addArrangedSubview:submitButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor systemGrayColor];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 8;
    [buttonStack addArrangedSubview:cancelButton];
    
    [submitButton addTarget:self action:@selector(submitForm:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton addTarget:self action:@selector(closeCurrentPopup:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        // nameField
        [nameField.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:20],
        [nameField.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [nameField.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [nameField.heightAnchor constraintEqualToConstant:44],
        
        // emailField
        [emailField.topAnchor constraintEqualToAnchor:nameField.bottomAnchor constant:16],
        [emailField.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [emailField.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [emailField.heightAnchor constraintEqualToConstant:44],
        
        // noteTextView
        [noteTextView.topAnchor constraintEqualToAnchor:emailField.bottomAnchor constant:16],
        [noteTextView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [noteTextView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [noteTextView.heightAnchor constraintEqualToConstant:80],
        
        // buttonStack
        [buttonStack.topAnchor constraintEqualToAnchor:noteTextView.bottomAnchor constant:20],
        [buttonStack.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [buttonStack.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [buttonStack.bottomAnchor constraintEqualToAnchor:contentView.safeAreaLayoutGuide.bottomAnchor constant:-20],
        [buttonStack.heightAnchor constraintEqualToConstant:50]
    ]];
    
    return contentView;
}

- (UIView *)createNavigationContentView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor systemBackgroundColor];
    
    // 导航栏
    UIView *navBar = [[UIView alloc] init];
    navBar.backgroundColor = [UIColor systemTealColor];
    navBar.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:navBar];
    
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.text = @"设置";
    navTitle.font = [UIFont boldSystemFontOfSize:18];
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [navBar addSubview:navTitle];
    
    UIButton *navCloseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [navCloseButton setTitle:@"关闭" forState:UIControlStateNormal];
    [navCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navCloseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [navBar addSubview:navCloseButton];
    
    [navCloseButton addTarget:self action:@selector(closeCurrentPopup:) forControlEvents:UIControlEventTouchUpInside];
    
    // 内容区域
    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.axis = UILayoutConstraintAxisVertical;
    contentStack.spacing = 0;
    contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:contentStack];
    
    // 添加设置项
    NSArray *settingItems = @[@"🔔 通知设置", @"🎨 主题设置", @"🔐 隐私设置", @"📱 关于应用", @"📞 联系我们"];
    
    for (NSString *item in settingItems) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = [UIColor systemBackgroundColor];
        
        UILabel *itemLabel = [[UILabel alloc] init];
        itemLabel.text = item;
        itemLabel.font = [UIFont systemFontOfSize:16];
        itemLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [itemView addSubview:itemLabel];
        
        UILabel *chevronLabel = [[UILabel alloc] init];
        chevronLabel.text = @">";
        chevronLabel.font = [UIFont systemFontOfSize:14];
        chevronLabel.textColor = [UIColor systemGrayColor];
        chevronLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [itemView addSubview:chevronLabel];
        
        // 分割线
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = [[UIColor systemGray4Color] colorWithAlphaComponent:0.5];
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        [itemView addSubview:separator];
        
        [NSLayoutConstraint activateConstraints:@[
            [itemView.heightAnchor constraintEqualToConstant:54],
            [itemLabel.leadingAnchor constraintEqualToAnchor:itemView.leadingAnchor constant:20],
            [itemLabel.centerYAnchor constraintEqualToAnchor:itemView.centerYAnchor],
            [chevronLabel.trailingAnchor constraintEqualToAnchor:itemView.trailingAnchor constant:-20],
            [chevronLabel.centerYAnchor constraintEqualToAnchor:itemView.centerYAnchor],
            [separator.leadingAnchor constraintEqualToAnchor:itemView.leadingAnchor constant:20],
            [separator.trailingAnchor constraintEqualToAnchor:itemView.trailingAnchor],
            [separator.bottomAnchor constraintEqualToAnchor:itemView.bottomAnchor],
            [separator.heightAnchor constraintEqualToConstant:0.5]
        ]];
        
        [contentStack addArrangedSubview:itemView];
    }
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // navBar
        [navBar.topAnchor constraintEqualToAnchor:contentView.topAnchor],
        [navBar.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
        [navBar.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
        [navBar.heightAnchor constraintEqualToConstant:56],
        
        // navTitle
        [navTitle.centerXAnchor constraintEqualToAnchor:navBar.centerXAnchor],
        [navTitle.centerYAnchor constraintEqualToAnchor:navBar.centerYAnchor],
        
        // navCloseButton
        [navCloseButton.trailingAnchor constraintEqualToAnchor:navBar.trailingAnchor constant:-16],
        [navCloseButton.centerYAnchor constraintEqualToAnchor:navBar.centerYAnchor],
        
        // contentStack
        [contentStack.topAnchor constraintEqualToAnchor:navBar.bottomAnchor],
        [contentStack.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
        [contentStack.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
        [contentStack.bottomAnchor constraintEqualToAnchor:contentView.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    return contentView;
}

#pragma mark - Button Actions

- (void)closeCurrentPopup:(UIButton *)sender {
    UIView *contentView = sender.superview;
    while (contentView && ![contentView isKindOfClass:[TFYPopupView class]]) {
        contentView = contentView.superview;
    }
    
    if ([contentView isKindOfClass:[TFYPopupView class]]) {
        [(TFYPopupView *)contentView dismissAnimated:YES completion:nil];
    }
}

- (void)submitForm:(UIButton *)sender {
    // 显示提交成功提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功"
                                                                   message:@"表单提交成功！"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self closeCurrentPopup:sender];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BottomSheetDemoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    TFYBottomSheetDemoModel *model = self.demoModels[indexPath.row];
    
    // 清除旧的子视图
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 图标
    UILabel *iconLabel = [[UILabel alloc] init];
    iconLabel.text = model.icon;
    iconLabel.font = [UIFont systemFontOfSize:30];
    iconLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:iconLabel];
    
    // 标题和描述
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = model.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = model.backgroundColor;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = model.detailDescription;
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textColor = [UIColor secondaryLabelColor];
    descLabel.numberOfLines = 2;
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:descLabel];
    
    // 箭头
    UILabel *arrowLabel = [[UILabel alloc] init];
    arrowLabel.text = @"▶";
    arrowLabel.font = [UIFont systemFontOfSize:12];
    arrowLabel.textColor = model.backgroundColor;
    arrowLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:arrowLabel];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // iconLabel
        [iconLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:16],
        [iconLabel.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
        [iconLabel.widthAnchor constraintEqualToConstant:40],
        
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:8],
        [titleLabel.leadingAnchor constraintEqualToAnchor:iconLabel.trailingAnchor constant:12],
        [titleLabel.trailingAnchor constraintEqualToAnchor:arrowLabel.leadingAnchor constant:-8],
        
        // descLabel
        [descLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:4],
        [descLabel.leadingAnchor constraintEqualToAnchor:iconLabel.trailingAnchor constant:12],
        [descLabel.trailingAnchor constraintEqualToAnchor:arrowLabel.leadingAnchor constant:-8],
        [descLabel.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:-8],
        
        // arrowLabel
        [arrowLabel.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-16],
        [arrowLabel.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor]
    ]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TFYBottomSheetDemoModel *model = self.demoModels[indexPath.row];
    [self showDemoWithModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor systemBackgroundColor];
        
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

@end
