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
        // === 基础演示 ===
        @{
            @"title": @"🎯 基础优先级演示",
            @"subtitle": @"演示不同优先级弹窗的显示顺序",
            @"action": @"showBasicPriorityDemo"
        },
        @{
            @"title": @"🔗 完整优先级链演示",
            @"subtitle": @"从背景级到紧急级的完整优先级链展示",
            @"action": @"showCompletePriorityChainDemo"
        },
        
        // === 策略演示 ===
        @{
            @"title": @"📋 队列策略演示",
            @"subtitle": @"演示队列等待策略的工作方式",
            @"action": @"showQueueStrategyDemo"
        },
        @{
            @"title": @"🔄 替换策略演示",
            @"subtitle": @"演示高优先级替换低优先级",
            @"action": @"showReplaceStrategyDemo"
        },
        @{
            @"title": @"📱 覆盖策略演示",
            @"subtitle": @"演示多层弹窗同时显示",
            @"action": @"showOverlayStrategyDemo"
        },
        @{
            @"title": @"🚫 拒绝策略演示",
            @"subtitle": @"演示拒绝低优先级弹窗",
            @"action": @"showRejectStrategyDemo"
        },
        @{
            @"title": @"🎭 混合策略演示",
            @"subtitle": @"同时使用不同策略的弹窗组合",
            @"action": @"showMixedStrategyDemo"
        },
        
        // === 高级功能演示 ===
        @{
            @"title": @"⚡ 优先级抢占演示",
            @"subtitle": @"展示更高优先级如何抢占当前显示",
            @"action": @"showPriorityPreemptionDemo"
        },
        @{
            @"title": @"⏰ 等待超时演示",
            @"subtitle": @"展示等待队列中弹窗的超时机制",
            @"action": @"showWaitingTimeoutDemo"
        },
        @{
            @"title": @"🔧 动态优先级调整",
            @"subtitle": @"运行时动态调整弹窗优先级",
            @"action": @"showDynamicPriorityDemo"
        },
        @{
            @"title": @"👑 继承优先级演示",
            @"subtitle": @"展示子弹窗继承父弹窗优先级",
            @"action": @"showPriorityInheritanceDemo"
        },
        
        // === 特殊场景演示 ===
        @{
            @"title": @"🚨 紧急弹窗演示",
            @"subtitle": @"演示紧急优先级弹窗",
            @"action": @"showUrgentPopupDemo"
        },
        @{
            @"title": @"💥 压力测试演示",
            @"subtitle": @"快速创建大量不同优先级弹窗",
            @"action": @"showStressTestDemo"
        },
        @{
            @"title": @"🎮 自定义优先级演示",
            @"subtitle": @"用户输入自定义优先级值测试",
            @"action": @"showCustomPriorityDemo"
        },
        @{
            @"title": @"📊 优先级回调演示",
            @"subtitle": @"展示优先级变化时的回调机制",
            @"action": @"showPriorityCallbackDemo"
        },
        
        // === 配置验证演示 ===
        @{
            @"title": @"⚙️ 默认配置优先级验证",
            @"subtitle": @"验证默认配置下的优先级功能",
            @"action": @"showDefaultConfigPriorityDemo"
        },
        @{
            @"title": @"🎨 自定义配置优先级验证",
            @"subtitle": @"验证自定义配置不被优先级覆盖",
            @"action": @"showCustomConfigPriorityDemo"
        },
        @{
            @"title": @"📐 容器尺寸优先级验证",
            @"subtitle": @"验证不同容器尺寸下的优先级显示",
            @"action": @"showContainerSizePriorityDemo"
        },
        @{
            @"title": @"🌈 主题配置优先级验证",
            @"subtitle": @"验证不同主题配置下的优先级功能",
            @"action": @"showThemeConfigPriorityDemo"
        },
        @{
            @"title": @"🔗 API方法对比验证",
            @"subtitle": @"对比不同API方法的优先级效果",
            @"action": @"showAPIMethodComparisonDemo"
        },
        
        // === 管理与统计 ===
        @{
            @"title": @"🗂️ 批量管理演示",
            @"subtitle": @"演示批量清理和队列管理",
            @"action": @"showBatchManagementDemo"
        },
        @{
            @"title": @"📈 优先级统计演示",
            @"subtitle": @"展示各优先级弹窗的统计信息",
            @"action": @"showPriorityStatisticsDemo"
        },
        @{
            @"title": @"🐞 调试信息查看",
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
    [self showToast:@"即将显示不同优先级的弹窗，观察高优先级如何替换低优先级"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 先添加低优先级弹窗（将立即显示）
        [self createDemoPopupWithTitle:@"第1步：低优先级弹窗"
                               message:@"我是低优先级，先显示出来"
                                 color:[UIColor systemBlueColor]
                              priority:TFYPopupPriorityLow
                              strategy:TFYPopupPriorityStrategyQueue];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 再添加高优先级弹窗（应该替换低优先级）
            [self createDemoPopupWithTitle:@"第2步：高优先级弹窗"
                                   message:@"我是高优先级，立即替换掉低优先级弹窗！"
                                     color:[UIColor systemRedColor]
                                  priority:TFYPopupPriorityHigh
                                  strategy:TFYPopupPriorityStrategyQueue];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 最后添加普通优先级弹窗（应该进入等待队列）
            [self createDemoPopupWithTitle:@"第3步：普通优先级弹窗"
                                   message:@"我是普通优先级，在队列中等待高优先级关闭后显示"
                                     color:[UIColor systemGreenColor]
                                  priority:TFYPopupPriorityNormal
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
    
    // 临时增加最大同时显示数量以演示覆盖效果
    TFYPopupPriorityManager *manager = [TFYPopupPriorityManager sharedManager];
    NSInteger originalMaxCount = manager.maxSimultaneousPopups;
    manager.maxSimultaneousPopups = 3;
    
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
        
        // 5秒后恢复原始设置
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            manager.maxSimultaneousPopups = originalMaxCount;
        });
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
           [self createDemoPopupWithTitle:@"被拒绝的弹窗"
                                                                 message:@"如果无法立即显示，我将被拒绝"
                                                                   color:[UIColor systemPurpleColor]
                                                                priority:TFYPopupPriorityLow
                                                                strategy:TFYPopupPriorityStrategyReject];
            

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
            [TFYPopupView showContentViewWithPriority:[self createUrgentContentView] priority:TFYPopupPriorityUrgent strategy:TFYPopupPriorityStrategyReplace animated:YES completion:^(TFYPopupView * _Nullable pop) {
                
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
    [TFYPopupView dismissAllAnimated:YES completion:^ {
        [self showToast:@"已清空所有弹窗"];
    }];
}

#pragma mark - Helper Methods

- (void)createDemoPopupWithTitle:(NSString *)title
                                   message:(NSString *)message
                                     color:(UIColor *)color
                                  priority:(TFYPopupPriority)priority
                                  strategy:(TFYPopupPriorityStrategy)strategy {
    
    UIView *contentView = [self createContentViewWithTitle:title message:message color:color];
    
    [TFYPopupView showContentViewWithPriority:contentView priority:priority strategy:strategy animated:YES completion:^(TFYPopupView * _Nullable pop) {
        
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

#pragma mark - 新增演示功能

// MARK: - 完整优先级链演示
- (void)showCompletePriorityChainDemo {
    [self showToast:@"完整优先级链演示：从背景级到紧急级，观察显示顺序"];
    
    // 设置为多弹窗显示模式
    TFYPopupPriorityManager *manager = [TFYPopupPriorityManager sharedManager];
    NSInteger originalMaxCount = manager.maxSimultaneousPopups;
    manager.maxSimultaneousPopups = 6;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *priorities = @[
            @(TFYPopupPriorityBackground),
            @(TFYPopupPriorityLow),
            @(TFYPopupPriorityNormal),
            @(TFYPopupPriorityHigh),
            @(TFYPopupPriorityCritical),
            @(TFYPopupPriorityUrgent)
        ];
        
        // 倒序添加，观察优先级排序效果
        for (NSInteger i = priorities.count - 1; i >= 0; i--) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((5 - i) * 0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                TFYPopupPriority priority = [priorities[i] integerValue];
                NSString *priorityName = [TFYPopupPriorityManager priorityDescription:priority];
                
                [self createDemoPopupWithTitle:[NSString stringWithFormat:@"优先级:%@", priorityName]
                                       message:[NSString stringWithFormat:@"数值:%ld\n顺序应该按优先级高低排列", (long)priority]
                                         color:[self colorForPriority:priority]
                                      priority:priority
                                      strategy:TFYPopupPriorityStrategyOverlay];
            });
        }
        
        // 3秒后恢复原设置
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            manager.maxSimultaneousPopups = originalMaxCount;
        });
    });
}

