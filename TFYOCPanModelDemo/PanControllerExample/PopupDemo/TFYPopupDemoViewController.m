//
//  TFYPopupDemoViewController.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗框架主演示控制器实现
//

#import "TFYPopupDemoViewController.h"
#import "TFYPopup.h"
#import <Masonry/Masonry.h>

/// 演示类型枚举
typedef NS_ENUM(NSInteger, TFYPopupDemoType) {
    TFYPopupDemoTypeBasicAnimators = 0,     // 基础动画器
    TFYPopupDemoTypeDirectionalAnimators,   // 方向动画器
    TFYPopupDemoTypeBottomSheet,           // 底部弹出框
    TFYPopupDemoTypeConfiguration,         // 配置选项
    TFYPopupDemoTypeContainerSize,         // 容器大小演示
    TFYPopupDemoTypeContainerSelection,    // 容器选择演示
    TFYPopupDemoTypePriority,              // 优先级演示
    TFYPopupDemoTypeComprehensive,         // 综合演示
    TFYPopupDemoTypePlayground             // 实验场
};

/// 演示项目模型
@interface TFYPopupDemoModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) TFYPopupDemoType type;
@property (nonatomic, copy) void (^actionBlock)(UIViewController *controller);

+ (instancetype)modelWithTitle:(NSString *)title 
                      subtitle:(NSString *)subtitle 
                          type:(TFYPopupDemoType)type 
                   actionBlock:(void (^)(UIViewController *controller))actionBlock;

@end

@implementation TFYPopupDemoModel

+ (instancetype)modelWithTitle:(NSString *)title 
                      subtitle:(NSString *)subtitle 
                          type:(TFYPopupDemoType)type 
                   actionBlock:(void (^)(UIViewController *controller))actionBlock {
    TFYPopupDemoModel *model = [[TFYPopupDemoModel alloc] init];
    model.title = title;
    model.subtitle = subtitle;
    model.type = type;
    model.actionBlock = actionBlock;
    return model;
}

@end

@interface TFYPopupDemoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<TFYPopupDemoModel *> *demoModels;

@end

@implementation TFYPopupDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupDemoModels];
}

- (void)setupUI {
    self.title = @"TFYPopup 弹窗演示";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    // 添加版本信息按钮
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"关于"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(showAboutInfo)];
    self.navigationItem.rightBarButtonItem = infoButton;
}

