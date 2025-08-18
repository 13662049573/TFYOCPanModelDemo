//
//  TFYPopup.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗框架主实现文件，定义全局常量和函数
//

#import "TFYPopup.h"

#pragma mark - Version Information

NSString * const TFYPopupVersion = @"1.0.0";
NSString * const TFYPopupBuildDate = @"2024-12-19";
NSString * const TFYPopupDescription = @"TFYPopup - 功能强大的iOS弹窗框架";
NSString * const TFYPopupAuthor = @"田风有";

#pragma mark - Notification Names

NSNotificationName const TFYPopupWillAppearNotification = @"TFYPopupWillAppearNotification";
NSNotificationName const TFYPopupDidAppearNotification = @"TFYPopupDidAppearNotification";
NSNotificationName const TFYPopupWillDisappearNotification = @"TFYPopupWillDisappearNotification";
NSNotificationName const TFYPopupDidDisappearNotification = @"TFYPopupDidDisappearNotification";
NSNotificationName const TFYPopupCountDidChangeNotification = @"TFYPopupCountDidChangeNotification";

#pragma mark - Global Variables

static BOOL _debugMode = NO;

#pragma mark - Global Functions Implementation

NSInteger TFYPopupGetCurrentCount(void) {
    return [TFYPopupView currentPopupCount];
}

BOOL TFYPopupIsPresenting(void) {
    return TFYPopupGetCurrentCount() > 0;
}

NSArray<TFYPopupView *> * TFYPopupGetAllCurrentPopups(void) {
    return [TFYPopupView allCurrentPopups];
}

void TFYPopupSetDebugMode(BOOL enabled) {
    _debugMode = enabled;
    
    if (enabled) {
        NSLog(@"TFYPopup: Debug mode enabled");
        NSLog(@"TFYPopup: Version %@", TFYPopupVersion);
        NSLog(@"TFYPopup: Build Date %@", TFYPopupBuildDate);
    } else {
        NSLog(@"TFYPopup: Debug mode disabled");
    }
}

BOOL TFYPopupGetDebugMode(void) {
    return _debugMode;
}

#pragma mark - Load Method
@implementation  TFYPopup

+ (void)load {
    // 框架加载时的初始化工作
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (TFYPopupGetDebugMode()) {
            NSLog(@"TFYPopup Framework Loaded - Version: %@", TFYPopupVersion);
        }
        
        // 可以在这里添加一些全局配置或初始化代码
        [self setupGlobalConfiguration];
    });
}

+ (void)setupGlobalConfiguration {
    // 设置全局默认配置
    // 例如：主题适配、内存警告监听等
    
    // 监听内存警告
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
                                                       object:nil
                                                        queue:[NSOperationQueue mainQueue]
                                                   usingBlock:^(NSNotification * _Nonnull note) {
        if (TFYPopupGetDebugMode()) {
            NSLog(@"TFYPopup: Memory warning received, current popup count: %ld", (long)TFYPopupGetCurrentCount());
        }
        
        // 可以在这里实现内存警告时的弹窗清理逻辑
        // 比如自动关闭一些非关键弹窗
    }];
    
    // 监听应用进入后台
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                       object:nil
                                                        queue:[NSOperationQueue mainQueue]
                                                   usingBlock:^(NSNotification * _Nonnull note) {
        if (TFYPopupGetDebugMode()) {
            NSLog(@"TFYPopup: App entered background, current popup count: %ld", (long)TFYPopupGetCurrentCount());
        }
        
        // 可以在这里实现应用进入后台时的弹窗处理逻辑
    }];
}

@end

#pragma mark - Category Extensions for Convenience

@implementation NSObject (TFYPopupConvenience)

/// 便利方法：显示简单的alert弹窗
- (TFYPopupView *)showAlertWithTitle:(NSString *)title
                             message:(NSString *)message
                            animated:(BOOL)animated
                          completion:(void (^)(void))completion {
    
    // 创建一个简单的alert视图
    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 12;
    alertView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 添加标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:titleLabel];
    
    // 添加消息标签
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.font = [UIFont systemFontOfSize:16];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:messageLabel];
    
    // 添加确定按钮
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont systemFontOfSize:16];
    okButton.backgroundColor = [UIColor systemBlueColor];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.layer.cornerRadius = 8;
    okButton.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:okButton];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // alertView 尺寸
        [alertView.widthAnchor constraintEqualToConstant:280],
        [alertView.heightAnchor constraintGreaterThanOrEqualToConstant:150],
        
        // titleLabel 约束
        [titleLabel.topAnchor constraintEqualToAnchor:alertView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor constant:-20],
        
        // messageLabel 约束
        [messageLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:15],
        [messageLabel.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor constant:20],
        [messageLabel.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor constant:-20],
        
        // okButton 约束
        [okButton.topAnchor constraintEqualToAnchor:messageLabel.bottomAnchor constant:20],
        [okButton.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor constant:20],
        [okButton.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor constant:-20],
        [okButton.bottomAnchor constraintEqualToAnchor:alertView.bottomAnchor constant:-20],
        [okButton.heightAnchor constraintEqualToConstant:44]
    ]];
    
    // 创建弹窗配置
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    config.dismissOnBackgroundTap = YES;
    config.backgroundStyle = TFYPopupBackgroundStyleSolidColor;
    config.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    // 显示弹窗
    TFYPopupView *popup = [TFYPopupView showContentView:alertView
                                          configuration:config
                                               animator:[[TFYPopupSpringAnimator alloc] init]
                                               animated:animated
                                             completion:completion];
    
    // 添加按钮点击事件
    [okButton addTarget:popup action:@selector(dismissAnimated:completion:) forControlEvents:UIControlEventTouchUpInside];
    
    return popup;
}

@end

#pragma mark - Debug Helpers

#if DEBUG
@implementation TFYPopupView (Debug)

+ (void)logCurrentPopupInfo {
    NSArray<TFYPopupView *> *popups = TFYPopupGetAllCurrentPopups();
    NSLog(@"=== TFYPopup Debug Info ===");
    NSLog(@"Current popup count: %ld", (long)popups.count);
    
    for (NSInteger i = 0; i < popups.count; i++) {
        TFYPopupView *popup = popups[i];
        NSLog(@"Popup[%ld]: %@ - isPresenting: %@", (long)i, popup.class, popup.isPresenting ? @"YES" : @"NO");
    }
    NSLog(@"=========================");
}

@end
#endif
