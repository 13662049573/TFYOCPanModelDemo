//
//  TFYPopupDirectionalAnimatorsViewController.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：方向动画器演示控制器实现
//

#import "TFYPopupDirectionalAnimatorsViewController.h"

/// 方向动画器类型
typedef NS_ENUM(NSInteger, TFYDirectionalAnimatorType) {
    TFYDirectionalAnimatorTypeUpward = 0,       // 向上滑入
    TFYDirectionalAnimatorTypeDownward,         // 向下滑入
    TFYDirectionalAnimatorTypeLeftward,         // 向左滑入
    TFYDirectionalAnimatorTypeRightward,        // 向右滑入
    TFYDirectionalAnimatorTypeSlideFromTop,     // 从顶部滑入
    TFYDirectionalAnimatorTypeSlideFromBottom,  // 从底部滑入
    TFYDirectionalAnimatorTypeSlideFromLeft,    // 从左侧滑入
    TFYDirectionalAnimatorTypeSlideFromRight    // 从右侧滑入
};

/// 方向动画器演示模型
@interface TFYDirectionalAnimatorDemoModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailDescription;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) TFYDirectionalAnimatorType type;
@property (nonatomic, strong) Class animatorClass;
@property (nonatomic, strong) UIColor *backgroundColor;

+ (instancetype)modelWithTitle:(NSString *)title
                   description:(NSString *)description
                          icon:(NSString *)icon
                          type:(TFYDirectionalAnimatorType)type
                animatorClass:(Class)animatorClass
               backgroundColor:(UIColor *)backgroundColor;

@end

@implementation TFYDirectionalAnimatorDemoModel

+ (instancetype)modelWithTitle:(NSString *)title
                   description:(NSString *)description
                          icon:(NSString *)icon
                          type:(TFYDirectionalAnimatorType)type
                animatorClass:(Class)animatorClass
               backgroundColor:(UIColor *)backgroundColor {
    TFYDirectionalAnimatorDemoModel *model = [[TFYDirectionalAnimatorDemoModel alloc] init];
    model.title = title;
    model.detailDescription = description;
    model.icon = icon;
    model.type = type;
    model.animatorClass = animatorClass;
    model.backgroundColor = backgroundColor;
    return model;
}

@end

@interface TFYPopupDirectionalAnimatorsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<TFYDirectionalAnimatorDemoModel *> *demoModels;

@end

@implementation TFYPopupDirectionalAnimatorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupDemoModels];
}

- (void)setupUI {
    self.title = @"方向动画器演示";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    // 添加方向演示按钮
    UIBarButtonItem *compassButton = [[UIBarButtonItem alloc] initWithTitle:@"指南针"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(showCompassDemo)];
    self.navigationItem.rightBarButtonItem = compassButton;
}

