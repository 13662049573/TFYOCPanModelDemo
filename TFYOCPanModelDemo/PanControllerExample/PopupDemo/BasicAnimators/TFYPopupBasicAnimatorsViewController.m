//
//  TFYPopupBasicAnimatorsViewController.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：基础动画器演示控制器实现
//

#import "TFYPopupBasicAnimatorsViewController.h"
#import "TFYPopup.h"
#import <Masonry/Masonry.h>

/// 基础动画器类型
typedef NS_ENUM(NSInteger, TFYBasicAnimatorType) {
    TFYBasicAnimatorTypeFadeInOut = 0,  // 淡入淡出
    TFYBasicAnimatorTypeZoomInOut,      // 缩放
    TFYBasicAnimatorType3DFlip,         // 3D翻转
    TFYBasicAnimatorTypeSpring,         // 弹簧
    TFYBasicAnimatorTypeBounce,         // 弹跳
    TFYBasicAnimatorTypeRotate          // 旋转
};

/// 动画器演示模型
@interface TFYBasicAnimatorDemoModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailDescription;
@property (nonatomic, assign) TFYBasicAnimatorType type;
@property (nonatomic, strong) Class animatorClass;
@property (nonatomic, strong) UIColor *backgroundColor;

+ (instancetype)modelWithTitle:(NSString *)title
                   description:(NSString *)description
                          type:(TFYBasicAnimatorType)type
                animatorClass:(Class)animatorClass
               backgroundColor:(UIColor *)backgroundColor;

@end

@implementation TFYBasicAnimatorDemoModel

+ (instancetype)modelWithTitle:(NSString *)title
                   description:(NSString *)description
                          type:(TFYBasicAnimatorType)type
                animatorClass:(Class)animatorClass
               backgroundColor:(UIColor *)backgroundColor {
    TFYBasicAnimatorDemoModel *model = [[TFYBasicAnimatorDemoModel alloc] init];
    model.title = title;
    model.detailDescription = description;
    model.type = type;
    model.animatorClass = animatorClass;
    model.backgroundColor = backgroundColor;
    return model;
}

@end

@interface TFYPopupBasicAnimatorsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<TFYBasicAnimatorDemoModel *> *demoModels;

@end

@implementation TFYPopupBasicAnimatorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupDemoModels];
}

- (void)setupUI {
    self.title = @"基础动画器演示";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    // 添加测试所有动画的按钮
    UIBarButtonItem *testAllButton = [[UIBarButtonItem alloc] initWithTitle:@"全部测试"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(testAllAnimators)];
    self.navigationItem.rightBarButtonItem = testAllButton;
}

- (void)setupDemoModels {
    NSMutableArray *models = [NSMutableArray array];
    
    [models addObject:[TFYBasicAnimatorDemoModel modelWithTitle:@"淡入淡出"
                                                    description:@"经典的淡入淡出效果"
                                                           type:TFYBasicAnimatorTypeFadeInOut
                                                  animatorClass:[TFYPopupFadeInOutAnimator class]
                                                backgroundColor:[UIColor systemBlueColor]]];
    
    [models addObject:[TFYBasicAnimatorDemoModel modelWithTitle:@"缩放动画"
                                                    description:@"从小到大的缩放效果"
                                                           type:TFYBasicAnimatorTypeZoomInOut
                                                  animatorClass:[TFYPopupZoomInOutAnimator class]
                                                backgroundColor:[UIColor systemGreenColor]]];
    
    [models addObject:[TFYBasicAnimatorDemoModel modelWithTitle:@"3D翻转"
                                                    description:@"3D空间翻转效果"
                                                           type:TFYBasicAnimatorType3DFlip
                                                  animatorClass:[TFYPopup3DFlipAnimator class]
                                                backgroundColor:[UIColor systemOrangeColor]]];
    
    [models addObject:[TFYBasicAnimatorDemoModel modelWithTitle:@"弹簧动画"
                                                    description:@"弹性十足的弹簧效果"
                                                           type:TFYBasicAnimatorTypeSpring
                                                  animatorClass:[TFYPopupSpringAnimator class]
                                                backgroundColor:[UIColor systemPurpleColor]]];
    
    [models addObject:[TFYBasicAnimatorDemoModel modelWithTitle:@"弹跳动画"
                                                    description:@"活泼的弹跳效果"
                                                           type:TFYBasicAnimatorTypeBounce
                                                  animatorClass:[TFYPopupBounceAnimator class]
                                                backgroundColor:[UIColor systemRedColor]]];
    
    [models addObject:[TFYBasicAnimatorDemoModel modelWithTitle:@"旋转动画"
                                                    description:@"华丽的旋转进入效果"
                                                           type:TFYBasicAnimatorTypeRotate
                                                  animatorClass:[TFYPopupRotateAnimator class]
                                                backgroundColor:[UIColor systemTealColor]]];
    
    self.demoModels = [models copy];
}

