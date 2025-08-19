//
//  TFYPopupComprehensiveViewController.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：综合演示控制器实现
//

#import "TFYPopupComprehensiveViewController.h"
#import "TFYPopup.h"
#import <Masonry/Masonry.h>

@interface TFYPopupComprehensiveViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TFYPopupComprehensiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"综合演示";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"清空"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(dismissAllPopups)];
    self.navigationItem.rightBarButtonItem = infoButton;
}

- (void)dismissAllPopups {
    [TFYPopupView dismissAllAnimated:YES completion:^{
        NSLog(@"已清空所有弹窗");
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSArray *titles = @[@"多层弹窗演示 🏗", @"链式调用演示 ⛓", @"复合动画演示 🎭", @"实时配置演示 ⚙️", @"性能测试 ⚡", @"错误处理演示 ⚠️"];
    NSArray *subtitles = @[@"展示多个弹窗叠加效果", @"演示弹窗的链式调用", @"多种动画组合使用", @"实时修改弹窗配置", @"大量弹窗性能测试", @"错误情况的处理方式"];
    
    cell.textLabel.text = titles[indexPath.row];
    cell.detailTextLabel.text = subtitles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: [self showMultiLayerDemo]; break;
        case 1: [self showChainedDemo]; break;
        case 2: [self showCompoundAnimationDemo]; break;
        case 3: [self showRealTimeConfigDemo]; break;
        case 4: [self showPerformanceTest]; break;
        case 5: [self showErrorHandlingDemo]; break;
    }
}

#pragma mark - Demo Methods

- (void)showMultiLayerDemo {
    // 第一层弹窗
    UIView *firstLayer = [self createLayerViewWithTitle:@"第一层弹窗" color:[UIColor systemBlueColor]];
    [TFYPopupView showContentView:firstLayer
                    configuration:[[TFYPopupViewConfiguration alloc] init]
                         animator:[[TFYPopupFadeInOutAnimator alloc] init]
                         animated:YES
                       completion:^{
        // 第二层弹窗
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIView *secondLayer = [self createLayerViewWithTitle:@"第二层弹窗" color:[UIColor systemGreenColor]];
            [TFYPopupView showContentView:secondLayer
                            configuration:[[TFYPopupViewConfiguration alloc] init]
                                 animator:[[TFYPopupZoomInOutAnimator alloc] init]
                                 animated:YES
                               completion:nil];
        });
    }];
}

- (void)showChainedDemo {
    UIView *contentView = [self createChainedContentView];
    [TFYPopupView showContentView:contentView
                    configuration:[[TFYPopupViewConfiguration alloc] init]
                         animator:[[TFYPopupSpringAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showCompoundAnimationDemo {
    // 使用多种动画组合
    UIView *contentView = [self createCompoundContentView];
    [TFYPopupView showContentView:contentView
                    configuration:[[TFYPopupViewConfiguration alloc] init]
                         animator:[[TFYPopupBounceAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showRealTimeConfigDemo {
    UIView *contentView = [self createConfigContentView];
    [TFYPopupView showContentView:contentView
                    configuration:[[TFYPopupViewConfiguration alloc] init]
                         animator:[[TFYPopupRotateAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

- (void)showPerformanceTest {
    // 快速创建多个弹窗进行性能测试
    for (int i = 0; i < 5; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIView *testView = [self createPerformanceTestView:i];
            [TFYPopupView showContentView:testView
                            configuration:[[TFYPopupViewConfiguration alloc] init]
                                 animator:[[TFYPopupSlideAnimator alloc] initWithDirection:i%4]
                                 animated:YES
                               completion:^{
                // 2秒后自动关闭
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSArray *popups = TFYPopupGetAllCurrentPopups();
                    if (popups.count > 0) {
                        [popups.lastObject dismissAnimated:YES completion:nil];
                    }
                });
            }];
        });
    }
}

- (void)showErrorHandlingDemo {
    UIView *errorView = [self createErrorHandlingView];
    [TFYPopupView showContentView:errorView
                    configuration:[[TFYPopupViewConfiguration alloc] init]
                         animator:[[TFYPopup3DFlipAnimator alloc] init]
                         animated:YES
                       completion:nil];
}

#pragma mark - Content View Creation

- (UIView *)createLayerViewWithTitle:(NSString *)title color:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor systemBackgroundColor];
    view.layer.cornerRadius = 12;
    view.layer.borderWidth = 2;
    view.layer.borderColor = color.CGColor;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:200],
        [view.heightAnchor constraintEqualToConstant:100],
        [label.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    
    return view;
}

- (UIView *)createChainedContentView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor systemBackgroundColor];
    view.layer.cornerRadius = 16;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"链式调用演示 ⛓";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:titleLabel];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [nextButton setTitle:@"下一个弹窗" forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor systemOrangeColor];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.layer.cornerRadius = 8;
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:nextButton];
    
    [nextButton addTarget:self action:@selector(showNextInChain) forControlEvents:UIControlEventTouchUpInside];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:250],
        [view.heightAnchor constraintEqualToConstant:150],
        [titleLabel.topAnchor constraintEqualToAnchor:view.topAnchor constant:20],
        [titleLabel.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [nextButton.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [nextButton.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
        [nextButton.widthAnchor constraintEqualToConstant:120],
        [nextButton.heightAnchor constraintEqualToConstant:40]
    ]];
    
    return view;
}

- (UIView *)createCompoundContentView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor systemBackgroundColor];
    view.layer.cornerRadius = 16;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"复合动画演示 🎭\n使用了弹跳动画器";
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:200],
        [view.heightAnchor constraintEqualToConstant:120],
        [label.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    
    return view;
}

- (UIView *)createConfigContentView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor systemBackgroundColor];
    view.layer.cornerRadius = 16;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"实时配置演示 ⚙️\n旋转动画效果";
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:200],
        [view.heightAnchor constraintEqualToConstant:120],
        [label.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    
    return view;
}

- (UIView *)createPerformanceTestView:(int)index {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor systemBackgroundColor];
    view.layer.cornerRadius = 12;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"性能测试 #%d", index + 1];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:150],
        [view.heightAnchor constraintEqualToConstant:80],
        [label.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    
    return view;
}

- (UIView *)createErrorHandlingView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor systemBackgroundColor];
    view.layer.cornerRadius = 16;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"错误处理演示 ⚠️\n3D翻转效果";
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:200],
        [view.heightAnchor constraintEqualToConstant:120],
        [label.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    
    return view;
}

- (void)showNextInChain {
    // 关闭当前弹窗并显示下一个
    NSArray *popups = TFYPopupGetAllCurrentPopups();
    if (popups.count > 0) {
        [popups.lastObject dismissAnimated:YES completion:^{
            UIView *nextView = [self createLayerViewWithTitle:@"链式下一个" color:[UIColor systemRedColor]];
            [TFYPopupView showContentView:nextView
                            configuration:[[TFYPopupViewConfiguration alloc] init]
                                 animator:[[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromLeft]
                                 animated:YES
                               completion:nil];
        }];
    }
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor systemBackgroundColor];
    }
    return _tableView;
}

@end