- (void)setupDemoModels {
    NSMutableArray *models = [NSMutableArray array];
    
    // 基础方向动画器
    [models addObject:[TFYDirectionalAnimatorDemoModel modelWithTitle:@"向上滑入"
                                                          description:@"从屏幕下方向上滑动进入"
                                                                 icon:@"↑"
                                                                 type:TFYDirectionalAnimatorTypeUpward
                                                        animatorClass:[TFYPopupUpwardAnimator class]
                                                      backgroundColor:[UIColor systemBlueColor]]];
    
    [models addObject:[TFYDirectionalAnimatorDemoModel modelWithTitle:@"向下滑入"
                                                          description:@"从屏幕上方向下滑动进入"
                                                                 icon:@"↓"
                                                                 type:TFYDirectionalAnimatorTypeDownward
                                                        animatorClass:[TFYPopupDownwardAnimator class]
                                                      backgroundColor:[UIColor systemGreenColor]]];
    
    [models addObject:[TFYDirectionalAnimatorDemoModel modelWithTitle:@"向左滑入"
                                                          description:@"从屏幕右侧向左滑动进入"
                                                                 icon:@"←"
                                                                 type:TFYDirectionalAnimatorTypeLeftward
                                                        animatorClass:[TFYPopupLeftwardAnimator class]
                                                      backgroundColor:[UIColor systemOrangeColor]]];
    
    [models addObject:[TFYDirectionalAnimatorDemoModel modelWithTitle:@"向右滑入"
                                                          description:@"从屏幕左侧向右滑动进入"
                                                                 icon:@"→"
                                                                 type:TFYDirectionalAnimatorTypeRightward
                                                        animatorClass:[TFYPopupRightwardAnimator class]
                                                      backgroundColor:[UIColor systemPurpleColor]]];
    
    // 滑动动画器
    [models addObject:[TFYDirectionalAnimatorDemoModel modelWithTitle:@"从顶部滑入"
                                                          description:@"使用滑动动画器从顶部进入"
                                                                 icon:@"⬇"
                                                                 type:TFYDirectionalAnimatorTypeSlideFromTop
                                                        animatorClass:[TFYPopupSlideAnimator class]
                                                      backgroundColor:[UIColor systemRedColor]]];
    
    [models addObject:[TFYDirectionalAnimatorDemoModel modelWithTitle:@"从底部滑入"
                                                          description:@"使用滑动动画器从底部进入"
                                                                 icon:@"⬆"
                                                                 type:TFYDirectionalAnimatorTypeSlideFromBottom
                                                        animatorClass:[TFYPopupSlideAnimator class]
                                                      backgroundColor:[UIColor systemTealColor]]];
    
    [models addObject:[TFYDirectionalAnimatorDemoModel modelWithTitle:@"从左侧滑入"
                                                          description:@"使用滑动动画器从左侧进入"
                                                                 icon:@"➡"
                                                                 type:TFYDirectionalAnimatorTypeSlideFromLeft
                                                        animatorClass:[TFYPopupSlideAnimator class]
                                                      backgroundColor:[UIColor systemIndigoColor]]];
    
    [models addObject:[TFYDirectionalAnimatorDemoModel modelWithTitle:@"从右侧滑入"
                                                          description:@"使用滑动动画器从右侧进入"
                                                                 icon:@"⬅"
                                                                 type:TFYDirectionalAnimatorTypeSlideFromRight
                                                        animatorClass:[TFYPopupSlideAnimator class]
                                                      backgroundColor:[UIColor systemPinkColor]]];
    
    self.demoModels = [models copy];
}

#pragma mark - Actions

