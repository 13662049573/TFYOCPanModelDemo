//
//  TFYPopupContainerSizeViewController.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗容器大小自定义演示控制器实现
//

#import "TFYPopupContainerSizeViewController.h"
#import "TFYPopup.h"
#import <Masonry/Masonry.h>
#import "UIColor+TFY.h"

/// 容器尺寸演示类型
typedef NS_ENUM(NSInteger, TFYContainerSizeDemoType) {
    TFYContainerSizeDemoTypeFixedSmall = 0,      // 固定小尺寸
    TFYContainerSizeDemoTypeFixedMedium,         // 固定中等尺寸
    TFYContainerSizeDemoTypeFixedLarge,          // 固定大尺寸
    TFYContainerSizeDemoTypeAutomatic,           // 自动尺寸
    TFYContainerSizeDemoTypeRatioQuarter,        // 1/4屏幕比例
    TFYContainerSizeDemoTypeRatioHalf,           // 1/2屏幕比例
    TFYContainerSizeDemoTypeRatioThreeQuarter,   // 3/4屏幕比例
    TFYContainerSizeDemoTypeCustomContent,       // 自定义内容适配
    TFYContainerSizeDemoTypeWithConstraints,     // 带约束限制
    TFYContainerSizeDemoTypeWithPadding,         // 自定义内边距
    TFYContainerSizeDemoTypeResponsive,          // 响应式尺寸
    TFYContainerSizeDemoTypeFullScreen           // 全屏模式
};

/// 演示项目模型
@interface TFYContainerSizeDemoModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) TFYContainerSizeDemoType type;
@property (nonatomic, copy) void (^actionBlock)(UIViewController *controller);

+ (instancetype)modelWithTitle:(NSString *)title 
                      subtitle:(NSString *)subtitle 
                          type:(TFYContainerSizeDemoType)type 
                   actionBlock:(void (^)(UIViewController *controller))actionBlock;

@end

@implementation TFYContainerSizeDemoModel

+ (instancetype)modelWithTitle:(NSString *)title 
                      subtitle:(NSString *)subtitle 
                          type:(TFYContainerSizeDemoType)type 
                   actionBlock:(void (^)(UIViewController *controller))actionBlock {
    TFYContainerSizeDemoModel *model = [[TFYContainerSizeDemoModel alloc] init];
    model.title = title;
    model.subtitle = subtitle;
    model.type = type;
    model.actionBlock = actionBlock;
    return model;
}

@end

@interface TFYPopupContainerSizeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<TFYContainerSizeDemoModel *> *demoModels;

@end

@implementation TFYPopupContainerSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupDemoModels];
}

- (void)setupUI {
    self.title = @"容器大小演示";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    // 添加说明按钮
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"说明"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(showInfoPopup)];
    self.navigationItem.rightBarButtonItem = infoButton;
}