// MARK: - 混合策略演示
- (void)showMixedStrategyDemo {
    [self showToast:@"混合策略演示：同时使用不同策略的弹窗组合"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1. 队列策略 - 低优先级
        [self createDemoPopupWithTitle:@"队列策略-低优先级"
                               message:@"我使用队列策略，会被高优先级替换"
                                 color:[UIColor systemBlueColor]
                              priority:TFYPopupPriorityLow
                              strategy:TFYPopupPriorityStrategyQueue];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 2. 替换策略 - 高优先级
            [self createDemoPopupWithTitle:@"替换策略-高优先级"
                                   message:@"我使用替换策略，会替换低优先级弹窗"
                                     color:[UIColor systemOrangeColor]
                                  priority:TFYPopupPriorityHigh
                                  strategy:TFYPopupPriorityStrategyReplace];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 3. 覆盖策略 - 普通优先级
            [self createDemoPopupWithTitle:@"覆盖策略-普通优先级"
                                   message:@"我使用覆盖策略，会叠加显示"
                                     color:[UIColor systemGreenColor]
                                  priority:TFYPopupPriorityNormal
                                  strategy:TFYPopupPriorityStrategyOverlay];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 4. 拒绝策略 - 低优先级（应该被拒绝）
            [self createDemoPopupWithTitle:@"拒绝策略-低优先级"
                                                                 message:@"我使用拒绝策略，会被拒绝显示"
                                                                   color:[UIColor systemGrayColor]
                                                                priority:TFYPopupPriorityLow
                                                                strategy:TFYPopupPriorityStrategyReject];
            
        });
    });
}