- (void)showCompassDemo {
    // 创建指南针演示视图
    UIView *compassView = [self createCompassView];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.dismissOnBackgroundTap = YES;
    config.enableHapticFeedback = YES;
    config.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    [TFYPopupView showContentViewWithContainerSelection:compassView
                    configuration:config
                         animator:[[TFYPopupZoomInOutAnimator alloc] init]
                         animated:YES
                                             completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (UIView *)createCompassView {
    UIView *compassView = [[UIView alloc] init];
    compassView.backgroundColor = [UIColor systemBackgroundColor];
    compassView.layer.cornerRadius = 20;
    compassView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"方向指南针";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [compassView addSubview:titleLabel];
    
    // 创建指南针网格
    NSArray *directions = @[@"↑", @"↓", @"←", @"→"];
    NSArray *colors = @[[UIColor systemBlueColor], [UIColor systemGreenColor], 
                       [UIColor systemOrangeColor], [UIColor systemPurpleColor]];
    NSArray *titles = @[@"上", @"下", @"左", @"右"];
    
    UIStackView *gridStackView = [[UIStackView alloc] init];
    gridStackView.axis = UILayoutConstraintAxisVertical;
    gridStackView.spacing = 10;
    gridStackView.distribution = UIStackViewDistributionFillEqually;
    gridStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [compassView addSubview:gridStackView];
    
    // 创建上行（只有上方向）
    UIStackView *topRowStack = [[UIStackView alloc] init];
    topRowStack.axis = UILayoutConstraintAxisHorizontal;
    topRowStack.spacing = 10;
    topRowStack.distribution = UIStackViewDistributionFillEqually;
    [gridStackView addArrangedSubview:topRowStack];
    
    [topRowStack addArrangedSubview:[[UIView alloc] init]]; // 占位
    UIButton *topButton = [self createDirectionButtonWithIcon:directions[0] color:colors[0] title:titles[0] type:TFYDirectionalAnimatorTypeUpward];
    [topRowStack addArrangedSubview:topButton];
    [topRowStack addArrangedSubview:[[UIView alloc] init]]; // 占位
    
    // 创建中行（左右方向）
    UIStackView *middleRowStack = [[UIStackView alloc] init];
    middleRowStack.axis = UILayoutConstraintAxisHorizontal;
    middleRowStack.spacing = 10;
    middleRowStack.distribution = UIStackViewDistributionFillEqually;
    [gridStackView addArrangedSubview:middleRowStack];
    
    UIButton *leftButton = [self createDirectionButtonWithIcon:directions[2] color:colors[2] title:titles[2] type:TFYDirectionalAnimatorTypeLeftward];
    [middleRowStack addArrangedSubview:leftButton];
    
    // 中心logo
    UILabel *centerLabel = [[UILabel alloc] init];
    centerLabel.text = @"🧭";
    centerLabel.font = [UIFont systemFontOfSize:30];
    centerLabel.textAlignment = NSTextAlignmentCenter;
    [middleRowStack addArrangedSubview:centerLabel];
    
    UIButton *rightButton = [self createDirectionButtonWithIcon:directions[3] color:colors[3] title:titles[3] type:TFYDirectionalAnimatorTypeRightward];
    [middleRowStack addArrangedSubview:rightButton];
    
    // 创建下行（只有下方向）
    UIStackView *bottomRowStack = [[UIStackView alloc] init];
    bottomRowStack.axis = UILayoutConstraintAxisHorizontal;
    bottomRowStack.spacing = 10;
    bottomRowStack.distribution = UIStackViewDistributionFillEqually;
    [gridStackView addArrangedSubview:bottomRowStack];
    
    [bottomRowStack addArrangedSubview:[[UIView alloc] init]]; // 占位
    UIButton *bottomButton = [self createDirectionButtonWithIcon:directions[1] color:colors[1] title:titles[1] type:TFYDirectionalAnimatorTypeDownward];
    [bottomRowStack addArrangedSubview:bottomButton];
    [bottomRowStack addArrangedSubview:[[UIView alloc] init]]; // 占位
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // compassView 尺寸
        [compassView.widthAnchor constraintEqualToConstant:250],
        [compassView.heightAnchor constraintEqualToConstant:280],
        
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:compassView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:compassView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:compassView.trailingAnchor constant:-20],
        
        // gridStackView
        [gridStackView.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:20],
        [gridStackView.leadingAnchor constraintEqualToAnchor:compassView.leadingAnchor constant:20],
        [gridStackView.trailingAnchor constraintEqualToAnchor:compassView.trailingAnchor constant:-20],
        [gridStackView.bottomAnchor constraintEqualToAnchor:compassView.bottomAnchor constant:-20],
        [gridStackView.heightAnchor constraintEqualToConstant:180]
    ]];
    
    return compassView;
}