#pragma mark - Actions

- (void)testAllAnimators {
    // 创建一个简单的提示视图
    UIView *tipView = [[UIView alloc] init];
    tipView.backgroundColor = [UIColor systemBackgroundColor];
    tipView.layer.cornerRadius = 12;
    tipView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"将依次播放所有基础动画效果";
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [tipView addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [tipView.widthAnchor constraintEqualToConstant:250],
        [tipView.heightAnchor constraintEqualToConstant:100],
        [label.centerXAnchor constraintEqualToAnchor:tipView.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:tipView.centerYAnchor],
        [label.leadingAnchor constraintEqualToAnchor:tipView.leadingAnchor constant:20],
        [label.trailingAnchor constraintEqualToAnchor:tipView.trailingAnchor constant:-20]
    ]];
    
    // 依次显示每种动画效果
    [self showAnimatorSequentially:0 tipView:tipView];
}

- (void)showAnimatorSequentially:(NSInteger)index tipView:(UIView *)tipView {
    if (index >= self.demoModels.count) {
        return; // 播放完成
    }
    
    TFYBasicAnimatorDemoModel *model = self.demoModels[index];
    
    // 更新提示内容
    UILabel *label = tipView.subviews.firstObject;
    label.text = [NSString stringWithFormat:@"正在演示：%@\n%@", model.title, model.detailDescription];
    tipView.backgroundColor = [model.backgroundColor colorWithAlphaComponent:0.1];
    
    // 创建动画器
    id<TFYPopupViewAnimator> animator = [[model.animatorClass alloc] init];
    
    // 显示弹窗
    __block TFYPopupView *popup;
    popup = [TFYPopupView showContentView:tipView
                            configuration:[[TFYPopupViewConfiguration alloc] init]
                                 animator:animator
                                 animated:YES
                               completion:^{
        // 2秒后自动关闭并显示下一个
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [popup dismissAnimated:YES completion:^{
                [self showAnimatorSequentially:index + 1 tipView:tipView];
            }];
        });
    }];
}

- (void)showDemoWithModel:(TFYBasicAnimatorDemoModel *)model {
    // 创建演示内容视图
    UIView *contentView = [self createDemoContentViewWithModel:model];
    
    // 创建动画器
    id<TFYPopupViewAnimator> animator = [[model.animatorClass alloc] init];
    
    // 配置弹窗
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.dismissOnBackgroundTap = YES;
    config.enableHapticFeedback = YES;
    config.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    // 显示弹窗
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:animator
                         animated:YES
                       completion:^{
        NSLog(@"显示了 %@ 动画效果", model.title);
    }];
}