- (void)setupDemoModels {
    NSMutableArray *models = [NSMutableArray array];
    
    // 基础动画器演示
    [models addObject:[TFYPopupDemoModel modelWithTitle:@"基础动画器演示" 
                                               subtitle:@"淡入淡出、缩放、弹簧、弹跳等基础动画效果"
                                                   type:TFYPopupDemoTypeBasicAnimators
                                            actionBlock:^(UIViewController *controller) {
        [controller.navigationController pushViewController:[[NSClassFromString(@"TFYPopupBasicAnimatorsViewController") alloc] init] animated:YES];
    }]];
    
    // 方向动画器演示
    [models addObject:[TFYPopupDemoModel modelWithTitle:@"方向动画器演示" 
                                               subtitle:@"上下左右滑入、旋转等方向性动画效果"
                                                   type:TFYPopupDemoTypeDirectionalAnimators
                                            actionBlock:^(UIViewController *controller) {
        [controller.navigationController pushViewController:[[NSClassFromString(@"TFYPopupDirectionalAnimatorsViewController") alloc] init] animated:YES];
    }]];
    
    // 底部弹出框演示
    [models addObject:[TFYPopupDemoModel modelWithTitle:@"底部弹出框演示" 
                                               subtitle:@"支持手势交互的底部弹出框，可拖拽调整高度"
                                                   type:TFYPopupDemoTypeBottomSheet
                                            actionBlock:^(UIViewController *controller) {
        [controller.navigationController pushViewController:[[NSClassFromString(@"TFYPopupBottomSheetViewController") alloc] init] animated:YES];
    }]];
    
    // 配置选项演示
    [models addObject:[TFYPopupDemoModel modelWithTitle:@"配置选项演示" 
                                               subtitle:@"键盘适配、主题、阴影等各种配置选项"
                                                   type:TFYPopupDemoTypeConfiguration
                                            actionBlock:^(UIViewController *controller) {
        [controller.navigationController pushViewController:[[NSClassFromString(@"TFYPopupConfigurationViewController") alloc] init] animated:YES];
    }]];
    
    // 容器大小演示
    [models addObject:[TFYPopupDemoModel modelWithTitle:@"容器大小演示" 
                                               subtitle:@"固定、自动、比例、自定义等多种容器尺寸配置"
                                                   type:TFYPopupDemoTypeContainerSize
                                            actionBlock:^(UIViewController *controller) {
        [controller.navigationController pushViewController:[[NSClassFromString(@"TFYPopupContainerSizeViewController") alloc] init] animated:YES];
    }]];
    
    // 容器选择演示
    [models addObject:[TFYPopupDemoModel modelWithTitle:@"容器选择演示" 
                                               subtitle:@"自动、智能、手动选择策略，指定容器类型和视图"
                                                   type:TFYPopupDemoTypeContainerSelection
                                            actionBlock:^(UIViewController *controller) {
        [controller.navigationController pushViewController:[[NSClassFromString(@"TFYPopupContainerSelectionViewController") alloc] init] animated:YES];
    }]];
    
    // 优先级演示
    [models addObject:[TFYPopupDemoModel modelWithTitle:@"优先级演示" 
                                               subtitle:@"弹窗优先级管理、队列策略、替换和覆盖等高级功能"
                                                   type:TFYPopupDemoTypePriority
                                            actionBlock:^(UIViewController *controller) {
        [controller.navigationController pushViewController:[[NSClassFromString(@"TFYPopupPriorityViewController") alloc] init] animated:YES];
    }]];
    
    // 综合演示
    [models addObject:[TFYPopupDemoModel modelWithTitle:@"综合演示" 
                                               subtitle:@"复杂的弹窗组合、多层弹窗、链式调用等高级用法"
                                                   type:TFYPopupDemoTypeComprehensive
                                            actionBlock:^(UIViewController *controller) {
        [controller.navigationController pushViewController:[[NSClassFromString(@"TFYPopupComprehensiveViewController") alloc] init] animated:YES];
    }]];
    
    // 实验场
    [models addObject:[TFYPopupDemoModel modelWithTitle:@"实验场" 
                                               subtitle:@"自定义参数调试、实时预览、性能测试"
                                                   type:TFYPopupDemoTypePlayground
                                            actionBlock:^(UIViewController *controller) {
        [controller.navigationController pushViewController:[[NSClassFromString(@"TFYPopupPlaygroundViewController") alloc] init] animated:YES];
    }]];
    
    self.demoModels = [models copy];
}

#pragma mark - Actions