// MARK: - 优先级抢占演示
- (void)showPriorityPreemptionDemo {
    [self showToast:@"优先级抢占演示：观察更高优先级如何抢占当前显示"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 创建一个长时间显示的低优先级弹窗
        [self createDemoPopupWithTitle:@"被抢占者"
                                                                message:@"我是低优先级，正在显示中...\n即将被更高优先级抢占"
                                                                  color:[UIColor systemBlueColor]
                                                               priority:TFYPopupPriorityLow
                                                               strategy:TFYPopupPriorityStrategyQueue];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 中优先级抢占
            [self createDemoPopupWithTitle:@"第一次抢占"
                                   message:@"我是普通优先级，抢占了低优先级"
                                     color:[UIColor systemGreenColor]
                                  priority:TFYPopupPriorityNormal
                                  strategy:TFYPopupPriorityStrategyQueue];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 高优先级抢占
            [self createDemoPopupWithTitle:@"第二次抢占"
                                   message:@"我是高优先级，抢占了普通优先级"
                                     color:[UIColor systemOrangeColor]
                                  priority:TFYPopupPriorityHigh
                                  strategy:TFYPopupPriorityStrategyQueue];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 紧急优先级最终抢占
            [self createDemoPopupWithTitle:@"最终抢占"
                                   message:@"我是紧急优先级，抢占了所有其他弹窗！"
                                     color:[UIColor systemRedColor]
                                  priority:TFYPopupPriorityUrgent
                                  strategy:TFYPopupPriorityStrategyQueue];
        });
    });
}

// MARK: - 等待超时演示
- (void)showWaitingTimeoutDemo {
    [self showToast:@"等待超时演示：设置短超时时间，观察弹窗过期"];
    
    // 临时设置短超时时间
    TFYPopupPriorityManager *manager = [TFYPopupPriorityManager sharedManager];
    NSTimeInterval originalTimeout = manager.defaultMaxWaitingTime;
    manager.defaultMaxWaitingTime = 3.0; // 3秒超时
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 占位弹窗
        [self createDemoPopupWithTitle:@"占位弹窗"
                               message:@"我先占着位置，阻止其他弹窗显示"
                                 color:[UIColor systemPurpleColor]
                              priority:TFYPopupPriorityHigh
                              strategy:TFYPopupPriorityStrategyQueue];
        
        // 创建多个会超时的弹窗
        for (int i = 1; i <= 3; i++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self createDemoPopupWithTitle:[NSString stringWithFormat:@"超时弹窗 %d", i]
                                       message:@"我将在3秒后超时消失"
                                         color:[UIColor systemGrayColor]
                                      priority:TFYPopupPriorityNormal
                                      strategy:TFYPopupPriorityStrategyQueue];
            });
        }
        
        // 恢复超时设置
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            manager.defaultMaxWaitingTime = originalTimeout;
            [self showToast:@"超时设置已恢复"];
        });
    });
}

// MARK: - 动态优先级调整演示
- (void)showDynamicPriorityDemo {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"动态优先级调整"
                                                                   message:@"选择要调整的优先级方向"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"优先级升级演示"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [self showPriorityUpgradeDemo];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"优先级降级演示"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [self showPriorityDowngradeDemo];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"随机优先级变化"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [self showRandomPriorityChangeDemo];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showPriorityUpgradeDemo {
    [self showToast:@"优先级升级演示：低优先级弹窗将逐步升级"];
    
    // 注意：当前架构不支持动态调整优先级，这里演示概念
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createDemoPopupWithTitle:@"动态升级弹窗"
                               message:@"概念演示：我会从低优先级升级到高优先级\n（实际需要重新创建弹窗）"
                                 color:[UIColor systemBlueColor]
                              priority:TFYPopupPriorityLow
                              strategy:TFYPopupPriorityStrategyQueue];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToast:@"模拟升级：重新创建高优先级弹窗"];
            
            [self createDemoPopupWithTitle:@"升级后弹窗"
                                   message:@"我已升级为高优先级！"
                                     color:[UIColor systemOrangeColor]
                                  priority:TFYPopupPriorityHigh
                                  strategy:TFYPopupPriorityStrategyReplace];
        });
    });
}

