//
//  TFYPopupConfigurationViewController.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：配置选项演示控制器实现
//

#import "TFYPopupConfigurationViewController.h"
#import "TFYPopup.h"
#import <Masonry/Masonry.h>

@interface TFYPopupConfigurationViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation TFYPopupConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"配置选项演示";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_greaterThanOrEqualTo(600);
    }];
    
    [self setupDemoButtons];
}

- (void)setupDemoButtons {
    NSArray *demos = @[
        @{@"title": @"键盘适配演示 ⌨️", @"selector": @"showKeyboardDemo"},
        @{@"title": @"主题配置演示 🎨", @"selector": @"showThemeDemo"},
        @{@"title": @"背景样式演示 🖼", @"selector": @"showBackgroundDemo"},
        @{@"title": @"阴影配置演示 🌟", @"selector": @"showShadowDemo"},
        @{@"title": @"手势配置演示 👆", @"selector": @"showGestureDemo"}
    ];
    
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 16;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:stackView];
    
    for (NSDictionary *demo in demos) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:demo[@"title"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.backgroundColor = [UIColor systemPurpleColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 8;
        
        SEL selector = NSSelectorFromString(demo[@"selector"]);
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        
        [stackView addArrangedSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
        }];
    }
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(20);
        make.left.right.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
}

#pragma mark - Demo Methods

- (void)showKeyboardDemo {
    UIView *formView = [self createFormView];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.keyboardConfiguration.isEnabled = YES;
    config.keyboardConfiguration.avoidingMode = TFYKeyboardAvoidingModeTransform;
    config.dismissOnBackgroundTap = YES;
    
    [TFYPopupView showContentView:formView
                    configuration:config
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showThemeDemo {
    UIView *contentView = [self createThemeContentView];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.theme = TFYPopupThemeCustom;
    config.customThemeBackgroundColor = [UIColor systemIndigoColor];
    config.customThemeTextColor = [UIColor whiteColor];
    config.customThemeCornerRadius = 20;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupFadeInOutAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showBackgroundDemo {
    UIView *contentView = [self createBackgroundContentView];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.backgroundStyle = TFYPopupBackgroundStyleBlur;
    config.blurStyle = UIBlurEffectStyleDark;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupZoomInOutAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showShadowDemo {
    UIView *contentView = [self createShadowContentView];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.containerConfiguration.shadowEnabled = YES;
    config.containerConfiguration.shadowColor = [UIColor redColor];
    config.containerConfiguration.shadowOpacity = 0.5;
    config.containerConfiguration.shadowRadius = 10;
    config.containerConfiguration.shadowOffset = CGSizeMake(0, 5);
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupBounceAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showGestureDemo {
    UIView *contentView = [self createGestureContentView];
    
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.enableDragToDismiss = YES;
    config.dragDismissThreshold = 0.3;
    
    [TFYPopupView showContentView:contentView
                    configuration:config
                         animator:[[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromBottom]
                         animated:YES
                       completion:nil];
}

#pragma mark - Content View Creation

- (UIView *)createFormView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor systemBackgroundColor];
    view.layer.cornerRadius = 16;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"键盘适配演示 ⌨️";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:titleLabel];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"点击输入，观察键盘适配效果";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:textField];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:300],
        [view.heightAnchor constraintEqualToConstant:150],
        [titleLabel.topAnchor constraintEqualToAnchor:view.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20],
        [textField.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:20],
        [textField.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [textField.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20]
    ]];
    
    return view;
}

- (UIView *)createThemeContentView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 16;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"自定义主题演示 🎨";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:titleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:280],
        [view.heightAnchor constraintEqualToConstant:120],
        [titleLabel.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    
    return view;
}

- (UIView *)createBackgroundContentView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    view.layer.cornerRadius = 16;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"模糊背景演示 🖼";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:titleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:280],
        [view.heightAnchor constraintEqualToConstant:120],
        [titleLabel.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    
    return view;
}

- (UIView *)createShadowContentView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor systemBackgroundColor];
    view.layer.cornerRadius = 16;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"阴影效果演示 🌟";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:titleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:280],
        [view.heightAnchor constraintEqualToConstant:120],
        [titleLabel.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    
    return view;
}

- (UIView *)createGestureContentView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor systemBackgroundColor];
    view.layer.cornerRadius = 16;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"手势交互演示 👆";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:titleLabel];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"可拖拽消失、滑动消失";
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor secondaryLabelColor];
    infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:infoLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:280],
        [view.heightAnchor constraintEqualToConstant:120],
        [titleLabel.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:view.centerYAnchor constant:-10],
        [infoLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:5],
        [infoLabel.centerXAnchor constraintEqualToAnchor:view.centerXAnchor]
    ]];
    
    return view;
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor systemBackgroundColor];
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

@end
