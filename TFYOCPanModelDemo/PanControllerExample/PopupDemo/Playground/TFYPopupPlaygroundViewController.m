//
//  TFYPopupPlaygroundViewController.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：实验场控制器实现
//

#import "TFYPopupPlaygroundViewController.h"
#import "TFYPopup.h"
#import <Masonry/Masonry.h>

@interface TFYPopupPlaygroundViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// 配置控件
@property (nonatomic, strong) UISegmentedControl *animatorControl;
@property (nonatomic, strong) UISlider *durationSlider;
@property (nonatomic, strong) UISwitch *backgroundTapSwitch;
@property (nonatomic, strong) UISwitch *gestureSwitch;
@property (nonatomic, strong) UISegmentedControl *themeControl;

@end

@implementation TFYPopupPlaygroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"实验场";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_greaterThanOrEqualTo(700);
    }];
    
    [self setupControls];
    
    // 右上角测试按钮
    UIBarButtonItem *testButton = [[UIBarButtonItem alloc] initWithTitle:@"预览"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(previewPopup)];
    self.navigationItem.rightBarButtonItem = testButton;
}

- (void)setupControls {
    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 20;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:mainStack];
    
    // 动画器选择
    UIView *animatorSection = [self createSectionWithTitle:@"动画器选择" control:self.animatorControl];
    [mainStack addArrangedSubview:animatorSection];
    
    // 动画时长
    UIView *durationSection = [self createSectionWithTitle:@"动画时长 (0.1s - 2.0s)" control:self.durationSlider];
    [mainStack addArrangedSubview:durationSection];
    
    // 背景点击
    UIView *backgroundSection = [self createSectionWithTitle:@"点击背景关闭" control:self.backgroundTapSwitch];
    [mainStack addArrangedSubview:backgroundSection];
    
    // 手势功能
    UIView *gestureSection = [self createSectionWithTitle:@"启用拖拽手势" control:self.gestureSwitch];
    [mainStack addArrangedSubview:gestureSection];
    
    // 主题选择
    UIView *themeSection = [self createSectionWithTitle:@"主题选择" control:self.themeControl];
    [mainStack addArrangedSubview:themeSection];
    
    // 统计信息
    UIView *statsView = [self createStatsView];
    [mainStack addArrangedSubview:statsView];
    
    [mainStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(20);
        make.left.right.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
}

- (UIView *)createSectionWithTitle:(NSString *)title control:(UIView *)control {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [[UIColor systemGrayColor] colorWithAlphaComponent:0.1];
    sectionView.layer.cornerRadius = 12;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [sectionView addSubview:titleLabel];
    
    control.translatesAutoresizingMaskIntoConstraints = NO;
    [sectionView addSubview:control];
    
    [NSLayoutConstraint activateConstraints:@[
        [sectionView.heightAnchor constraintEqualToConstant:80],
        [titleLabel.topAnchor constraintEqualToAnchor:sectionView.topAnchor constant:12],
        [titleLabel.leadingAnchor constraintEqualToAnchor:sectionView.leadingAnchor constant:16],
        [titleLabel.trailingAnchor constraintEqualToAnchor:sectionView.trailingAnchor constant:-16],
        [control.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8],
        [control.leadingAnchor constraintEqualToAnchor:sectionView.leadingAnchor constant:16],
        [control.trailingAnchor constraintEqualToAnchor:sectionView.trailingAnchor constant:-16],
        [control.bottomAnchor constraintEqualToAnchor:sectionView.bottomAnchor constant:-12]
    ]];
    
    return sectionView;
}

- (UIView *)createStatsView {
    UIView *statsView = [[UIView alloc] init];
    statsView.backgroundColor = [[UIColor systemTealColor] colorWithAlphaComponent:0.1];
    statsView.layer.cornerRadius = 12;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"📊 统计信息";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [statsView addSubview:titleLabel];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = [NSString stringWithFormat:@"当前弹窗数量：%ld", (long)TFYPopupGetCurrentCount()];
    countLabel.font = [UIFont systemFontOfSize:14];
    countLabel.textColor = [UIColor secondaryLabelColor];
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [statsView addSubview:countLabel];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"框架版本：%@", TFYPopupVersion];
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.textColor = [UIColor secondaryLabelColor];
    versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [statsView addSubview:versionLabel];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [clearButton setTitle:@"清空所有弹窗" forState:UIControlStateNormal];
    clearButton.backgroundColor = [UIColor systemRedColor];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    clearButton.layer.cornerRadius = 8;
    clearButton.translatesAutoresizingMaskIntoConstraints = NO;
    [statsView addSubview:clearButton];
    
    [clearButton addTarget:self action:@selector(clearAllPopups) forControlEvents:UIControlEventTouchUpInside];
    
    [NSLayoutConstraint activateConstraints:@[
        [statsView.heightAnchor constraintEqualToConstant:140],
        [titleLabel.topAnchor constraintEqualToAnchor:statsView.topAnchor constant:16],
        [titleLabel.leadingAnchor constraintEqualToAnchor:statsView.leadingAnchor constant:16],
        [countLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8],
        [countLabel.leadingAnchor constraintEqualToAnchor:statsView.leadingAnchor constant:16],
        [versionLabel.topAnchor constraintEqualToAnchor:countLabel.bottomAnchor constant:4],
        [versionLabel.leadingAnchor constraintEqualToAnchor:statsView.leadingAnchor constant:16],
        [clearButton.topAnchor constraintEqualToAnchor:versionLabel.bottomAnchor constant:12],
        [clearButton.leadingAnchor constraintEqualToAnchor:statsView.leadingAnchor constant:16],
        [clearButton.trailingAnchor constraintEqualToAnchor:statsView.trailingAnchor constant:-16],
        [clearButton.heightAnchor constraintEqualToConstant:36]
    ]];
    
    return statsView;
}