- (void)showPriorityDowngradeDemo {
    [self showToast:@"优先级降级演示：高优先级弹窗将被降级"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createDemoPopupWithTitle:@"即将降级弹窗"
                               message:@"我是高优先级，但即将被降级"
                                 color:[UIColor systemOrangeColor]
                              priority:TFYPopupPriorityHigh
                              strategy:TFYPopupPriorityStrategyQueue];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToast:@"模拟降级：重新创建低优先级弹窗"];
            
            [self createDemoPopupWithTitle:@"降级后弹窗"
                                   message:@"我已被降级为低优先级"
                                     color:[UIColor systemBlueColor]
                                  priority:TFYPopupPriorityLow
                                  strategy:TFYPopupPriorityStrategyQueue];
        });
    });
}

- (void)showRandomPriorityChangeDemo {
    [self showToast:@"随机优先级变化：每秒创建随机优先级弹窗"];
    
    for (int i = 0; i < 5; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            TFYPopupPriority randomPriority = [self randomPriority];
            NSString *priorityName = [TFYPopupPriorityManager priorityDescription:randomPriority];
            
            [self createDemoPopupWithTitle:[NSString stringWithFormat:@"随机弹窗 %d", i + 1]
                                   message:[NSString stringWithFormat:@"随机优先级：%@", priorityName]
                                     color:[self colorForPriority:randomPriority]
                                  priority:randomPriority
                                  strategy:TFYPopupPriorityStrategyQueue];
        });
    }
}

// MARK: - 继承优先级演示
- (void)showPriorityInheritanceDemo {
    [self showToast:@"优先级继承演示：子弹窗继承父弹窗优先级"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 父弹窗
        [self createDemoPopupWithTitle:@"父弹窗"
                                                           message:@"我是父弹窗，高优先级\n点击按钮创建子弹窗"
                                                             color:[UIColor systemOrangeColor]
                                                          priority:TFYPopupPriorityHigh
                                                          strategy:TFYPopupPriorityStrategyQueue];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 模拟子弹窗（继承父弹窗优先级）
            [self createDemoPopupWithTitle:@"子弹窗"
                                   message:@"我是子弹窗，继承了父弹窗的高优先级"
                                     color:[UIColor systemOrangeColor]
                                  priority:TFYPopupPriorityHigh
                                  strategy:TFYPopupPriorityStrategyOverlay];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 孙弹窗
            [self createDemoPopupWithTitle:@"孙弹窗"
                                   message:@"我是孙弹窗，也继承了高优先级"
                                     color:[UIColor systemOrangeColor]
                                  priority:TFYPopupPriorityHigh
                                  strategy:TFYPopupPriorityStrategyOverlay];
        });
    });
}

// MARK: - 压力测试演示
- (void)showStressTestDemo {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"压力测试"
                                                                   message:@"选择测试强度"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"轻度测试 (10个弹窗)"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [self performStressTestWithCount:10];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"中度测试 (30个弹窗)"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [self performStressTestWithCount:30];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"重度测试 (50个弹窗)"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [self performStressTestWithCount:50];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)performStressTestWithCount:(NSInteger)count {
    [self showToast:[NSString stringWithFormat:@"压力测试开始：将创建%ld个弹窗", (long)count]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < count; i++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                TFYPopupPriority randomPriority = [self randomPriority];
                TFYPopupPriorityStrategy randomStrategy = [self randomStrategy];
                
                [self createDemoPopupWithTitle:[NSString stringWithFormat:@"测试弹窗 %ld", (long)i + 1]
                                       message:[NSString stringWithFormat:@"优先级：%@\n策略：%@", 
                                               [TFYPopupPriorityManager priorityDescription:randomPriority],
                                               [TFYPopupPriorityManager strategyDescription:randomStrategy]]
                                         color:[self colorForPriority:randomPriority]
                                      priority:randomPriority
                                      strategy:randomStrategy];
            });
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(count * 0.1 + 2.0) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self showToast:@"压力测试完成！"];
        });
    });
}

