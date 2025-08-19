//
//  TFYPopupPriorityViewController.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗优先级功能演示控制器实现
//

#import "TFYPopupPriorityViewController.h"
#import "TFYPopup.h"
#import "TFYPopupAnimators.h"
#import "UIColor+TFY.h"
#import "Masonry.h"

@interface TFYPopupPriorityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *demoItems;

@end

@implementation TFYPopupPriorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优先级功能演示";
    
    [self setupDemoItems];
    [self setupUI];
    [self setupNavigationBar];
    
    // 启用优先级调试模式
    TFYPopupEnablePriorityDebugMode(YES);
}

- (void)setupDemoItems {
    self.demoItems = @[
        @{
            @"title": @"基础优先级演示",
            @"subtitle": @"演示不同优先级弹窗的显示顺序",
            @"action": @"showBasicPriorityDemo"
        },
        @{
            @"title": @"队列策略演示",
            @"subtitle": @"演示队列等待策略的工作方式",
            @"action": @"showQueueStrategyDemo"
        },
        @{
            @"title": @"替换策略演示",
            @"subtitle": @"演示高优先级替换低优先级",
            @"action": @"showReplaceStrategyDemo"
        },
        @{
            @"title": @"覆盖策略演示",
            @"subtitle": @"演示多层弹窗同时显示",
            @"action": @"showOverlayStrategyDemo"
        },
        @{
            @"title": @"拒绝策略演示",
            @"subtitle": @"演示拒绝低优先级弹窗",
            @"action": @"showRejectStrategyDemo"
        },
        @{
            @"title": @"紧急弹窗演示",
            @"subtitle": @"演示紧急优先级弹窗",
            @"action": @"showUrgentPopupDemo"
        },
        @{
            @"title": @"批量管理演示",
            @"subtitle": @"演示批量清理和队列管理",
            @"action": @"showBatchManagementDemo"
        },
        @{
            @"title": @"调试信息查看",
            @"subtitle": @"查看当前优先级队列状态",
            @"action": @"showDebugInfo"
        }
    ];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 80;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)setupNavigationBar {
    UIBarButtonItem *clearAllItem = [[UIBarButtonItem alloc] initWithTitle:@"清空所有"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(clearAllPopups)];
    
    UIBarButtonItem *debugItem = [[UIBarButtonItem alloc] initWithTitle:@"调试"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(showDebugInfo)];
    
    self.navigationItem.rightBarButtonItems = @[clearAllItem, debugItem];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DemoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *item = self.demoItems[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"subtitle"];
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = self.demoItems[indexPath.row];
    NSString *actionName = item[@"action"];
    
    SEL action = NSSelectorFromString(actionName);
    if ([self respondsToSelector:action]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:action];
        #pragma clang diagnostic pop
    }
}

#pragma mark - Demo Actions

- (void)showBasicPriorityDemo {
    [self showToast:@"即将显示不同优先级的弹窗，请观察显示顺序"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 先显示低优先级
        [self createDemoPopupWithTitle:@"低优先级弹窗"
                               message:@"这是一个低优先级弹窗"
                                 color:[UIColor systemBlueColor]
                              priority:TFYPopupPriorityLow
                              strategy:TFYPopupPriorityStrategyQueue];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 再显示高优先级
            [self createDemoPopupWithTitle:@"高优先级弹窗"
                                   message:@"这是一个高优先级弹窗，应该显示在前面"
                                     color:[UIColor systemRedColor]
                                  priority:TFYPopupPriorityHigh
                                  strategy:TFYPopupPriorityStrategyQueue];
        });
    });
}

- (void)showQueueStrategyDemo {
    [self showToast:@"演示队列策略：多个弹窗将按优先级排队显示"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 快速创建多个不同优先级的弹窗
        for (int i = 0; i < 5; i++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                TFYPopupPriority priority = (TFYPopupPriority)(TFYPopupPriorityLow + i * 100);
                UIColor *color = [self colorForPriority:priority];
                NSString *priorityName = [TFYPopupPriorityManager priorityDescription:priority];
                
                [self createDemoPopupWithTitle:[NSString stringWithFormat:@"弹窗 %d", i + 1]
                                       message:[NSString stringWithFormat:@"优先级：%@", priorityName]
                                         color:color
                                      priority:priority
                                      strategy:TFYPopupPriorityStrategyQueue];
            });
        }
    });
}