#pragma mark - Actions

- (void)previewPopup {
    // 根据当前配置创建弹窗
    UIView *contentView = [self createPreviewContentView];
    
    // 创建配置
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.dismissOnBackgroundTap = self.backgroundTapSwitch.isOn;
    config.enableDragToDismiss = self.gestureSwitch.isOn;
    config.animationDuration = self.durationSlider.value;
    
    // 设置主题
    switch (self.themeControl.selectedSegmentIndex) {
        case 0: config.theme = TFYPopupThemeDefault; break;
        case 1: config.theme = TFYPopupThemeLight; break;
        case 2: config.theme = TFYPopupThemeDark; break;
    }
    
    // 创建动画器
    id<TFYPopupViewAnimator> animator = [self createSelectedAnimator];
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:animator
                         animated:YES
                       completion:^{
        NSLog(@"实验场弹窗显示完成");
    }];
}

- (void)clearAllPopups {
    [TFYPopupView dismissAllAnimated:YES completion:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清空完成"
                                                                       message:@"所有弹窗已清空"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - Helper Methods

- (UIView *)createPreviewContentView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor systemBackgroundColor];
    view.layer.cornerRadius = 16;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"🧪 实验场预览";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:titleLabel];
    
    NSString *configText = [NSString stringWithFormat:@"动画器：%@\n时长：%.1fs\n背景点击：%@\n手势：%@\n主题：%@",
                           [self getSelectedAnimatorName],
                           self.durationSlider.value,
                           self.backgroundTapSwitch.isOn ? @"开启" : @"关闭",
                           self.gestureSwitch.isOn ? @"开启" : @"关闭",
                           [self getSelectedThemeName]];
    
    UILabel *configLabel = [[UILabel alloc] init];
    configLabel.text = configText;
    configLabel.font = [UIFont systemFontOfSize:14];
    configLabel.numberOfLines = 0;
    configLabel.textColor = [UIColor secondaryLabelColor];
    configLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:configLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor systemTealColor];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(closePreviewPopup:) forControlEvents:UIControlEventTouchUpInside];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:280],
        [view.heightAnchor constraintGreaterThanOrEqualToConstant:200],
        [titleLabel.topAnchor constraintEqualToAnchor:view.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20],
        [configLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [configLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [configLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20],
        [closeButton.topAnchor constraintEqualToAnchor:configLabel.bottomAnchor constant:16],
        [closeButton.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [closeButton.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20],
        [closeButton.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-20],
        [closeButton.heightAnchor constraintEqualToConstant:44]
    ]];
    
    return view;
}

- (id<TFYPopupViewAnimator>)createSelectedAnimator {
    switch (self.animatorControl.selectedSegmentIndex) {
        case 0: return [[TFYPopupFadeInOutAnimator alloc] init];
        case 1: return [[TFYPopupZoomInOutAnimator alloc] init];
        case 2: return [[TFYPopupSpringAnimator alloc] init];
        case 3: return [[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromBottom];
        default: return [[TFYPopupFadeInOutAnimator alloc] init];
    }
}

- (NSString *)getSelectedAnimatorName {
    NSArray *names = @[@"淡入淡出", @"缩放", @"弹簧", @"滑动"];
    return names[self.animatorControl.selectedSegmentIndex];
}

- (NSString *)getSelectedThemeName {
    NSArray *names = @[@"默认", @"浅色", @"深色"];
    return names[self.themeControl.selectedSegmentIndex];
}

- (void)closePreviewPopup:(UIButton *)sender {
    UIView *view = sender.superview;
    TFYPopupView *popup = [view findPopupView];
    if (popup) {
        [popup dismissAnimated:YES completion:nil];
    }
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UISegmentedControl *)animatorControl {
    if (!_animatorControl) {
        _animatorControl = [[UISegmentedControl alloc] initWithItems:@[@"淡入淡出", @"缩放", @"弹簧", @"滑动"]];
        _animatorControl.selectedSegmentIndex = 0;
    }
    return _animatorControl;
}

- (UISlider *)durationSlider {
    if (!_durationSlider) {
        _durationSlider = [[UISlider alloc] init];
        _durationSlider.minimumValue = 0.1;
        _durationSlider.maximumValue = 2.0;
        _durationSlider.value = 0.25;
    }
    return _durationSlider;
}

- (UISwitch *)backgroundTapSwitch {
    if (!_backgroundTapSwitch) {
        _backgroundTapSwitch = [[UISwitch alloc] init];
        _backgroundTapSwitch.on = YES;
    }
    return _backgroundTapSwitch;
}

- (UISwitch *)gestureSwitch {
    if (!_gestureSwitch) {
        _gestureSwitch = [[UISwitch alloc] init];
        _gestureSwitch.on = NO;
    }
    return _gestureSwitch;
}

- (UISegmentedControl *)themeControl {
    if (!_themeControl) {
        _themeControl = [[UISegmentedControl alloc] initWithItems:@[@"默认", @"浅色", @"深色"]];
        _themeControl.selectedSegmentIndex = 0;
    }
    return _themeControl;
}

@end