// MARK: - 自定义优先级演示
- (void)showCustomPriorityDemo {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自定义优先级"
                                                                   message:@"输入自定义优先级值 (0-500)"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"输入优先级数值";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text = @"250";
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"创建弹窗"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        NSInteger customValue = [textField.text integerValue];
        
        if (customValue < 0) customValue = 0;
        if (customValue > 500) customValue = 500;
        
        TFYPopupPriority customPriority = (TFYPopupPriority)customValue;
        
        [self createDemoPopupWithTitle:@"自定义优先级弹窗"
                               message:[NSString stringWithFormat:@"自定义优先级值：%ld", (long)customValue]
                                 color:[self colorForPriority:customPriority]
                              priority:customPriority
                              strategy:TFYPopupPriorityStrategyQueue];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// MARK: - 优先级回调演示
- (void)showPriorityCallbackDemo {
    [self showToast:@"优先级回调演示：监听优先级变化事件"];
    
    // 监听优先级变化通知
    __weak typeof(self) weakSelf = self;
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:TFYPopupPriorityDidChangeNotification
                                                                    object:nil
                                                                     queue:[NSOperationQueue mainQueue]
                                                                usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            TFYPopupPriority currentHighest = TFYPopupGetCurrentHighestPriority();
            NSString *priorityName = [TFYPopupPriorityManager priorityDescription:currentHighest];
            
            UIAlertController *callbackAlert = [UIAlertController alertControllerWithTitle:@"优先级变化回调"
                                                                                   message:[NSString stringWithFormat:@"当前最高优先级：%@", priorityName]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
            
            [callbackAlert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil]];
            
            [strongSelf presentViewController:callbackAlert animated:YES completion:nil];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 创建几个不同优先级的弹窗来触发回调
        [self createDemoPopupWithTitle:@"回调测试 1"
                               message:@"低优先级弹窗"
                                 color:[UIColor systemBlueColor]
                              priority:TFYPopupPriorityLow
                              strategy:TFYPopupPriorityStrategyQueue];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createDemoPopupWithTitle:@"回调测试 2"
                                   message:@"高优先级弹窗"
                                     color:[UIColor systemOrangeColor]
                                  priority:TFYPopupPriorityHigh
                                  strategy:TFYPopupPriorityStrategyQueue];
        });
        
        // 5秒后移除观察者
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
            [self showToast:@"回调监听已停止"];
        });
    });
}

// MARK: - 优先级统计演示
- (void)showPriorityStatisticsDemo {
    // 收集统计信息
    NSInteger totalCount = TFYPopupGetCurrentCount();
    NSInteger waitingCount = TFYPopupGetWaitingQueueCount();
    TFYPopupPriority highestPriority = TFYPopupGetCurrentHighestPriority();
    
    // 按优先级统计
    NSMutableString *statistics = [NSMutableString stringWithFormat:@"📊 弹窗统计信息\n\n"];
    [statistics appendFormat:@"当前显示弹窗：%ld 个\n", (long)totalCount];
    [statistics appendFormat:@"等待队列弹窗：%ld 个\n", (long)waitingCount];
    [statistics appendFormat:@"最高优先级：%@\n\n", [TFYPopupPriorityManager priorityDescription:highestPriority]];
    
    [statistics appendString:@"各优先级分布：\n"];
    
    NSArray *allPriorities = @[
        @(TFYPopupPriorityBackground),
        @(TFYPopupPriorityLow),
        @(TFYPopupPriorityNormal),
        @(TFYPopupPriorityHigh),
        @(TFYPopupPriorityCritical),
        @(TFYPopupPriorityUrgent)
    ];
    
    for (NSNumber *priorityNum in allPriorities) {
        TFYPopupPriority priority = [priorityNum integerValue];
        NSArray *popupsWithPriority = [TFYPopupView popupsWithPriority:priority];
        NSString *priorityName = [TFYPopupPriorityManager priorityDescription:priority];
        [statistics appendFormat:@"• %@：%ld 个\n", priorityName, (long)popupsWithPriority.count];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"优先级统计"
                                                                   message:statistics
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"刷新统计"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [self showPriorityStatisticsDemo];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 辅助方法

- (TFYPopupPriority)randomPriority {
    NSArray *priorities = @[
        @(TFYPopupPriorityBackground),
        @(TFYPopupPriorityLow),
        @(TFYPopupPriorityNormal),
        @(TFYPopupPriorityHigh),
        @(TFYPopupPriorityCritical),
        @(TFYPopupPriorityUrgent)
    ];
    
    NSInteger randomIndex = arc4random_uniform((uint32_t)priorities.count);
    return [priorities[randomIndex] integerValue];
}

- (TFYPopupPriorityStrategy)randomStrategy {
    NSArray *strategies = @[
        @(TFYPopupPriorityStrategyQueue),
        @(TFYPopupPriorityStrategyReplace),
        @(TFYPopupPriorityStrategyOverlay),
        @(TFYPopupPriorityStrategyReject)
    ];
    
    NSInteger randomIndex = arc4random_uniform((uint32_t)strategies.count);
    return [strategies[randomIndex] integerValue];
}

#pragma mark - 配置验证演示

// MARK: - 默认配置优先级验证
- (void)showDefaultConfigPriorityDemo {
    [self showToast:@"验证使用默认配置的优先级功能"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 使用默认配置的优先级方法
        UILabel *lowPriorityLabel = [self createDemoLabel:@"低优先级弹窗\n(默认配置)" color:[UIColor systemBlueColor]];
        
        [TFYPopupView showContentViewWithPriority:lowPriorityLabel priority:TFYPopupPriorityLow strategy:TFYPopupPriorityStrategyQueue animated:YES completion:^(TFYPopupView * _Nullable pop) {
            
        }];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UILabel *highPriorityLabel = [self createDemoLabel:@"高优先级弹窗\n(默认配置)" color:[UIColor systemRedColor]];
            
            [TFYPopupView showContentViewWithPriority:highPriorityLabel priority:TFYPopupPriorityHigh strategy:TFYPopupPriorityStrategyQueue animated:YES completion:^(TFYPopupView * _Nullable pop) {
                
            }];
        });
    });
}

