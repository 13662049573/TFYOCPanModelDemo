//
//  TFYPopupViewConfiguration.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗主配置类，整合所有配置选项
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFYPopupKeyboardConfiguration.h"
#import "TFYPopupContainerConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/// 背景样式枚举
typedef NS_ENUM(NSUInteger, TFYPopupBackgroundStyle) {
    TFYPopupBackgroundStyleSolidColor = 0,  // 纯色背景
    TFYPopupBackgroundStyleBlur,            // 模糊背景
    TFYPopupBackgroundStyleGradient,        // 渐变背景
    TFYPopupBackgroundStyleCustom           // 自定义背景
} NS_SWIFT_NAME(PopupBackgroundStyle);

/// 弹窗主题枚举
typedef NS_ENUM(NSUInteger, TFYPopupTheme) {
    TFYPopupThemeDefault = 0,   // 默认主题
    TFYPopupThemeLight,         // 浅色主题
    TFYPopupThemeDark,          // 深色主题
    TFYPopupThemeCustom         // 自定义主题
} NS_SWIFT_NAME(PopupTheme);

/// 阴影配置类
NS_SWIFT_NAME(PopupShadowConfiguration)
@interface TFYPopupShadowConfiguration : NSObject <NSCopying>

/// 是否启用阴影，默认 NO
@property (nonatomic, assign) BOOL isEnabled;

/// 阴影颜色，默认黑色
@property (nonatomic, strong) UIColor *color;

/// 阴影透明度，默认 0.3
@property (nonatomic, assign) float opacity;

/// 阴影半径，默认 5
@property (nonatomic, assign) CGFloat radius;

/// 阴影偏移，默认 (0, 0)
@property (nonatomic, assign) CGSize offset;

/// 默认初始化
- (instancetype)init;

@end

/// 弹窗主配置类
NS_SWIFT_NAME(PopupViewConfiguration)
@interface TFYPopupViewConfiguration : NSObject <NSCopying>

/// 是否可消失，默认 YES
@property (nonatomic, assign) BOOL isDismissible;

/// 是否可交互，默认 YES
@property (nonatomic, assign) BOOL isInteractive;

/// 是否可穿透，默认 NO
@property (nonatomic, assign) BOOL isPenetrable;

/// 背景样式，默认 TFYPopupBackgroundStyleSolidColor
@property (nonatomic, assign) TFYPopupBackgroundStyle backgroundStyle;

/// 背景颜色，默认黑色半透明
@property (nonatomic, strong) UIColor *backgroundColor;

/// 模糊样式，默认 UIBlurEffectStyleDark
@property (nonatomic, assign) UIBlurEffectStyle blurStyle;

/// 动画持续时间，默认 0.25
@property (nonatomic, assign) NSTimeInterval animationDuration;

/// 是否尊重安全区域，默认 YES
@property (nonatomic, assign) BOOL respectsSafeArea;

/// 安全区域边距，默认 (0, 0, 0, 0)
@property (nonatomic, assign) UIEdgeInsets safeAreaInsets;

/// 是否启用拖拽消失，默认 NO
@property (nonatomic, assign) BOOL enableDragToDismiss;

/// 拖拽消失阈值，默认 0.3
@property (nonatomic, assign) CGFloat dragDismissThreshold;

/// 圆角半径，默认 0
@property (nonatomic, assign) CGFloat cornerRadius;

/// 点击外部消失，默认 YES
@property (nonatomic, assign) BOOL tapOutsideToDismiss;

/// 滑动消失，默认 YES
@property (nonatomic, assign) BOOL swipeToDismiss;

/// 点击背景消失，默认 YES
@property (nonatomic, assign) BOOL dismissOnBackgroundTap;

/// App进入后台时消失，默认 YES
@property (nonatomic, assign) BOOL dismissWhenAppGoesToBackground;

/// 最大弹窗数量限制，默认 10
@property (nonatomic, assign) NSInteger maxPopupCount;

/// 自动消失延迟，0表示不自动消失，默认 0
@property (nonatomic, assign) NSTimeInterval autoDismissDelay;

/// 启用触觉反馈，默认 YES
@property (nonatomic, assign) BOOL enableHapticFeedback;

/// 启用无障碍支持，默认 YES
@property (nonatomic, assign) BOOL enableAccessibility;

/// 弹窗主题，默认 TFYPopupThemeDefault
@property (nonatomic, assign) TFYPopupTheme theme;

/// 自定义主题背景颜色（仅当主题为自定义时使用）
@property (nonatomic, strong, nullable) UIColor *customThemeBackgroundColor;

/// 自定义主题文本颜色（仅当主题为自定义时使用）
@property (nonatomic, strong, nullable) UIColor *customThemeTextColor;

/// 自定义主题圆角半径（仅当主题为自定义时使用）
@property (nonatomic, assign) CGFloat customThemeCornerRadius;

/// 键盘配置
@property (nonatomic, strong) TFYPopupKeyboardConfiguration *keyboardConfiguration;

/// 阴影配置
@property (nonatomic, strong) TFYPopupShadowConfiguration *shadowConfiguration;

/// 容器配置
@property (nonatomic, strong) TFYPopupContainerConfiguration *containerConfiguration;

/// 默认初始化
- (instancetype)init;

/// 验证配置是否有效
- (BOOL)validate NS_SWIFT_NAME(validate());

/// 获取当前主题（自动适配系统主题）
+ (TFYPopupTheme)currentTheme NS_SWIFT_NAME(currentTheme());

@end

NS_ASSUME_NONNULL_END