- (void)setupDemoModels {
    NSMutableArray *models = [NSMutableArray array];
    
    // 固定尺寸演示
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"固定小尺寸 (200x150)" 
                                                       subtitle:@"使用固定宽高值创建小型弹窗"
                                                           type:TFYContainerSizeDemoTypeFixedSmall
                                                    actionBlock:^(UIViewController *controller) {
        [self showFixedSizePopupWithWidth:200 height:150];
    }]];
    
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"固定中等尺寸 (300x250)" 
                                                       subtitle:@"使用固定宽高值创建中等弹窗"
                                                           type:TFYContainerSizeDemoTypeFixedMedium
                                                    actionBlock:^(UIViewController *controller) {
        [self showFixedSizePopupWithWidth:300 height:250];
    }]];
    
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"固定大尺寸 (350x400)" 
                                                       subtitle:@"使用固定宽高值创建大型弹窗"
                                                           type:TFYContainerSizeDemoTypeFixedLarge
                                                    actionBlock:^(UIViewController *controller) {
        [self showFixedSizePopupWithWidth:350 height:400];
    }]];
    
    // 自动尺寸演示
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"自动尺寸适配" 
                                                       subtitle:@"根据内容自动调整弹窗大小"
                                                           type:TFYContainerSizeDemoTypeAutomatic
                                                    actionBlock:^(UIViewController *controller) {
        [self showAutomaticSizePopup];
    }]];
    
    // 比例尺寸演示
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"25%屏幕比例" 
                                                       subtitle:@"弹窗占屏幕1/4大小"
                                                           type:TFYContainerSizeDemoTypeRatioQuarter
                                                    actionBlock:^(UIViewController *controller) {
        [self showRatioSizePopupWithRatio:0.25];
    }]];
    
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"50%屏幕比例" 
                                                       subtitle:@"弹窗占屏幕1/2大小"
                                                           type:TFYContainerSizeDemoTypeRatioHalf
                                                    actionBlock:^(UIViewController *controller) {
        [self showRatioSizePopupWithRatio:0.5];
    }]];
    
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"75%屏幕比例" 
                                                       subtitle:@"弹窗占屏幕3/4大小"
                                                           type:TFYContainerSizeDemoTypeRatioThreeQuarter
                                                    actionBlock:^(UIViewController *controller) {
        [self showRatioSizePopupWithRatio:0.75];
    }]];
    
    // 自定义内容适配
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"自定义内容适配" 
                                                       subtitle:@"使用回调函数动态计算尺寸"
                                                           type:TFYContainerSizeDemoTypeCustomContent
                                                    actionBlock:^(UIViewController *controller) {
        [self showCustomContentSizePopup];
    }]];
    
    // 带约束限制
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"约束限制演示" 
                                                       subtitle:@"设置最大最小尺寸限制"
                                                           type:TFYContainerSizeDemoTypeWithConstraints
                                                    actionBlock:^(UIViewController *controller) {
        [self showConstrainedSizePopup];
    }]];
    
    // 自定义内边距
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"自定义内边距" 
                                                       subtitle:@"设置不同的内容边距"
                                                           type:TFYContainerSizeDemoTypeWithPadding
                                                    actionBlock:^(UIViewController *controller) {
        [self showCustomPaddingPopup];
    }]];
    
    // 响应式尺寸
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"响应式尺寸" 
                                                       subtitle:@"根据设备方向和屏幕尺寸自适应"
                                                           type:TFYContainerSizeDemoTypeResponsive
                                                    actionBlock:^(UIViewController *controller) {
        [self showResponsiveSizePopup];
    }]];
    
    // 全屏模式
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"全屏模式" 
                                                       subtitle:@"占满整个屏幕的弹窗"
                                                           type:TFYContainerSizeDemoTypeFullScreen
                                                    actionBlock:^(UIViewController *controller) {
        [self showFullScreenPopup];
    }]];
    
    self.demoModels = [models copy];
}

#pragma mark - Demo Methods

- (void)showFixedSizePopupWithWidth:(CGFloat)width height:(CGFloat)height {
    UIView *contentView = [self createDemoContentViewWithText:[NSString stringWithFormat:@"固定尺寸\n%.0f x %.0f", width, height]
                                                        color:[UIColor tfy_randomColor]];
    
    // 创建容器配置
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension fixed:width];
    containerConfig.height = [TFYPopupContainerDimension fixed:height];
    containerConfig.cornerRadius = 12;
    containerConfig.shadowEnabled = YES;
    
    // 创建弹窗配置
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupZoomInOutAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showAutomaticSizePopup {
    UIView *contentView = [self createDemoContentViewWithText:@"自动尺寸\n\n这个弹窗会根据内容自动调整大小。\n无论内容多少，都能完美适配。\n\n很方便对吧？"
                                                        color:[UIColor systemBlueColor]];
    
    // 创建容器配置 - 使用自动尺寸
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension automatic];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    containerConfig.maxWidth = 320;  // 设置最大宽度
    containerConfig.hasMaxWidth = YES;
    containerConfig.cornerRadius = 16;
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showRatioSizePopupWithRatio:(CGFloat)ratio {
    UIView *contentView = [self createDemoContentViewWithText:[NSString stringWithFormat:@"比例尺寸\n%.0f%% 屏幕", ratio * 100]
                                                        color:[UIColor systemGreenColor]];
    
    // 创建容器配置 - 使用比例尺寸
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension ratio:ratio];
    containerConfig.height = [TFYPopupContainerDimension ratio:ratio];
    containerConfig.cornerRadius = 20;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowOpacity = 0.2;
    containerConfig.shadowRadius = 8;
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupBounceAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showCustomContentSizePopup {
    UIView *contentView = [self createComplexDemoContentView];
    
    // 创建容器配置 - 使用自定义尺寸计算
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    
    // 宽度：根据内容动态计算
    containerConfig.width = [TFYPopupContainerDimension customWithHandler:^CGFloat(UIView *contentView) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        return MIN(screenWidth * 0.9, 400); // 最大不超过屏幕90%或400px
    }];
    
    // 高度：根据内容高度计算
    containerConfig.height = [TFYPopupContainerDimension customWithHandler:^CGFloat(UIView *contentView) {
        CGSize intrinsicSize = contentView.intrinsicContentSize;
        CGFloat minHeight = 200;
        CGFloat maxHeight = [UIScreen mainScreen].bounds.size.height * 0.8;
        return MAX(minHeight, MIN(intrinsicSize.height + 40, maxHeight));
    }];
    
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupFadeInOutAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showConstrainedSizePopup {
    UIView *contentView = [self createDemoContentViewWithText:@"约束限制演示\n\n这个弹窗设置了最小和最大尺寸限制。\n即使内容很少也会保持最小尺寸，\n内容很多时也不会超过最大尺寸。"
                                                        color:[UIColor systemOrangeColor]];
    
    // 创建容器配置 - 设置约束限制
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension automatic];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    
    // 设置尺寸限制
    containerConfig.minWidth = 250;
    containerConfig.hasMinWidth = YES;
    containerConfig.maxWidth = 350;
    containerConfig.hasMaxWidth = YES;
    containerConfig.minHeight = 180;
    containerConfig.hasMinHeight = YES;
    containerConfig.maxHeight = 400;
    containerConfig.hasMaxHeight = YES;
    
    containerConfig.cornerRadius = 12;
    containerConfig.shadowEnabled = YES;
    containerConfig.contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromTop]
                         animated:YES
                       completion:nil];
}