// MARK: - 自定义配置优先级验证
- (void)showCustomConfigPriorityDemo {
    [self showToast:@"验证自定义配置不被优先级功能覆盖"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 创建自定义配置
        TFYPopupViewConfiguration *customConfig = [[TFYPopupViewConfiguration alloc] init];
        customConfig.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.6];
        customConfig.animationDuration = 0.8;
        customConfig.cornerRadius = 20;
        customConfig.dismissOnBackgroundTap = NO; // 禁用背景点击消失
        
        UILabel *lowLabel = [self createDemoLabel:@"低优先级\n(自定义配置)\n紫色背景\n长动画时间\n大圆角" color:[UIColor whiteColor]];
        lowLabel.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.8];
        
        // 使用基础配置和自定义动画器的优先级方法
        TFYPopupFadeInOutAnimator *customAnimator1 = [[TFYPopupFadeInOutAnimator alloc] init];
        customAnimator1.displayDuration = 0.8; // 与配置的动画时间匹配
        customAnimator1.dismissDuration = 0.8;
        
        [TFYPopupView showContentViewWithPriority:lowLabel
                    baseConfiguration:customConfig
                             animator:customAnimator1
                             priority:TFYPopupPriorityLow
                             strategy:TFYPopupPriorityStrategyQueue
                             animated:YES
                                       completion:^(TFYPopupView * _Nullable pop) {
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 另一种自定义配置
            TFYPopupViewConfiguration *anotherConfig = [[TFYPopupViewConfiguration alloc] init];
            anotherConfig.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.7];
            anotherConfig.animationDuration = 0.3; // 短动画时间
            anotherConfig.cornerRadius = 15;
            anotherConfig.enableHapticFeedback = NO; // 禁用触觉反馈
            
            UILabel *highLabel = [self createDemoLabel:@"高优先级\n(另一个自定义配置)\n橙色背景\n短动画时间\n中等圆角" color:[UIColor whiteColor]];
            highLabel.backgroundColor = [[UIColor systemRedColor] colorWithAlphaComponent:0.8];
            
            // 创建短动画时间的动画器
            TFYPopupFadeInOutAnimator *customAnimator2 = [[TFYPopupFadeInOutAnimator alloc] init];
            customAnimator2.displayDuration = 0.3; // 与配置的动画时间匹配
            customAnimator2.dismissDuration = 0.3;
            
            [TFYPopupView showContentViewWithPriority:highLabel
                        baseConfiguration:anotherConfig
                                 animator:customAnimator2
                                 priority:TFYPopupPriorityHigh
                                 strategy:TFYPopupPriorityStrategyQueue
                                 animated:YES
                                           completion:^(TFYPopupView * _Nullable pop) {
                
            }];
        });
    });
}

// MARK: - 容器尺寸优先级验证
- (void)showContainerSizePriorityDemo {
    [self showToast:@"验证不同容器尺寸下的优先级显示效果"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 小尺寸容器配置
        TFYPopupViewConfiguration *smallConfig = [[TFYPopupViewConfiguration alloc] init];
        smallConfig.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.5];
        
        // 配置小尺寸容器
        TFYPopupContainerConfiguration *smallContainer = [[TFYPopupContainerConfiguration alloc] init];
        smallContainer.width = [TFYPopupContainerDimension fixed:200];
        smallContainer.height = [TFYPopupContainerDimension fixed:150];
        smallContainer.cornerRadius = 10;
        smallContainer.shadowEnabled = YES;
        smallContainer.shadowColor = [UIColor blackColor];
        smallContainer.shadowOpacity = 0.3;
        smallContainer.shadowRadius = 5;
        smallConfig.containerConfiguration = smallContainer;
        
        UILabel *smallLabel = [self createDemoLabel:@"小容器\n低优先级" color:[UIColor whiteColor]];
        smallLabel.backgroundColor = [UIColor systemBlueColor];
        
        // 为小容器创建快速动画器
        TFYPopupFadeInOutAnimator *smallAnimator = [[TFYPopupFadeInOutAnimator alloc] init];
        smallAnimator.displayDuration = 0.4;
        smallAnimator.dismissDuration = 0.4;
        
        [TFYPopupView showContentViewWithPriority:smallLabel
                    baseConfiguration:smallConfig
                             animator:smallAnimator
                             priority:TFYPopupPriorityLow
                             strategy:TFYPopupPriorityStrategyQueue
                             animated:YES
                                       completion:^(TFYPopupView * _Nullable pop) {
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 大尺寸容器配置
            TFYPopupViewConfiguration *largeConfig = [[TFYPopupViewConfiguration alloc] init];
            largeConfig.backgroundColor = [[UIColor systemRedColor] colorWithAlphaComponent:0.5];
            
            // 配置大尺寸容器
            TFYPopupContainerConfiguration *largeContainer = [[TFYPopupContainerConfiguration alloc] init];
            largeContainer.width = [TFYPopupContainerDimension ratio:0.8];
            largeContainer.height = [TFYPopupContainerDimension fixed:300];
            largeContainer.cornerRadius = 25;
            largeContainer.shadowEnabled = YES;
            largeContainer.shadowColor = [UIColor redColor];
            largeContainer.shadowOpacity = 0.5;
            largeContainer.shadowRadius = 10;
            largeConfig.containerConfiguration = largeContainer;
            
            UILabel *largeLabel = [self createDemoLabel:@"大容器\n高优先级\n\n应该替换小容器弹窗\n并显示在前面" color:[UIColor whiteColor]];
            largeLabel.backgroundColor = [UIColor systemRedColor];
            largeLabel.numberOfLines = 0;
            
            // 为大容器创建慢速动画器，展示更丰富的效果
            TFYPopupFadeInOutAnimator *largeAnimator = [[TFYPopupFadeInOutAnimator alloc] init];
            largeAnimator.displayDuration = 0.6;
            largeAnimator.dismissDuration = 0.6;
            
            [TFYPopupView showContentViewWithPriority:largeLabel
                        baseConfiguration:largeConfig
                                 animator:largeAnimator
                                 priority:TFYPopupPriorityHigh
                                 strategy:TFYPopupPriorityStrategyQueue
                                 animated:YES
                                           completion:^(TFYPopupView * _Nullable pop) {
                
            }];
        });
    });
}

