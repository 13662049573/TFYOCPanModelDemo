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
    TFYContainerSizeDemoTypeFullScreen,          // 全屏模式
    TFYContainerSizeDemoTypeComplexAutomatic,    // 复杂自动尺寸
    TFYContainerSizeDemoTypeMarginConfig,        // 边距配置演示
    TFYContainerSizeDemoTypeDynamicContent,      // 动态内容弹窗
    TFYContainerSizeDemoTypeFormPopup,           // 表单弹窗
    TFYContainerSizeDemoTypeImagePopup,          // 图片弹窗
    TFYContainerSizeDemoTypeListPopup,           // 列表弹窗
    TFYContainerSizeDemoTypeCardStyle,           // 卡片样式弹窗
    TFYContainerSizeDemoTypeAdaptiveLayout       // 自适应布局弹窗
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
    
    // 复杂自动尺寸演示
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"复杂自动尺寸" 
                                                       subtitle:@"测试复杂内容的自动尺寸适配"
                                                           type:TFYContainerSizeDemoTypeComplexAutomatic
                                                    actionBlock:^(UIViewController *controller) {
        [self showComplexAutomaticSizePopup];
    }]];
    
    // 边距配置演示
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"边距配置演示" 
                                                       subtitle:@"展示screenInsets和contentInsets的区别"
                                                           type:TFYContainerSizeDemoTypeMarginConfig
                                                    actionBlock:^(UIViewController *controller) {
        [self showMarginConfigDemoPopup];
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
    
    // 动态内容弹窗
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"动态内容弹窗" 
                                                       subtitle:@"内容会根据用户操作动态变化"
                                                           type:TFYContainerSizeDemoTypeDynamicContent
                                                    actionBlock:^(UIViewController *controller) {
        [self showDynamicContentPopup];
    }]];
    
    // 表单弹窗
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"表单弹窗" 
                                                       subtitle:@"包含输入框和按钮的表单弹窗"
                                                           type:TFYContainerSizeDemoTypeFormPopup
                                                    actionBlock:^(UIViewController *controller) {
        [self showFormPopup];
    }]];
    
    // 图片弹窗
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"图片弹窗" 
                                                       subtitle:@"展示图片内容的弹窗"
                                                           type:TFYContainerSizeDemoTypeImagePopup
                                                    actionBlock:^(UIViewController *controller) {
        [self showImagePopup];
    }]];
    
    // 列表弹窗
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"列表弹窗" 
                                                       subtitle:@"包含列表内容的弹窗"
                                                           type:TFYContainerSizeDemoTypeListPopup
                                                    actionBlock:^(UIViewController *controller) {
        [self showListPopup];
    }]];
    
    // 卡片样式弹窗
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"卡片样式弹窗" 
                                                       subtitle:@"现代化的卡片设计风格"
                                                           type:TFYContainerSizeDemoTypeCardStyle
                                                    actionBlock:^(UIViewController *controller) {
        [self showCardStylePopup];
    }]];
    
    // 自适应布局弹窗
    [models addObject:[TFYContainerSizeDemoModel modelWithTitle:@"自适应布局弹窗" 
                                                       subtitle:@"根据设备方向自动调整布局"
                                                           type:TFYContainerSizeDemoTypeAdaptiveLayout
                                                    actionBlock:^(UIViewController *controller) {
        [self showAdaptiveLayoutPopup];
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
    // 设置更明显的阴影效果
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    
    // 创建弹窗配置
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentViewWithContainerSelection:contentView
                    configuration:config
                         animator:[[TFYPopupZoomInOutAnimator alloc] init]
                         animated:YES
                                             completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)showAutomaticSizePopup {
    UIView *contentView = [self createDemoContentViewWithText:@"自动尺寸\n\n这个弹窗会根据内容自动调整大小。\n无论内容多少，都能完美适配。\n\n很方便对吧？\n\n现在添加更多内容来测试自动尺寸功能：\n• 支持多行文本\n• 支持动态内容\n• 支持不同字体大小\n• 支持富文本内容\n\n这样就能看到真正的自动适配效果了！"
                                                        color:[UIColor systemBlueColor]];
    
    // 创建容器配置 - 使用自动尺寸
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension automatic];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    containerConfig.maxWidth = 320;  // 设置最大宽度
    containerConfig.hasMaxWidth = YES;
    containerConfig.minWidth = 200;  // 设置最小宽度
    containerConfig.hasMinWidth = YES;
    containerConfig.minHeight = 150; // 设置最小高度
    containerConfig.hasMinHeight = YES;
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentViewWithContainerSelection:contentView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                                             completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)showComplexAutomaticSizePopup {
    UIView *contentView = [self createComplexDemoContentView];
    
    // 创建容器配置 - 使用自定义尺寸计算
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    
    // 宽度：根据内容动态计算
    containerConfig.width = [TFYPopupContainerDimension customWithHandler:^CGFloat(UIView *contentView) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat calculatedWidth = MIN(screenWidth * 0.9, 400);
        NSLog(@"复杂自动尺寸 Debug: 计算宽度: %.2f (屏幕宽度: %.2f)", calculatedWidth, screenWidth);
        return calculatedWidth;
    }];
    
    // 高度：根据内容高度计算
    containerConfig.height = [TFYPopupContainerDimension customWithHandler:^CGFloat(UIView *contentView) {
        // 由于intrinsicContentSize在此时可能不准确，我们使用sizeThatFits来计算
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat maxWidth = MIN(screenWidth * 0.9, 400);
        
        // 强制布局以获取正确的尺寸
        [contentView setNeedsLayout];
        [contentView layoutIfNeeded];
        
        // 使用sizeThatFits计算合适的高度
        CGSize fitsSize = [contentView sizeThatFits:CGSizeMake(maxWidth - 40, CGFLOAT_MAX)]; // 减去内边距
        
        CGFloat minHeight = 200;
        CGFloat maxHeight = [UIScreen mainScreen].bounds.size.height * 0.8;
        
        NSLog(@"复杂自动尺寸 Debug: sizeThatFits计算结果: %@", NSStringFromCGSize(fitsSize));
        NSLog(@"复杂自动尺寸 Debug: 可用高度范围: %.2f - %.2f", minHeight, maxHeight);
        
        CGFloat finalHeight = MAX(minHeight, MIN(fitsSize.height + 80, maxHeight)); // 添加额外的边距
        NSLog(@"复杂自动尺寸 Debug: 最终高度: %.2f", finalHeight);
        
        return finalHeight;
    }];
    
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    NSLog(@"复杂自动尺寸 Debug: 开始显示弹窗");
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupFadeInOutAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)showMarginConfigDemoPopup {
    UIView *contentView = [self createMarginConfigDemoContentView];
    
    // 创建容器配置 - 演示不同的边距配置
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    
    // 使用自动尺寸
    containerConfig.width = [TFYPopupContainerDimension automatic];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    
    // 设置屏幕边距：弹窗距离屏幕边缘的距离
    containerConfig.screenInsets = UIEdgeInsetsMake(40, 40, 40, 40); // 弹窗距离屏幕边缘40px
    
    // 设置内容边距：内容距离弹窗边缘的距离
    containerConfig.contentInsets = UIEdgeInsetsMake(30, 30, 30, 30); // 内容距离弹窗边缘30px
    
    // 设置尺寸限制
    containerConfig.maxWidth = 350;
    containerConfig.hasMaxWidth = YES;
    containerConfig.minWidth = 250;
    containerConfig.hasMinWidth = YES;
    containerConfig.minHeight = 180;
    containerConfig.hasMinHeight = YES;
    
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor systemBrownColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
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
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupBounceAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)showCustomContentSizePopup {
    UIView *contentView = [self createComplexDemoContentView];
    
    // 创建容器配置 - 使用自定义尺寸计算
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    
    // 宽度：根据内容动态计算
    containerConfig.width = [TFYPopupContainerDimension customWithHandler:^CGFloat(UIView *contentView) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat calculatedWidth = MIN(screenWidth * 0.9, 400);
        NSLog(@"自定义内容适配 Debug: 计算宽度: %.2f (屏幕宽度: %.2f)", calculatedWidth, screenWidth);
        return calculatedWidth;
    }];
    
    // 高度：根据内容高度计算
    containerConfig.height = [TFYPopupContainerDimension customWithHandler:^CGFloat(UIView *contentView) {
        // 由于intrinsicContentSize在此时可能不准确，我们使用sizeThatFits来计算
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat maxWidth = MIN(screenWidth * 0.9, 400);
        
        // 强制布局以获取正确的尺寸
        [contentView setNeedsLayout];
        [contentView layoutIfNeeded];
        
        // 使用sizeThatFits计算合适的高度
        CGSize fitsSize = [contentView sizeThatFits:CGSizeMake(maxWidth - 40, CGFLOAT_MAX)]; // 减去内边距
        
        CGFloat minHeight = 200;
        CGFloat maxHeight = [UIScreen mainScreen].bounds.size.height * 0.8;
        
        NSLog(@"自定义内容适配 Debug: sizeThatFits计算结果: %@", NSStringFromCGSize(fitsSize));
        NSLog(@"自定义内容适配 Debug: 可用高度范围: %.2f - %.2f", minHeight, maxHeight);
        
        CGFloat finalHeight = MAX(minHeight, MIN(fitsSize.height + 80, maxHeight)); // 添加额外的边距
        NSLog(@"自定义内容适配 Debug: 最终高度: %.2f", finalHeight);
        
        return finalHeight;
    }];
    
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    NSLog(@"自定义内容适配 Debug: 开始显示弹窗");
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupFadeInOutAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
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
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromTop]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
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
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
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
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
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
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)showDynamicContentPopup {
    UIView *contentView = [self createDynamicContentDemoContentView];
    
    // 创建容器配置 - 动态内容
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension fixed:UIScreen.mainScreen.bounds.size.width - 40];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)showFormPopup {
    UIView *contentView = [self createFormDemoContentView];
    
    // 创建容器配置 - 表单弹窗
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension automatic];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)showImagePopup {
    UIView *contentView = [self createImagePopupDemoContentView];
    
    // 创建容器配置 - 图片弹窗
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension automatic];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)showListPopup {
    UIView *contentView = [self createListPopupDemoContentView];
    
    // 创建容器配置 - 列表弹窗
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension automatic];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)showCardStylePopup {
    UIView *contentView = [self createCardStyleDemoContentView];
    
    // 创建容器配置 - 卡片样式
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension automatic];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (void)showAdaptiveLayoutPopup {
    UIView *contentView = [self createAdaptiveLayoutDemoContentView];
    
    // 创建容器配置 - 自适应布局
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension automatic];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
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
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:infoView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
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
    
    // 设置preferredMaxLayoutWidth以帮助自动布局
    label.preferredMaxLayoutWidth = 280;
    
    [containerView addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [label.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [label.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20],
        [label.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [label.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20]
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
    
    // 描述文本 - 简化文本内容，避免过长
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"这个弹窗的大小是通过回调函数动态计算的。\n\n它使用sizeThatFits方法来准确计算内容的高度，确保所有文本都能正确显示。\n\n这种方式比intrinsicContentSize更加可靠，能够处理复杂的布局场景。\n\n支持多行文本、动态内容、不同字体大小等特性。";
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.numberOfLines = 0;
    descLabel.textColor = [UIColor secondaryLabelColor];
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 设置preferredMaxLayoutWidth以帮助sizeThatFits计算
    descLabel.preferredMaxLayoutWidth = 320; // 预设最大宽度
    
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

- (UIView *)createDynamicContentDemoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"动态内容弹窗";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"这是一个动态内容弹窗，内容会根据用户操作变化。\n\n点击按钮来改变内容！";
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor labelColor];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [changeButton setTitle:@"改变内容" forState:UIControlStateNormal];
    changeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    changeButton.backgroundColor = [UIColor systemBlueColor];
    [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeButton.layer.cornerRadius = 8;
    changeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [changeButton addTarget:self action:@selector(changeDynamicContent) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:contentLabel];
    [containerView addSubview:changeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [contentLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [contentLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [contentLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [changeButton.topAnchor constraintEqualToAnchor:contentLabel.bottomAnchor constant:20],
        [changeButton.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [changeButton.widthAnchor constraintEqualToConstant:150],
        [changeButton.heightAnchor constraintEqualToConstant:44],
        [changeButton.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20]
    ]];
    
    return containerView;
}

- (UIView *)createFormDemoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"表单弹窗";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"姓名:";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor labelColor];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITextField *nameTextField = [[UITextField alloc] init];
    nameTextField.placeholder = @"请输入姓名";
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *emailLabel = [[UILabel alloc] init];
    emailLabel.text = @"邮箱:";
    emailLabel.font = [UIFont systemFontOfSize:16];
    emailLabel.textColor = [UIColor labelColor];
    emailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITextField *emailTextField = [[UITextField alloc] init];
    emailTextField.placeholder = @"请输入邮箱";
    emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    submitButton.backgroundColor = [UIColor systemBlueColor];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.layer.cornerRadius = 8;
    submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [submitButton addTarget:self action:@selector(dismissCurrentPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:nameLabel];
    [containerView addSubview:nameTextField];
    [containerView addSubview:emailLabel];
    [containerView addSubview:emailTextField];
    [containerView addSubview:submitButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [nameLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:20],
        [nameLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [nameLabel.widthAnchor constraintEqualToConstant:50],
        
        [nameTextField.topAnchor constraintEqualToAnchor:nameLabel.topAnchor],
        [nameTextField.leadingAnchor constraintEqualToAnchor:nameLabel.trailingAnchor constant:10],
        [nameTextField.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        [nameTextField.heightAnchor constraintEqualToConstant:40],
        
        [emailLabel.topAnchor constraintEqualToAnchor:nameLabel.bottomAnchor constant:10],
        [emailLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [emailLabel.widthAnchor constraintEqualToConstant:50],
        
        [emailTextField.topAnchor constraintEqualToAnchor:emailLabel.topAnchor],
        [emailTextField.leadingAnchor constraintEqualToAnchor:emailLabel.trailingAnchor constant:10],
        [emailTextField.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        [emailTextField.heightAnchor constraintEqualToConstant:40],
        
        [submitButton.topAnchor constraintEqualToAnchor:emailLabel.bottomAnchor constant:20],
        [submitButton.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [submitButton.widthAnchor constraintEqualToConstant:150],
        [submitButton.heightAnchor constraintEqualToConstant:44],
        [submitButton.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20]
    ]];
    
    return containerView;
}

- (UIView *)createImagePopupDemoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    // 创建一个简单的图片视图，如果没有demo_image则使用系统图标
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *demoImage = [UIImage imageNamed:@"demo_image"];
    if (demoImage) {
        imageView.image = demoImage;
    } else {
        // 使用系统图标作为替代
        if (@available(iOS 13.0, *)) {
            imageView.image = [UIImage systemImageNamed:@"photo.fill"];
        } else {
            // iOS 13以下使用颜色块
            imageView.backgroundColor = [UIColor systemBlueColor];
            imageView.layer.cornerRadius = 8;
        }
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"图片弹窗";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"这是一个展示图片的弹窗。\n\n弹窗会根据图片内容自动调整大小。";
    descLabel.font = [UIFont systemFontOfSize:16];
    descLabel.numberOfLines = 0;
    descLabel.textColor = [UIColor labelColor];
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    closeButton.backgroundColor = [UIColor systemBlueColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton addTarget:self action:@selector(dismissCurrentPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:imageView];
    [containerView addSubview:titleLabel];
    [containerView addSubview:descLabel];
    [containerView addSubview:closeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [imageView.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [imageView.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [imageView.widthAnchor constraintEqualToConstant:200],
        [imageView.heightAnchor constraintEqualToConstant:150],
        
        [titleLabel.topAnchor constraintEqualToAnchor:imageView.bottomAnchor constant:16],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [descLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:10],
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

- (UIView *)createListPopupDemoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"列表弹窗";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 创建一个简单的列表视图
    UIView *listContainer = [[UIView alloc] init];
    listContainer.backgroundColor = [UIColor systemGray6Color];
    listContainer.layer.cornerRadius = 8;
    listContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 添加一些示例列表项
    NSArray *listItems = @[@"列表项 1", @"列表项 2", @"列表项 3", @"列表项 4", @"列表项 5"];
    NSMutableArray *itemLabels = [NSMutableArray array];
    
    for (int i = 0; i < listItems.count; i++) {
        UILabel *itemLabel = [[UILabel alloc] init];
        itemLabel.text = listItems[i];
        itemLabel.font = [UIFont systemFontOfSize:16];
        itemLabel.textColor = [UIColor labelColor];
        itemLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [listContainer addSubview:itemLabel];
        [itemLabels addObject:itemLabel];
    }
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    closeButton.backgroundColor = [UIColor systemBlueColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton addTarget:self action:@selector(dismissCurrentPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:listContainer];
    [containerView addSubview:closeButton];
    
    // 设置列表项的约束
    NSMutableArray *itemConstraints = [NSMutableArray array];
    for (int i = 0; i < itemLabels.count; i++) {
        UILabel *itemLabel = itemLabels[i];
        if (i == 0) {
            [itemConstraints addObject:[itemLabel.topAnchor constraintEqualToAnchor:listContainer.topAnchor constant:12]];
        } else {
            UILabel *prevLabel = itemLabels[i-1];
            [itemConstraints addObject:[itemLabel.topAnchor constraintEqualToAnchor:prevLabel.bottomAnchor constant:8]];
        }
        [itemConstraints addObject:[itemLabel.leadingAnchor constraintEqualToAnchor:listContainer.leadingAnchor constant:16]];
        [itemConstraints addObject:[itemLabel.trailingAnchor constraintEqualToAnchor:listContainer.trailingAnchor constant:-16]];
        
        if (i == itemLabels.count - 1) {
            [itemConstraints addObject:[itemLabel.bottomAnchor constraintEqualToAnchor:listContainer.bottomAnchor constant:-12]];
        }
    }
    
    // 激活所有约束
    [NSLayoutConstraint activateConstraints:itemConstraints];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [listContainer.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [listContainer.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [listContainer.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [closeButton.topAnchor constraintEqualToAnchor:listContainer.bottomAnchor constant:20],
        [closeButton.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [closeButton.widthAnchor constraintEqualToConstant:100],
        [closeButton.heightAnchor constraintEqualToConstant:44],
        [closeButton.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20]
    ]];
    
    return containerView;
}

- (UIView *)createCardStyleDemoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    // 添加卡片样式的背景
    UIView *cardBackground = [[UIView alloc] init];
    cardBackground.backgroundColor = [UIColor systemGray6Color];
    cardBackground.layer.cornerRadius = 12;
    cardBackground.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"卡片样式弹窗";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"这是一个现代化的卡片设计风格的弹窗。\n\n具有圆角、阴影、分层等视觉效果。";
    descLabel.font = [UIFont systemFontOfSize:16];
    descLabel.numberOfLines = 0;
    descLabel.textColor = [UIColor labelColor];
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 添加一个图标
    UIImageView *iconView = [[UIImageView alloc] init];
    if (@available(iOS 13.0, *)) {
        iconView.image = [UIImage systemImageNamed:@"star.fill"];
        iconView.tintColor = [UIColor systemYellowColor];
    } else {
        iconView.backgroundColor = [UIColor systemYellowColor];
        iconView.layer.cornerRadius = 8;
    }
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    closeButton.backgroundColor = [UIColor systemBlueColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton addTarget:self action:@selector(dismissCurrentPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:cardBackground];
    [cardBackground addSubview:titleLabel];
    [cardBackground addSubview:iconView];
    [cardBackground addSubview:descLabel];
    [cardBackground addSubview:closeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [cardBackground.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [cardBackground.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [cardBackground.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        [cardBackground.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20],
        
        [titleLabel.topAnchor constraintEqualToAnchor:cardBackground.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:cardBackground.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:cardBackground.trailingAnchor constant:-20],
        
        [iconView.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [iconView.centerXAnchor constraintEqualToAnchor:cardBackground.centerXAnchor],
        [iconView.widthAnchor constraintEqualToConstant:40],
        [iconView.heightAnchor constraintEqualToConstant:40],
        
        [descLabel.topAnchor constraintEqualToAnchor:iconView.bottomAnchor constant:16],
        [descLabel.leadingAnchor constraintEqualToAnchor:cardBackground.leadingAnchor constant:20],
        [descLabel.trailingAnchor constraintEqualToAnchor:cardBackground.trailingAnchor constant:-20],
        
        [closeButton.topAnchor constraintEqualToAnchor:descLabel.bottomAnchor constant:20],
        [closeButton.centerXAnchor constraintEqualToAnchor:cardBackground.centerXAnchor],
        [closeButton.widthAnchor constraintEqualToConstant:100],
        [closeButton.heightAnchor constraintEqualToConstant:44],
        [closeButton.bottomAnchor constraintEqualToAnchor:cardBackground.bottomAnchor constant:-20]
    ]];
    
    return containerView;
}

- (UIView *)createAdaptiveLayoutDemoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"自适应布局弹窗";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 设备方向信息
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    NSString *orientationText = @"未知";
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            orientationText = @"竖屏模式";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientationText = @"倒置竖屏";
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientationText = @"左横屏模式";
            break;
        case UIDeviceOrientationLandscapeRight:
            orientationText = @"右横屏模式";
            break;
        default:
            orientationText = @"未知方向";
            break;
    }
    
    UILabel *orientationLabel = [[UILabel alloc] init];
    orientationLabel.text = [NSString stringWithFormat:@"当前设备方向: %@", orientationText];
    orientationLabel.font = [UIFont systemFontOfSize:16];
    orientationLabel.textColor = [UIColor systemBlueColor];
    orientationLabel.textAlignment = NSTextAlignmentCenter;
    orientationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"这是一个根据设备方向自动调整布局的弹窗。\n\n弹窗会根据屏幕尺寸和方向自动优化布局，确保在不同设备上都有良好的显示效果。";
    descLabel.font = [UIFont systemFontOfSize:16];
    descLabel.numberOfLines = 0;
    descLabel.textColor = [UIColor labelColor];
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    closeButton.backgroundColor = [UIColor systemBlueColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton addTarget:self action:@selector(dismissCurrentPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:orientationLabel];
    [containerView addSubview:descLabel];
    [containerView addSubview:closeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [orientationLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [orientationLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [orientationLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [descLabel.topAnchor constraintEqualToAnchor:orientationLabel.bottomAnchor constant:16],
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

- (UIView *)createMarginConfigDemoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"边距配置演示";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *screenInsetsLabel = [[UILabel alloc] init];
    screenInsetsLabel.text = @"screenInsets: 40px";
    screenInsetsLabel.font = [UIFont systemFontOfSize:14];
    screenInsetsLabel.textColor = [UIColor systemBlueColor];
    screenInsetsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *contentInsetsLabel = [[UILabel alloc] init];
    contentInsetsLabel.text = @"contentInsets: 30px";
    contentInsetsLabel.font = [UIFont systemFontOfSize:14];
    contentInsetsLabel.textColor = [UIColor systemGreenColor];
    contentInsetsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *explanationLabel = [[UILabel alloc] init];
    explanationLabel.text = @"• screenInsets: 控制弹窗与屏幕边缘的距离\n• contentInsets: 控制内容与弹窗边缘的距离\n\n这样设计让您可以精确控制弹窗的布局和视觉效果。";
    explanationLabel.font = [UIFont systemFontOfSize:12];
    explanationLabel.numberOfLines = 0;
    explanationLabel.textColor = [UIColor secondaryLabelColor];
    explanationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:screenInsetsLabel];
    [containerView addSubview:contentInsetsLabel];
    [containerView addSubview:explanationLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [screenInsetsLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [screenInsetsLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [screenInsetsLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [contentInsetsLabel.topAnchor constraintEqualToAnchor:screenInsetsLabel.bottomAnchor constant:8],
        [contentInsetsLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [contentInsetsLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [explanationLabel.topAnchor constraintEqualToAnchor:contentInsetsLabel.bottomAnchor constant:16],
        [explanationLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [explanationLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        [explanationLabel.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20]
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

- (void)changeDynamicContent {
    // 获取当前弹窗
    NSArray *currentPopups = [TFYPopupView allCurrentPopups];
    if (currentPopups.count > 0) {
        TFYPopupView *lastPopup = [currentPopups lastObject];
        
        NSLog(@"动态内容弹窗: 开始更新内容");
        
        // 关闭当前弹窗
        [lastPopup dismissAnimated:YES completion:^ {
            // 在弹窗关闭后，创建新的弹窗显示更新后的内容
            [self showUpdatedDynamicContentPopup];
        }];
    } else {
        NSLog(@"动态内容弹窗: 没有找到当前弹窗");
    }
}

- (void)showUpdatedDynamicContentPopup {
    // 创建更新后的内容视图
    UIView *updatedContentView = [self createUpdatedDynamicContentDemoContentView];
    
    // 创建容器配置 - 动态内容
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension fixed:UIScreen.mainScreen.bounds.size.width - 40];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    NSLog(@"动态内容弹窗: 显示更新后的弹窗");
    [TFYPopupView showContentView:updatedContentView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (UIView *)createUpdatedDynamicContentDemoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"动态内容弹窗";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"内容已经改变！\n\n这是一个动态更新的弹窗内容。\n\n弹窗会自动调整大小以适应新的内容。\n\n现在内容更长了，可以测试自动尺寸调整功能。\n\n支持多行文本和自动换行。\n\n弹窗会根据内容自动调整高度。";
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor labelColor];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [changeButton setTitle:@"再次改变内容" forState:UIControlStateNormal];
    changeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    changeButton.backgroundColor = [UIColor systemGreenColor];
    [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeButton.layer.cornerRadius = 8;
    changeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [changeButton addTarget:self action:@selector(changeDynamicContentAgain) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:contentLabel];
    [containerView addSubview:changeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [contentLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [contentLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [contentLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [changeButton.topAnchor constraintEqualToAnchor:contentLabel.bottomAnchor constant:20],
        [changeButton.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [changeButton.widthAnchor constraintEqualToConstant:150],
        [changeButton.heightAnchor constraintEqualToConstant:44],
        [changeButton.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20]
    ]];
    
    return containerView;
}

- (void)changeDynamicContentAgain {
    // 获取当前弹窗
    NSArray *currentPopups = [TFYPopupView allCurrentPopups];
    if (currentPopups.count > 0) {
        TFYPopupView *lastPopup = [currentPopups lastObject];
        
        NSLog(@"动态内容弹窗: 再次更新内容");
        
        // 关闭当前弹窗
        [lastPopup dismissAnimated:YES completion:^ {
            // 在弹窗关闭后，创建新的弹窗显示再次更新后的内容
            [self showFinalDynamicContentPopup];
        }];
    }
}

- (UIView *)createFinalDynamicContentDemoContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"最终内容弹窗";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"这是最终的内容更新！\n\n弹窗已经成功更新了多次内容。\n\n每次更新都会重新创建弹窗，确保内容正确显示。\n\n这种方式虽然简单，但非常可靠。\n\n现在可以关闭弹窗了。";
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor systemGreenColor];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭弹窗" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    closeButton.backgroundColor = [UIColor systemBlueColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton addTarget:self action:@selector(dismissCurrentPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:contentLabel];
    [containerView addSubview:closeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [contentLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [contentLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [contentLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        
        [closeButton.topAnchor constraintEqualToAnchor:contentLabel.bottomAnchor constant:20],
        [closeButton.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [closeButton.widthAnchor constraintEqualToConstant:150],
        [closeButton.heightAnchor constraintEqualToConstant:44],
        [closeButton.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20]
    ]];
    
    return containerView;
}

- (void)showFinalDynamicContentPopup {
    // 创建最终的内容视图
    UIView *finalContentView = [self createFinalDynamicContentDemoContentView];
    
    // 创建容器配置 - 最终内容
    TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
    containerConfig.width = [TFYPopupContainerDimension fixed:UIScreen.mainScreen.bounds.size.width - 40];
    containerConfig.height = [TFYPopupContainerDimension automatic];
    containerConfig.cornerRadius = 16;
    containerConfig.shadowEnabled = YES;
    containerConfig.shadowColor = [UIColor blackColor];
    containerConfig.shadowOpacity = 0.25;
    containerConfig.shadowRadius = 12;
    containerConfig.shadowOffset = CGSizeMake(0, 6);
    containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration = containerConfig;
    config.dismissOnBackgroundTap = YES;
    
    NSLog(@"动态内容弹窗: 显示最终弹窗");
    [TFYPopupView showContentView:finalContentView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:^(TFYPopupView * _Nullable pop) {
        
    }];
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
        case TFYContainerSizeDemoTypeComplexAutomatic:
            cell.textLabel.textColor = [UIColor systemIndigoColor];
            break;
        case TFYContainerSizeDemoTypeMarginConfig:
            cell.textLabel.textColor = [UIColor systemBrownColor];
            break;
        case TFYContainerSizeDemoTypeDynamicContent:
            cell.textLabel.textColor = [UIColor systemRedColor];
            break;
        case TFYContainerSizeDemoTypeFormPopup:
            cell.textLabel.textColor = [UIColor systemBlueColor];
            break;
        case TFYContainerSizeDemoTypeImagePopup:
            cell.textLabel.textColor = [UIColor systemOrangeColor];
            break;
        case TFYContainerSizeDemoTypeListPopup:
            cell.textLabel.textColor = [UIColor systemGreenColor];
            break;
        case TFYContainerSizeDemoTypeCardStyle:
            cell.textLabel.textColor = [UIColor systemPurpleColor];
            break;
        case TFYContainerSizeDemoTypeAdaptiveLayout:
            cell.textLabel.textColor = [UIColor systemGrayColor];
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