- (UIView *)createDemoContentViewWithModel:(TFYBasicAnimatorDemoModel *)model {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor systemBackgroundColor];
    contentView.layer.cornerRadius = 16;
    contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    contentView.layer.shadowOffset = CGSizeMake(0, 4);
    contentView.layer.shadowRadius = 12;
    contentView.layer.shadowOpacity = 0.15;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 颜色指示器
    UIView *colorIndicator = [[UIView alloc] init];
    colorIndicator.backgroundColor = model.backgroundColor;
    colorIndicator.layer.cornerRadius = 25;
    colorIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:colorIndicator];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = model.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
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
        [contentView.heightAnchor constraintGreaterThanOrEqualToConstant:250],
        
        // colorIndicator
        [colorIndicator.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:20],
        [colorIndicator.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [colorIndicator.widthAnchor constraintEqualToConstant:50],
        [colorIndicator.heightAnchor constraintEqualToConstant:50],
        
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:colorIndicator.bottomAnchor constant:16],
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

- (NSString *)getFeatureTextForAnimatorType:(TFYBasicAnimatorType)type {
    switch (type) {
        case TFYBasicAnimatorTypeFadeInOut:
            return @"• 平滑的透明度变化\n• 适用于简洁的弹窗场景\n• 系统默认动画风格";
        case TFYBasicAnimatorTypeZoomInOut:
            return @"• 从中心点缩放展开\n• 突出显示效果\n• 适合重要提示";
        case TFYBasicAnimatorType3DFlip:
            return @"• 3D空间翻转效果\n• 视觉冲击力强\n• 创新的交互体验";
        case TFYBasicAnimatorTypeSpring:
            return @"• 弹性动画效果\n• 自然的物理表现\n• 用户友好的交互";
        case TFYBasicAnimatorTypeBounce:
            return @"• 弹跳回弹效果\n• 活泼生动的表现\n• 吸引用户注意";
        case TFYBasicAnimatorTypeRotate:
            return @"• 旋转进入效果\n• 华丽的视觉表现\n• 适合特殊场合";
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.demoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BasicAnimatorCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    // 清除旧的子视图
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    TFYBasicAnimatorDemoModel *model = self.demoModels[indexPath.row];
    
    // 设置cell样式
    cell.contentView.backgroundColor = [model.backgroundColor colorWithAlphaComponent:0.1];
    cell.contentView.layer.cornerRadius = 12;
    cell.contentView.layer.borderWidth = 2;
    cell.contentView.layer.borderColor = [model.backgroundColor colorWithAlphaComponent:0.3].CGColor;
    
    // 添加标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = model.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = model.backgroundColor;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:titleLabel];
    
    // 添加描述
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.text = model.detailDescription;
    descriptionLabel.font = [UIFont systemFontOfSize:12];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.textColor = [UIColor secondaryLabelColor];
    descriptionLabel.numberOfLines = 2;
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:descriptionLabel];
    
    // 添加图标视图
    UIView *iconView = [[UIView alloc] init];
    iconView.backgroundColor = model.backgroundColor;
    iconView.layer.cornerRadius = 20;
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:iconView];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // iconView
        [iconView.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:12],
        [iconView.centerXAnchor constraintEqualToAnchor:cell.contentView.centerXAnchor],
        [iconView.widthAnchor constraintEqualToConstant:40],
        [iconView.heightAnchor constraintEqualToConstant:40],
        
        // titleLabel
        [titleLabel.topAnchor constraintEqualToAnchor:iconView.bottomAnchor constant:8],
        [titleLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:8],
        [titleLabel.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-8],
        
        // descriptionLabel
        [descriptionLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:4],
        [descriptionLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:8],
        [descriptionLabel.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-8],
        [descriptionLabel.bottomAnchor constraintLessThanOrEqualToAnchor:cell.contentView.bottomAnchor constant:-8]
    ]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    TFYBasicAnimatorDemoModel *model = self.demoModels[indexPath.row];
    [self showDemoWithModel:model];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (CGRectGetWidth(collectionView.frame) - 60) / 2; // 2列，考虑边距
    return CGSizeMake(width, width * 0.8);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor systemBackgroundColor];
        _collectionView.showsVerticalScrollIndicator = YES;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BasicAnimatorCell"];
    }
    return _collectionView;
}

@end