- (void)showReplaceStrategyDemo {
    [self showToast:@"演示替换策略：高优先级弹窗将替换低优先级"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 先显示低优先级弹窗
        [self createDemoPopupWithTitle:@"将被替换的弹窗"
                               message:@"这个弹窗将被高优先级弹窗替换"
                                 color:[UIColor systemGrayColor]
                              priority:TFYPopupPriorityLow
                              strategy:TFYPopupPriorityStrategyQueue];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 显示高优先级替换弹窗
            [self createDemoPopupWithTitle:@"替换者弹窗"
                                   message:@"我是高优先级，我要替换前面的弹窗！"
                                     color:[UIColor systemOrangeColor]
                                  priority:TFYPopupPriorityHigh
                                  strategy:TFYPopupPriorityStrategyReplace];
        });
    });
}

- (void)showOverlayStrategyDemo {
    [self showToast:@"演示覆盖策略：多个弹窗将同时显示"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 同时显示多个弹窗
        for (int i = 0; i < 3; i++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self createDemoPopupWithTitle:[NSString stringWithFormat:@"覆盖弹窗 %d", i + 1]
                                       message:@"使用覆盖策略，可以同时显示多个弹窗"
                                         color:[self randomColor]
                                      priority:TFYPopupPriorityNormal
                                      strategy:TFYPopupPriorityStrategyOverlay];
            });
        }
    });
}

- (void)showRejectStrategyDemo {
    [self showToast:@"演示拒绝策略：超出限制的弹窗将被拒绝"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 先显示一个占位弹窗
        [self createDemoPopupWithTitle:@"占位弹窗"
                               message:@"我先占着位置"
                                 color:[UIColor systemGreenColor]
                              priority:TFYPopupPriorityNormal
                              strategy:TFYPopupPriorityStrategyOverlay];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 尝试显示拒绝策略弹窗
            TFYPopupView *rejectedPopup = [self createDemoPopupWithTitle:@"被拒绝的弹窗"
                                                                 message:@"如果无法立即显示，我将被拒绝"
                                                                   color:[UIColor systemPurpleColor]
                                                                priority:TFYPopupPriorityLow
                                                                strategy:TFYPopupPriorityStrategyReject];
            
            if (!rejectedPopup) {
                [self showToast:@"弹窗被拒绝了！拒绝策略生效"];
            }
        });
    });
}

- (void)showUrgentPopupDemo {
    [self showToast:@"演示紧急弹窗：将立即显示并替换所有低优先级弹窗"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 先显示一些普通弹窗
        for (int i = 0; i < 3; i++) {
            [self createDemoPopupWithTitle:[NSString stringWithFormat:@"普通弹窗 %d", i + 1]
                                   message:@"我是普通优先级弹窗"
                                     color:[UIColor systemBlueColor]
                                  priority:TFYPopupPriorityNormal
                                  strategy:TFYPopupPriorityStrategyOverlay];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 显示紧急弹窗
            [TFYPopupView showContentView:[self createUrgentContentView]
                                 priority:TFYPopupPriorityUrgent
                                 strategy:TFYPopupPriorityStrategyReplace
                                 animated:YES
                               completion:^{
                NSLog(@"紧急弹窗显示完成");
            }];
        });
    });
}