- (void)showCustomPaddingPopup {
    UIView *contentView = [self createDemoContentViewWithText:@"自定义内边距\n\n这个弹窗使用了\n不对称的内边距设计"
                                                        color:[UIColor systemPurpleColor]];
    
    // 创建容器配置 - 自定义内边距
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension fixed:280];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    
    // 设置不对称内边距：上30，左40，下20，右15
    containerConfig.contentInsets = UIEdgeInsetsMake(30, 40, 20, 15);
    containerConfig.cornerRadius = 20;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor systemPurpleColor];
    containerConfig.shadowOpacity = 0.3;
    containerConfig.shadowRadius = 10;
    containerConfig.shadowOffset = CGSizeMake(0, 5);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopup3DFlipAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showResponsiveSizePopup {
    UIView *contentView = [self createDemoContentViewWithText:@"响应式尺寸\n\n会根据设备屏幕尺寸\n和方向自动调整大小"
                                                        color:[UIColor systemTealColor]];
    
    // 创建容器配置 - 响应式设计
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    
    // 响应式宽度：小屏幕用更大比例，大屏幕用固定尺寸
    containerConfig.width = [TFYPopupContainerDimension customWithHandler:^CGFloat(UIView *contentView) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        if (screenWidth < 375) {
            // iPhone SE等小屏设备
            return screenWidth * 0.9;
        } else if (screenWidth > 414) {
            // iPad等大屏设备
            return 380;
        } else {
            // 标准iPhone尺寸
            return screenWidth * 0.8;
        }
    }];
    
    // 响应式高度：根据屏幕高度比例
    containerConfig.height = [TFYPopupContainerDimension customWithHandler:^CGFloat(UIView *contentView) {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        return screenHeight * 0.4; // 占屏幕高度的40%
    }];
    
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupRotateAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showFullScreenPopup {
    UIView *contentView = [self createFullScreenDemoContentView];
    
    // 创建容器配置 - 全屏模式
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension ratio:1.0];  // 100%宽度
    containerConfig.height = [TFYPopupContainerDimension ratio:1.0]; // 100%高度
    containerConfig.cornerRadius = 0; // 全屏不需要圆角
    containerConfig.contentInsets = UIEdgeInsetsZero; // 无内边距
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.backgroundColor = [UIColor clearColor]; // 透明背景
    config.dismissOnBackgroundTap = NO; // 全屏模式不允许点击背景消失
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromBottom]
                         animated:YES
                       completion:nil];
}

- (void)showInfoPopup {
    UIView *infoView = [self createInfoContentView];
    
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension fixed:320];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    containerConfig.maxHeight = 500;
    containerConfig.hasMaxHeight = YES;
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:infoView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

#pragma mark - Content View Creation

- (UIView *)createDemoContentViewWithText:(NSString *)text color:(UIColor *)color {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = color;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [containerView addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor],
        [label.leadingAnchor constraintGreaterThanOrEqualToAnchor:containerView.leadingAnchor constant:10],
        [label.trailingAnchor constraintLessThanOrEqualToAnchor:containerView.trailingAnchor constant:-10],
        [label.topAnchor constraintGreaterThanOrEqualToAnchor:containerView.topAnchor constant:10],
        [label.bottomAnchor constraintLessThanOrEqualToAnchor:containerView.bottomAnchor constant:-10]
    ]];
    
    return containerView;
}