// MARK: - 主题配置优先级验证
- (void)showThemeConfigPriorityDemo {
    [self showToast:@"验证不同主题配置下的优先级功能"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 深色主题配置
        TFYPopupViewConfiguration *darkConfig = [[TFYPopupViewConfiguration alloc] init];
        darkConfig.theme = TFYPopupThemeDark;
        darkConfig.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        darkConfig.cornerRadius = 15;
        
        UILabel *darkLabel = [self createDemoLabel:@"深色主题\n普通优先级" color:[UIColor whiteColor]];
        darkLabel.backgroundColor = [UIColor darkGrayColor];
        
        // 使用默认动画器（传nil让系统选择）
        [TFYPopupView showContentViewWithPriority:darkLabel
                    baseConfiguration:darkConfig
                             animator:nil  // nil = 使用默认动画器
                             priority:TFYPopupPriorityNormal
                             strategy:TFYPopupPriorityStrategyQueue
                             animated:YES
                                       completion:^(TFYPopupView * _Nullable pop) {
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 浅色主题配置
            TFYPopupViewConfiguration *lightConfig = [[TFYPopupViewConfiguration alloc] init];
            lightConfig.theme = TFYPopupThemeLight;
            lightConfig.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
            lightConfig.cornerRadius = 12;
            
            UILabel *lightLabel = [self createDemoLabel:@"浅色主题\n高优先级" color:[UIColor blackColor]];
            lightLabel.backgroundColor = [UIColor lightGrayColor];
            
            // 为浅色主题创建快速动画器
            TFYPopupFadeInOutAnimator *lightAnimator = [[TFYPopupFadeInOutAnimator alloc] init];
            lightAnimator.displayDuration = 0.25;
            lightAnimator.dismissDuration = 0.25;
            
            [TFYPopupView showContentViewWithPriority:lightLabel
                        baseConfiguration:lightConfig
                                 animator:lightAnimator
                                 priority:TFYPopupPriorityHigh
                                 strategy:TFYPopupPriorityStrategyQueue
                                 animated:YES
                                           completion:^(TFYPopupView * _Nullable pop) {
                
            }];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 自定义主题配置
            TFYPopupViewConfiguration *customConfig = [[TFYPopupViewConfiguration alloc] init];
            customConfig.theme = TFYPopupThemeCustom;
            customConfig.customThemeBackgroundColor = [[UIColor systemPurpleColor] colorWithAlphaComponent:0.9];
            customConfig.customThemeCornerRadius = 20;
            customConfig.backgroundColor = [[UIColor systemPurpleColor] colorWithAlphaComponent:0.7];
            
            UILabel *customLabel = [self createDemoLabel:@"自定义主题\n紧急优先级\n\n应该立即显示" color:[UIColor whiteColor]];
            customLabel.backgroundColor = [UIColor systemPurpleColor];
            customLabel.numberOfLines = 0;
            
            // 为自定义主题创建华丽的慢速动画器
            TFYPopupFadeInOutAnimator *customAnimator = [[TFYPopupFadeInOutAnimator alloc] init];
            customAnimator.displayDuration = 0.7;
            customAnimator.dismissDuration = 0.7;
            
            [TFYPopupView showContentViewWithPriority:customLabel
                        baseConfiguration:customConfig
                                 animator:customAnimator
                                 priority:TFYPopupPriorityCritical
                                 strategy:TFYPopupPriorityStrategyQueue
                                 animated:YES
                                           completion:^(TFYPopupView * _Nullable pop) {
                
            }];
        });
    });
}