- (void)showAboutInfo {
    // 创建关于信息视图
    UIView *aboutView = [[UIView alloc] init];
    aboutView.backgroundColor = [UIColor systemBackgroundColor];
    aboutView.layer.cornerRadius = 16;
    aboutView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"TFYPopup 弹窗框架";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [aboutView addSubview:titleLabel];
    
    // 版本信息
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"版本：1.2.5"];
    versionLabel.font = [UIFont systemFontOfSize:16];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor secondaryLabelColor];
    versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [aboutView addSubview:versionLabel];
    
    // 作者信息
    UILabel *authorLabel = [[UILabel alloc] init];
    authorLabel.text = [NSString stringWithFormat:@"作者：田风有"];
    authorLabel.font = [UIFont systemFontOfSize:16];
    authorLabel.textAlignment = NSTextAlignmentCenter;
    authorLabel.textColor = [UIColor secondaryLabelColor];
    authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [aboutView addSubview:authorLabel];
    
    // 描述
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.text = @"";
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textColor = [UIColor secondaryLabelColor];
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [aboutView addSubview:descriptionLabel];
    
    // 特性列表
    NSArray *features = @[@"• 多种动画效果", @"• 手势交互支持", @"• 键盘自适应", @"• 主题配置", @"• 性能优化"];
    UILabel *featuresLabel = [[UILabel alloc] init];
    featuresLabel.text = [features componentsJoinedByString:@"\n"];
    featuresLabel.font = [UIFont systemFontOfSize:14];
    featuresLabel.numberOfLines = 0;
    featuresLabel.textColor = [UIColor labelColor];
    featuresLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [aboutView addSubview:featuresLabel];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // aboutView 尺寸
        [aboutView.widthAnchor constraintEqualToConstant:300],
        [aboutView.heightAnchor constraintGreaterThanOrEqualToConstant:280],
        
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:aboutView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:aboutView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:aboutView.trailingAnchor constant:-20],
        
        // versionLabel
        [versionLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8],
        [versionLabel.leadingAnchor constraintEqualToAnchor:aboutView.leadingAnchor constant:20],
        [versionLabel.trailingAnchor constraintEqualToAnchor:aboutView.trailingAnchor constant:-20],
        
        // authorLabel
        [authorLabel.topAnchor constraintEqualToAnchor:versionLabel.bottomAnchor constant:4],
        [authorLabel.leadingAnchor constraintEqualToAnchor:aboutView.leadingAnchor constant:20],
        [authorLabel.trailingAnchor constraintEqualToAnchor:aboutView.trailingAnchor constant:-20],
        
        // descriptionLabel
        [descriptionLabel.topAnchor constraintEqualToAnchor:authorLabel.bottomAnchor constant:16],
        [descriptionLabel.leadingAnchor constraintEqualToAnchor:aboutView.leadingAnchor constant:20],
        [descriptionLabel.trailingAnchor constraintEqualToAnchor:aboutView.trailingAnchor constant:-20],
        
        // featuresLabel
        [featuresLabel.topAnchor constraintEqualToAnchor:descriptionLabel.bottomAnchor constant:16],
        [featuresLabel.leadingAnchor constraintEqualToAnchor:aboutView.leadingAnchor constant:20],
        [featuresLabel.trailingAnchor constraintEqualToAnchor:aboutView.trailingAnchor constant:-20],
        [featuresLabel.bottomAnchor constraintEqualToAnchor:aboutView.bottomAnchor constant:-20]
    ]];
    
    // 显示弹窗
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.dismissOnBackgroundTap = YES;
    config.enableHapticFeedback = YES;
    
    [TFYPopupView showContentViewWithContainerSelection:aboutView
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
    static NSString *cellIdentifier = @"PopupDemoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    TFYPopupDemoModel *model = self.demoModels[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subtitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 根据类型设置图标颜色
    switch (model.type) {
        case TFYPopupDemoTypeBasicAnimators:
            cell.textLabel.textColor = [UIColor systemBlueColor];
            break;
        case TFYPopupDemoTypeDirectionalAnimators:
            cell.textLabel.textColor = [UIColor systemGreenColor];
            break;
        case TFYPopupDemoTypeBottomSheet:
            cell.textLabel.textColor = [UIColor systemOrangeColor];
            break;
        case TFYPopupDemoTypeConfiguration:
            cell.textLabel.textColor = [UIColor systemPurpleColor];
            break;
        case TFYPopupDemoTypeContainerSize:
            cell.textLabel.textColor = [UIColor systemIndigoColor];
            break;
        case TFYPopupDemoTypeContainerSelection:
            cell.textLabel.textColor = [UIColor systemPinkColor];
            break;
        case TFYPopupDemoTypePriority:
            cell.textLabel.textColor = [UIColor systemTealColor];
            break;
        case TFYPopupDemoTypeComprehensive:
            cell.textLabel.textColor = [UIColor systemRedColor];
            break;
        case TFYPopupDemoTypePlayground:
            cell.textLabel.textColor = [UIColor systemTealColor];
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TFYPopupDemoModel *model = self.demoModels[indexPath.row];
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