- (void)showBatchManagementDemo {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"批量管理操作"
                                                                   message:@"请选择要执行的操作"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"清理低优先级弹窗"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        TFYPopupClearLowPriorityPopups(TFYPopupPriorityHigh);
        [self showToast:@"已清理所有低于高优先级的弹窗"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"暂停优先级队列"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        TFYPopupPausePriorityQueue();
        [self showToast:@"优先级队列已暂停"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"恢复优先级队列"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        TFYPopupResumePriorityQueue();
        [self showToast:@"优先级队列已恢复"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showDebugInfo {
    TFYPopupLogPriorityQueue();
    
    NSInteger currentCount = TFYPopupGetCurrentCount();
    NSInteger waitingCount = TFYPopupGetWaitingQueueCount();
    TFYPopupPriority highestPriority = TFYPopupGetCurrentHighestPriority();
    NSString *highestPriorityName = [TFYPopupPriorityManager priorityDescription:highestPriority];
    
    NSString *message = [NSString stringWithFormat:@"当前显示弹窗：%ld 个\n等待队列：%ld 个\n最高优先级：%@\n\n详细信息已输出到控制台",
                         (long)currentCount, (long)waitingCount, highestPriorityName];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"优先级队列调试信息"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clearAllPopups {
    [TFYPopupView dismissAllAnimated:YES completion:^{
        [self showToast:@"已清空所有弹窗"];
    }];
}

#pragma mark - Helper Methods

- (TFYPopupView *)createDemoPopupWithTitle:(NSString *)title
                                   message:(NSString *)message
                                     color:(UIColor *)color
                                  priority:(TFYPopupPriority)priority
                                  strategy:(TFYPopupPriorityStrategy)strategy {
    
    UIView *contentView = [self createContentViewWithTitle:title message:message color:color];
    
    return [TFYPopupView showContentView:contentView
                                priority:priority
                                strategy:strategy
                                animated:YES
                              completion:^{
        NSLog(@"弹窗显示完成: %@, 优先级: %@", title, [TFYPopupPriorityManager priorityDescription:priority]);
    }];
}

- (UIView *)createContentViewWithTitle:(NSString *)title message:(NSString *)message color:(UIColor *)color {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemBackgroundColor];
    containerView.layer.cornerRadius = 12;
    containerView.layer.masksToBounds = YES;
    
    // 顶部彩色条
    UIView *colorBar = [[UIView alloc] init];
    colorBar.backgroundColor = color;
    [containerView addSubview:colorBar];
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:titleLabel];
    
    // 消息标签
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor secondaryLabelColor];
    messageLabel.numberOfLines = 0;
    [containerView addSubview:messageLabel];
    
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.backgroundColor = color;
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 8;
    [containerView addSubview:closeButton];
    
    // 布局
    [colorBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(containerView);
        make.height.mas_equalTo(4);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(colorBar.mas_bottom).offset(20);
        make.left.right.equalTo(containerView).inset(20);
    }];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(containerView).inset(20);
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageLabel.mas_bottom).offset(20);
        make.left.right.equalTo(containerView).inset(20);
        make.bottom.equalTo(containerView).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(280);
    }];
    
    // 按钮点击事件
    [closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return containerView;
}

- (UIView *)createUrgentContentView {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor systemRedColor];
    containerView.layer.cornerRadius = 16;
    containerView.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"⚠️ 紧急通知";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:titleLabel];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = @"这是一个紧急优先级弹窗\n将立即显示并替换所有低优先级弹窗";
    messageLabel.font = [UIFont systemFontOfSize:16];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    [containerView addSubview:messageLabel];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [okButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor systemRedColor] forState:UIControlStateNormal];
    okButton.backgroundColor = [UIColor whiteColor];
    okButton.layer.cornerRadius = 8;
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [containerView addSubview:okButton];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(30);
        make.left.right.equalTo(containerView).inset(20);
    }];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.right.equalTo(containerView).inset(20);
    }];
    
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageLabel.mas_bottom).offset(25);
        make.left.right.equalTo(containerView).inset(20);
        make.bottom.equalTo(containerView).offset(-30);
        make.height.mas_equalTo(44);
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
    }];
    
    [okButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return containerView;
}

- (void)closeButtonTapped:(UIButton *)button {
    TFYPopupView *popupView = [button findPopupView];
    if (popupView) {
        [popupView dismissAnimated:YES completion:nil];
    }
}

- (UIColor *)colorForPriority:(TFYPopupPriority)priority {
    switch (priority) {
        case TFYPopupPriorityBackground:
            return [UIColor systemGrayColor];
        case TFYPopupPriorityLow:
            return [UIColor systemBlueColor];
        case TFYPopupPriorityNormal:
            return [UIColor systemGreenColor];
        case TFYPopupPriorityHigh:
            return [UIColor systemOrangeColor];
        case TFYPopupPriorityCritical:
            return [UIColor systemPurpleColor];
        case TFYPopupPriorityUrgent:
            return [UIColor systemRedColor];
        default:
            return [UIColor systemGrayColor];
    }
}

- (UIColor *)randomColor {
    NSArray *colors = @[
        [UIColor systemBlueColor],
        [UIColor systemGreenColor],
        [UIColor systemOrangeColor],
        [UIColor systemPurpleColor],
        [UIColor systemTealColor],
        [UIColor systemIndigoColor]
    ];
    
    return colors[arc4random_uniform((uint32_t)colors.count)];
}

- (void)showToast:(NSString *)message {
    UIAlertController *toast = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:toast animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [toast dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

@end