- (UIView *)createComplexDemoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"自定义内容适配";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 描述文本
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"这个弹窗的大小是通过回调函数动态计算的。可以根据内容、屏幕尺寸等因素灵活调整。";
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.numberOfLines = 0;
    descLabel.textColor = [UIColor secondaryLabelColor];
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    closeButton.backgroundColor = [UIColor systemBlueColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton addTarget:self action:@selector(dismissCurrentPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:descLabel];
    [containerView addSubview:closeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [descLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [descLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [descLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [closeButton.topAnchor constraintEqualToAnchor:descLabel.bottomAnchor constant:20],
        [closeButton.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [closeButton.widthAnchor constraintEqualToConstant:100],
        [closeButton.heightAnchor constraintEqualToConstant:44],
        [closeButton.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20]
    ]];
    
    return containerView;
}

- (UIView *)createFullScreenDemoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.95];
    
    // 导航栏区域
    UIView *navBar = [[UIView alloc] init];
    navBar.backgroundColor = [UIColor systemBlueColor];
    navBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.text = @"全屏演示";
    navTitle.font = [UIFont boldSystemFontOfSize:18];
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"✕" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:20];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton addTarget:self action:@selector(dismissCurrentPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:navTitle];
    [navBar addSubview:closeButton];
    
    // 内容区域
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"这是一个全屏弹窗演示\n\n占据了整个屏幕空间\n可以用来展示详细内容\n或者作为独立的功能页面\n\n点击右上角×号关闭";
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:18];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [containerView addSubview:navBar];
    [containerView addSubview:contentLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        // 导航栏
        [navBar.topAnchor constraintEqualToAnchor:containerView.safeAreaLayoutGuide.topAnchor],
        [navBar.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
        [navBar.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
        [navBar.heightAnchor constraintEqualToConstant:44],
        
        // 导航栏标题
        [navTitle.centerXAnchor constraintEqualToAnchor:navBar.centerXAnchor],
        [navTitle.centerYAnchor constraintEqualToAnchor:navBar.centerYAnchor],
        
        // 关闭按钮
        [closeButton.trailingAnchor constraintEqualToAnchor:navBar.trailingAnchor constant:-16],
        [closeButton.centerYAnchor constraintEqualToAnchor:navBar.centerYAnchor],
        [closeButton.widthAnchor constraintEqualToConstant:30],
        [closeButton.heightAnchor constraintEqualToConstant:30],
        
        // 内容标签
        [contentLabel.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [contentLabel.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor],
        [contentLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:containerView.leadingAnchor constant:30],
        [contentLabel.trailingAnchor constraintLessThanOrEqualToAnchor:containerView.trailingAnchor constant:-30]
    ]];
    
    return containerView;
}

- (UIView *)createInfoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"容器大小配置说明";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"TFYPopupContainerConfiguration 支持多种尺寸配置方式：\n\n• 固定尺寸：指定具体的像素值\n• 自动尺寸：根据内容自动调整\n• 比例尺寸：相对于屏幕的百分比\n• 自定义尺寸：使用回调函数动态计算\n\n还可以设置最大最小值限制、内边距、圆角、阴影等属性。";
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.numberOfLines = 0;
    infoLabel.textColor = [UIColor labelColor];
    infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:infoLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [infoLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [infoLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [infoLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        [infoLabel.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20]
    ]];
    
    return containerView;
}

- (void)dismissCurrentPopup {
    // 获取当前所有弹窗并关闭最新的一个
    NSArray *currentPopups = [TFYPopupView allCurrentPopups];
    if (currentPopups.count > 0) {
        TFYPopupView *lastPopup = [currentPopups lastObject];
        [lastPopup dismissAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ContainerSizeDemoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    TFYContainerSizeDemoModel *model = self.demoModels[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subtitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 根据类型设置颜色
    switch (model.type) {
        case TFYContainerSizeDemoTypeFixedSmall:
        case TFYContainerSizeDemoTypeFixedMedium:
        case TFYContainerSizeDemoTypeFixedLarge:
            cell.textLabel.textColor = [UIColor systemRedColor];
            break;
        case TFYContainerSizeDemoTypeAutomatic:
            cell.textLabel.textColor = [UIColor systemBlueColor];
            break;
        case TFYContainerSizeDemoTypeRatioQuarter:
        case TFYContainerSizeDemoTypeRatioHalf:
        case TFYContainerSizeDemoTypeRatioThreeQuarter:
            cell.textLabel.textColor = [UIColor systemGreenColor];
            break;
        case TFYContainerSizeDemoTypeCustomContent:
        case TFYContainerSizeDemoTypeResponsive:
            cell.textLabel.textColor = [UIColor systemOrangeColor];
            break;
        case TFYContainerSizeDemoTypeWithConstraints:
        case TFYContainerSizeDemoTypeWithPadding:
            cell.textLabel.textColor = [UIColor systemPurpleColor];
            break;
        case TFYContainerSizeDemoTypeFullScreen:
            cell.textLabel.textColor = [UIColor systemTealColor];
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TFYContainerSizeDemoModel *model = self.demoModels[indexPath.row];
    if (model.actionBlock) {
        model.actionBlock(self);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
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
