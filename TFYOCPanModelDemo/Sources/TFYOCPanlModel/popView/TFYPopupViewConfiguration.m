//
//  TFYPopupViewConfiguration.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗主配置类实现
//

#import <TFYOCPanlModel/TFYPopupViewConfiguration.h>

#pragma mark - TFYPopupViewConfiguration

@implementation TFYPopupViewConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _isDismissible = YES;
        _isInteractive = YES;
        _isPenetrable = NO;
        _backgroundStyle = TFYPopupBackgroundStyleSolidColor;
        _backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _blurStyle = UIBlurEffectStyleDark;
        _animationDuration = 0.25;
        _respectsSafeArea = YES;
        _safeAreaInsets = UIEdgeInsetsZero;
        _enableDragToDismiss = NO;
        _dragDismissThreshold = 0.3;
        _enableSwipeToDismiss = NO;
        _cornerRadius = 0;
        _dismissOnBackgroundTap = YES;
        _dismissWhenAppGoesToBackground = YES;
        _maxPopupCount = 10;
        _autoDismissDelay = 0;
        _enableHapticFeedback = YES;
        _enableAccessibility = YES;
        _theme = TFYPopupThemeDefault;
        _customThemeCornerRadius = 0;
        
        _keyboardConfiguration = [[TFYPopupKeyboardConfiguration alloc] init];
        _containerConfiguration = [[TFYPopupContainerConfiguration alloc] init];
        
        // 优先级配置默认值
        _priority = TFYPopupPriorityNormal;
        _priorityStrategy = TFYPopupPriorityStrategyQueue;
        _canBeReplacedByHigherPriority = YES;
        _maxWaitingTime = 0; // 使用管理器默认值
        _enablePriorityManagement = YES;
        
        // 容器选择配置默认值
        _containerSelectionStrategy = TFYPopupContainerSelectionStrategyAuto;
        _preferredContainerType = TFYPopupContainerTypeWindow; // 默认优先选择UIWindow
        _customContainerSelector = nil;
        _enableContainerAutoDiscovery = NO;
        _allowContainerFallback = YES;
        _containerSelectionTimeout = 5.0;
    }
    return self;
}

- (BOOL)validate {
    // 基本属性验证
    if (self.maxPopupCount <= 0) return NO;
    if (self.autoDismissDelay < 0) return NO;
    if (self.dragDismissThreshold < 0 || self.dragDismissThreshold > 1) return NO;
    if (self.animationDuration < 0) return NO;
    if (self.cornerRadius < 0) return NO;
    if (self.customThemeCornerRadius < 0) return NO;
    
    // 边距验证
    if (self.safeAreaInsets.top < 0 || self.safeAreaInsets.bottom < 0 || 
        self.safeAreaInsets.left < 0 || self.safeAreaInsets.right < 0) {
        return NO;
    }
    
    // 优先级和等待时间验证
    if (self.enablePriorityManagement) {
        if (self.maxWaitingTime < 0) return NO;
        // 验证优先级值在有效范围内
        if (self.priority < TFYPopupPriorityBackground || self.priority > TFYPopupPriorityUrgent) {
            return NO;
        }
    }
    
    // 容器选择配置验证
    if (self.containerSelectionTimeout < 0) return NO;
    if (self.preferredContainerType > TFYPopupContainerTypeCustom) return NO;
    if (self.containerSelectionStrategy > TFYPopupContainerSelectionStrategyCustom) return NO;
    
    // 子配置验证
    if (![self.keyboardConfiguration validate]) return NO;
    if (![self.containerConfiguration validate]) return NO;
    
    return YES;
}

+ (TFYPopupTheme)currentTheme {
    if (@available(iOS 13.0, *)) {
        return [UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark 
            ? TFYPopupThemeDark 
            : TFYPopupThemeLight;
    }
    return TFYPopupThemeDefault;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupViewConfiguration *copy = [[TFYPopupViewConfiguration alloc] init];
    copy.isDismissible = self.isDismissible;
    copy.isInteractive = self.isInteractive;
    copy.isPenetrable = self.isPenetrable;
    copy.backgroundStyle = self.backgroundStyle;
    copy.backgroundColor = self.backgroundColor;
    copy.blurStyle = self.blurStyle;
    copy.animationDuration = self.animationDuration;
    copy.respectsSafeArea = self.respectsSafeArea;
    copy.safeAreaInsets = self.safeAreaInsets;
    copy.enableDragToDismiss = self.enableDragToDismiss;
    copy.dragDismissThreshold = self.dragDismissThreshold;
    copy.enableSwipeToDismiss = self.enableSwipeToDismiss;
    copy.cornerRadius = self.cornerRadius;
    copy.dismissOnBackgroundTap = self.dismissOnBackgroundTap;
    copy.dismissWhenAppGoesToBackground = self.dismissWhenAppGoesToBackground;
    copy.maxPopupCount = self.maxPopupCount;
    copy.autoDismissDelay = self.autoDismissDelay;
    copy.enableHapticFeedback = self.enableHapticFeedback;
    copy.enableAccessibility = self.enableAccessibility;
    copy.theme = self.theme;
    copy.customThemeBackgroundColor = self.customThemeBackgroundColor;
    copy.customThemeTextColor = self.customThemeTextColor;
    copy.customThemeCornerRadius = self.customThemeCornerRadius;
    
    copy.keyboardConfiguration = [self.keyboardConfiguration copyWithZone:zone];
    copy.containerConfiguration = [self.containerConfiguration copyWithZone:zone];
    
    // 复制优先级配置
    copy.priority = self.priority;
    copy.priorityStrategy = self.priorityStrategy;
    copy.canBeReplacedByHigherPriority = self.canBeReplacedByHigherPriority;
    copy.maxWaitingTime = self.maxWaitingTime;
    copy.enablePriorityManagement = self.enablePriorityManagement;
    
    // 复制容器选择配置
    copy.containerSelectionStrategy = self.containerSelectionStrategy;
    copy.preferredContainerType = self.preferredContainerType;
    copy.customContainerSelector = self.customContainerSelector;
    copy.enableContainerAutoDiscovery = self.enableContainerAutoDiscovery;
    copy.allowContainerFallback = self.allowContainerFallback;
    copy.containerSelectionTimeout = self.containerSelectionTimeout;
    
    return copy;
}

@end
