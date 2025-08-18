//
//  TFYPopupViewConfiguration.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗主配置类实现
//

#import "TFYPopupViewConfiguration.h"

#pragma mark - TFYPopupShadowConfiguration

@implementation TFYPopupShadowConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _isEnabled = NO;
        _color = [UIColor blackColor];
        _opacity = 0.3f;
        _radius = 5.0;
        _offset = CGSizeZero;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupShadowConfiguration *copy = [[TFYPopupShadowConfiguration alloc] init];
    copy.isEnabled = self.isEnabled;
    copy.color = self.color;
    copy.opacity = self.opacity;
    copy.radius = self.radius;
    copy.offset = self.offset;
    return copy;
}

@end

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
        _cornerRadius = 0;
        _tapOutsideToDismiss = YES;
        _swipeToDismiss = YES;
        _dismissOnBackgroundTap = YES;
        _dismissWhenAppGoesToBackground = YES;
        _maxPopupCount = 10;
        _autoDismissDelay = 0;
        _enableHapticFeedback = YES;
        _enableAccessibility = YES;
        _theme = TFYPopupThemeDefault;
        _customThemeCornerRadius = 0;
        
        _keyboardConfiguration = [[TFYPopupKeyboardConfiguration alloc] init];
        _shadowConfiguration = [[TFYPopupShadowConfiguration alloc] init];
        _containerConfiguration = [[TFYPopupContainerConfiguration alloc] init];
    }
    return self;
}

- (BOOL)validate {
    if (self.maxPopupCount <= 0) return NO;
    if (self.autoDismissDelay < 0) return NO;
    if (self.dragDismissThreshold < 0 || self.dragDismissThreshold > 1) return NO;
    if (self.animationDuration < 0) return NO;
    
    return [self.keyboardConfiguration validate] && [self.containerConfiguration validate];
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
    copy.cornerRadius = self.cornerRadius;
    copy.tapOutsideToDismiss = self.tapOutsideToDismiss;
    copy.swipeToDismiss = self.swipeToDismiss;
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
    copy.shadowConfiguration = [self.shadowConfiguration copyWithZone:zone];
    copy.containerConfiguration = [self.containerConfiguration copyWithZone:zone];
    
    return copy;
}

@end