- (UIButton *)createDirectionButtonWithIcon:(NSString *)icon color:(UIColor *)color title:(NSString *)title type:(TFYDirectionalAnimatorType)type {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [color colorWithAlphaComponent:0.1];
    button.layer.cornerRadius = 8;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [color colorWithAlphaComponent:0.3].CGColor;
    
    // 创建按钮内容
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    // 图标部分
    NSAttributedString *iconString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", icon]
                                                                     attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:20],
        NSForegroundColorAttributeName: color
    }];
    [attributedString appendAttributedString:iconString];
    
    // 标题部分
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:title
                                                                      attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:12],
        NSForegroundColorAttributeName: color
    }];
    [attributedString appendAttributedString:titleString];
    
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 添加点击事件
    button.tag = type;
    [button addTarget:self action:@selector(compassButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)compassButtonTapped:(UIButton *)sender {
    TFYDirectionalAnimatorType type = (TFYDirectionalAnimatorType)sender.tag;
    TFYDirectionalAnimatorDemoModel *model = nil;
    
    // 找到对应的模型
    for (TFYDirectionalAnimatorDemoModel *demoModel in self.demoModels) {
        if (demoModel.type == type) {
            model = demoModel;
            break;
        }
    }
    
    if (model) {
        // 先关闭当前弹窗，然后显示选中的演示
        NSArray *currentPopups = TFYPopupGetAllCurrentPopups();
        if (currentPopups.count > 0) {
            [currentPopups.firstObject dismissAnimated:YES completion:^ {
                [self showDemoWithModel:model];
            }];
        } else {
            [self showDemoWithModel:model];
        }
    }
}

- (void)showDemoWithModel:(TFYDirectionalAnimatorDemoModel *)model {
    // 创建演示内容视图
    UIView *contentView = [self createDemoContentViewWithModel:model];
    
    // 创建动画器
    id<TFYPopupViewAnimator> animator = [self createAnimatorForModel:model];
    
    // 配置弹窗
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.dismissOnBackgroundTap = YES;
    config.enableHapticFeedback = YES;
    config.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    // 显示弹窗
    [TFYPopupView showContentViewWithContainerSelection:contentView
                    configuration:config
                         animator:animator
                         animated:YES
                         completion:^(TFYPopupView * _Nullable pop) {
        
    }];
}

- (id<TFYPopupViewAnimator>)createAnimatorForModel:(TFYDirectionalAnimatorDemoModel *)model {
    switch (model.type) {
        case TFYDirectionalAnimatorTypeUpward:
            return [[TFYPopupUpwardAnimator alloc] init];
        case TFYDirectionalAnimatorTypeDownward:
            return [[TFYPopupDownwardAnimator alloc] init];
        case TFYDirectionalAnimatorTypeLeftward:
            return [[TFYPopupLeftwardAnimator alloc] init];
        case TFYDirectionalAnimatorTypeRightward:
            return [[TFYPopupRightwardAnimator alloc] init];
        case TFYDirectionalAnimatorTypeSlideFromTop:
            return [[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromTop];
        case TFYDirectionalAnimatorTypeSlideFromBottom:
            return [[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromBottom];
        case TFYDirectionalAnimatorTypeSlideFromLeft:
            return [[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromLeft];
        case TFYDirectionalAnimatorTypeSlideFromRight:
            return [[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromRight];
    }
}

- (UIView *)createDemoContentViewWithModel:(TFYDirectionalAnimatorDemoModel *)model {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor systemBackgroundColor];
    contentView.layer.cornerRadius = 16;
    contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    contentView.layer.shadowOffset = CGSizeMake(0, 4);
    contentView.layer.shadowRadius = 12;
    contentView.layer.shadowOpacity = 0.15;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 方向图标
    UILabel *iconLabel = [[UILabel alloc] init];
    iconLabel.text = model.icon;
    iconLabel.font = [UIFont systemFontOfSize:60];
    iconLabel.textAlignment = NSTextAlignmentCenter;
    iconLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:iconLabel];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = model.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = model.backgroundColor;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:titleLabel];
    
    // 描述
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.text = model.detailDescription;
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.textColor = [UIColor secondaryLabelColor];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:descriptionLabel];
    
    // 特性说明
    NSString *featureText = [self getFeatureTextForAnimatorType:model.type];
    UILabel *featureLabel = [[UILabel alloc] init];
    featureLabel.text = featureText;
    featureLabel.font = [UIFont systemFontOfSize:14];
    featureLabel.textAlignment = NSTextAlignmentCenter;
    featureLabel.textColor = [UIColor tertiaryLabelColor];
    featureLabel.numberOfLines = 0;
    featureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:featureLabel];
    
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    closeButton.backgroundColor = model.backgroundColor;
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:closeButton];
    
    // 添加关闭按钮点击事件
    [closeButton addTarget:self action:@selector(closeCurrentPopup:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // contentView 尺寸
        [contentView.widthAnchor constraintEqualToConstant:300],
        [contentView.heightAnchor constraintGreaterThanOrEqualToConstant:280],
        
        // iconLabel
        [iconLabel.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:20],
        [iconLabel.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [iconLabel.heightAnchor constraintEqualToConstant:80],
        
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:iconLabel.bottomAnchor constant:10],
        [titleLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        // descriptionLabel
        [descriptionLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8],
        [descriptionLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [descriptionLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        // featureLabel
        [featureLabel.topAnchor constraintEqualToAnchor:descriptionLabel.bottomAnchor constant:16],
        [featureLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [featureLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        // closeButton
        [closeButton.topAnchor constraintEqualToAnchor:featureLabel.bottomAnchor constant:20],
        [closeButton.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [closeButton.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [closeButton.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-20],
        [closeButton.heightAnchor constraintEqualToConstant:44]
    ]];
    
    return contentView;
}

- (NSString *)getFeatureTextForAnimatorType:(TFYDirectionalAnimatorType)type {
    switch (type) {
        case TFYDirectionalAnimatorTypeUpward:
            return @"• 从下方向上滑入\n• 适合底部操作面板\n• 自然的进入方式";
        case TFYDirectionalAnimatorTypeDownward:
            return @"• 从上方向下滑入\n• 适合顶部通知\n• 模拟下拉效果";
        case TFYDirectionalAnimatorTypeLeftward:
            return @"• 从右侧向左滑入\n• 适合侧边菜单\n• 横向导航感";
        case TFYDirectionalAnimatorTypeRightward:
            return @"• 从左侧向右滑入\n• 适合详情页面\n• 层级导航感";
        case TFYDirectionalAnimatorTypeSlideFromTop:
            return @"• 滑动动画器\n• 从顶部完整滑入\n• 更流畅的动画";
        case TFYDirectionalAnimatorTypeSlideFromBottom:
            return @"• 滑动动画器\n• 从底部完整滑入\n• 经典的弹出方式";
        case TFYDirectionalAnimatorTypeSlideFromLeft:
            return @"• 滑动动画器\n• 从左侧完整滑入\n• 侧边栏效果";
        case TFYDirectionalAnimatorTypeSlideFromRight:
            return @"• 滑动动画器\n• 从右侧完整滑入\n• 右侧面板效果";
    }
}

- (void)closeCurrentPopup:(UIButton *)sender {
    // 查找当前的弹窗并关闭
    UIView *contentView = sender.superview;
    TFYPopupView *popupView = [contentView findPopupView];
    if (popupView) {
        [popupView dismissAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DirectionalAnimatorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    TFYDirectionalAnimatorDemoModel *model = self.demoModels[indexPath.row];
    
    // 创建自定义内容
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 方向图标
    UILabel *iconLabel = [[UILabel alloc] init];
    iconLabel.text = model.icon;
    iconLabel.font = [UIFont systemFontOfSize:30];
    iconLabel.textAlignment = NSTextAlignmentCenter;
    iconLabel.backgroundColor = [model.backgroundColor colorWithAlphaComponent:0.1];
    iconLabel.layer.cornerRadius = 20;
    iconLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:iconLabel];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = model.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = model.backgroundColor;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:titleLabel];
    
    // 描述
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.text = model.detailDescription;
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.textColor = [UIColor secondaryLabelColor];
    descriptionLabel.numberOfLines = 2;
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:descriptionLabel];
    
    // 箭头指示器
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
        [iconLabel.heightAnchor constraintEqualToConstant:40],
        
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:8],
        [titleLabel.leadingAnchor constraintEqualToAnchor:iconLabel.trailingAnchor constant:16],
        [titleLabel.trailingAnchor constraintEqualToAnchor:arrowLabel.leadingAnchor constant:-8],
        
        // descriptionLabel
        [descriptionLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:4],
        [descriptionLabel.leadingAnchor constraintEqualToAnchor:iconLabel.trailingAnchor constant:16],
        [descriptionLabel.trailingAnchor constraintEqualToAnchor:arrowLabel.leadingAnchor constant:-8],
        [descriptionLabel.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:-8],
        
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
    
    TFYDirectionalAnimatorDemoModel *model = self.demoModels[indexPath.row];
    [self showDemoWithModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