// MARK: - API方法对比验证
- (void)showAPIMethodComparisonDemo {
    [self showToast:@"对比不同API方法的优先级效果\n展示完全的用户自定义能力"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 方法1：使用默认配置的优先级方法
        // 适用场景：快速使用，不需要特殊配置
        UILabel *method1Label = [self createDemoLabel:@"方法1\n默认配置API\n低优先级\n(配置+动画器都默认)" color:[UIColor whiteColor]];
        method1Label.backgroundColor = [UIColor systemBlueColor];
        
        [TFYPopupView showContentViewWithPriority:method1Label
                             priority:TFYPopupPriorityLow
                             strategy:TFYPopupPriorityStrategyQueue
                             animated:YES
                                       completion:^(TFYPopupView * _Nullable pop) {
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 方法2：使用基础配置 + 自定义动画器的优先级方法
            // 适用场景：需要自定义配置和动画效果
            TFYPopupViewConfiguration *baseConfig = [[TFYPopupViewConfiguration alloc] init];
            baseConfig.backgroundColor = [[UIColor systemOrangeColor] colorWithAlphaComponent:0.7];
            baseConfig.animationDuration = 0.5;
            baseConfig.cornerRadius = 15;
            
            UILabel *method2Label = [self createDemoLabel:@"方法2\n基础配置+动画器API\n普通优先级\n(用户完全自定义)" color:[UIColor whiteColor]];
            method2Label.backgroundColor = [UIColor systemOrangeColor];
            
            // 为方法2创建中等速度的动画器
            TFYPopupFadeInOutAnimator *method2Animator = [[TFYPopupFadeInOutAnimator alloc] init];
            method2Animator.displayDuration = 0.5; // 与配置的动画时间匹配
            method2Animator.dismissDuration = 0.5;
            
            [TFYPopupView showContentViewWithPriority:method2Label
                        baseConfiguration:baseConfig
                                 animator:method2Animator
                                 priority:TFYPopupPriorityNormal
                                 strategy:TFYPopupPriorityStrategyQueue
                                 animated:YES
                                           completion:^(TFYPopupView * _Nullable pop) {
                
            }];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 方法3：使用完整配置的优先级方法（最强大的API）
            // 适用场景：需要完全控制所有参数，专业级使用
            TFYPopupViewConfiguration *fullConfig = [[TFYPopupViewConfiguration alloc] init];
            fullConfig.backgroundColor = [[UIColor systemRedColor] colorWithAlphaComponent:0.8];
            fullConfig.animationDuration = 0.3;
            fullConfig.cornerRadius = 20;
            fullConfig.enableHapticFeedback = YES;
            
            // 自定义动画器（展示用户可以完全控制动画效果）
            TFYPopupFadeInOutAnimator *customAnimator = [[TFYPopupFadeInOutAnimator alloc] init];
            customAnimator.displayDuration = 0.4;
            customAnimator.dismissDuration = 0.4;
            
            UILabel *method3Label = [self createDemoLabel:@"方法3\n完整配置API\n高优先级\n(配置+动画器+优先级)" color:[UIColor whiteColor]];
            method3Label.backgroundColor = [UIColor systemRedColor];
            method3Label.numberOfLines = 0;
            
            [TFYPopupView showPriorityContentView:method3Label
                            configuration:fullConfig
                                 animator:customAnimator
                                 priority:TFYPopupPriorityHigh
                                 strategy:TFYPopupPriorityStrategyQueue
                                 animated:YES
                                       completion:^(TFYPopupView * _Nullable pop) {
                
            }];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 方法4：最高优先级验证（回到简单API）
            // 适用场景：紧急情况，快速显示，使用默认配置和动画器
            UILabel *method4Label = [self createDemoLabel:@"方法4\n紧急优先级\n默认配置\n(应该立即显示)" color:[UIColor whiteColor]];
            method4Label.backgroundColor = [UIColor systemPurpleColor];
            method4Label.numberOfLines = 0;
            
            [TFYPopupView showContentViewWithPriority:method4Label
                                 priority:TFYPopupPriorityUrgent
                                 strategy:TFYPopupPriorityStrategyQueue
                                 animated:YES
                                           completion:^(TFYPopupView * _Nullable pop) {
                
            }];
        });
    });
}

// MARK: - 辅助方法用于配置验证
- (UILabel *)createDemoLabel:(NSString *)text color:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.numberOfLines = 0;
    
    // 设置固定尺寸
    label.frame = CGRectMake(0, 0, 250, 120);
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    
    return label;
}

@end
