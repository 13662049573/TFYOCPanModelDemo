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
#import "TFYPopupPriorityManager.h"
#import "TFYPopupContainerType.h"

NS_ASSUME_NONNULL_BEGIN

/// 背景样式枚举
typedef NS_ENUM(NSUInteger, TFYPopupBackgroundStyle) {
    TFYPopupBackgroundStyleSolidColor = 0,  // 纯色背景
    TFYPopupBackgroundStyleBlur,            // 模糊背景
    TFYPopupBackgroundStyleGradient,        // 渐变背景
    TFYPopupBackgroundStyleCustom           // 自定义背景
} NS_SWIFT_NAME(PopupBackgroundStyle);

/// 背景效果类型（统一定义）
typedef NS_ENUM(NSUInteger, TFYPopupBackgroundEffect) {
    TFYPopupBackgroundEffectNone = 0,       // 无效果
    TFYPopupBackgroundEffectBlur,           // 模糊效果
    TFYPopupBackgroundEffectGradient,       // 渐变效果
    TFYPopupBackgroundEffectDimmed,         // 变暗效果
    TFYPopupBackgroundEffectCustom          // 自定义效果
} NS_SWIFT_NAME(PopupBackgroundEffect);

/// 弹窗主题枚举
typedef NS_ENUM(NSUInteger, TFYPopupTheme) {
    TFYPopupThemeDefault = 0,   // 默认主题
    TFYPopupThemeLight,         // 浅色主题
    TFYPopupThemeDark,          // 深色主题
    TFYPopupThemeCustom         // 自定义主题
} NS_SWIFT_NAME(PopupTheme);



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

/// 是否启用滑动消失，默认 NO
@property (nonatomic, assign) BOOL enableSwipeToDismiss;

/// 圆角半径，默认 0
@property (nonatomic, assign) CGFloat cornerRadius;

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

/// 容器配置
@property (nonatomic, strong) TFYPopupContainerConfiguration *containerConfiguration;

#pragma mark - Priority Configuration

/// 弹窗优先级，默认 TFYPopupPriorityNormal
@property (nonatomic, assign) TFYPopupPriority priority;

/// 优先级处理策略，默认 TFYPopupPriorityStrategyQueue
@property (nonatomic, assign) TFYPopupPriorityStrategy priorityStrategy;

/// 是否允许被高优先级替换，默认 YES
@property (nonatomic, assign) BOOL canBeReplacedByHigherPriority;

/// 最大等待时间（秒），0表示不限制，默认使用管理器的默认值
@property (nonatomic, assign) NSTimeInterval maxWaitingTime;

/// 是否启用优先级管理，默认 YES
@property (nonatomic, assign) BOOL enablePriorityManagement;

#pragma mark - Container Selection Configuration

/// 容器选择策略，默认 TFYPopupContainerSelectionStrategyAuto
@property (nonatomic, assign) TFYPopupContainerSelectionStrategy containerSelectionStrategy;

/// 首选容器类型，默认 TFYPopupContainerTypeWindow
@property (nonatomic, assign) TFYPopupContainerType preferredContainerType;

/// 自定义容器选择器（可选）
@property (nonatomic, strong, nullable) id<TFYPopupContainerSelector> customContainerSelector;

/// 是否启用容器自动发现，默认 YES
@property (nonatomic, assign) BOOL enableContainerAutoDiscovery;

/// 是否允许容器降级（如果首选容器不可用，是否允许使用其他容器），默认 YES
@property (nonatomic, assign) BOOL allowContainerFallback;

/// 容器选择超时时间（秒），默认 5.0
@property (nonatomic, assign) NSTimeInterval containerSelectionTimeout;

/// 是否启用容器调试模式，默认 NO
@property (nonatomic, assign) BOOL enableContainerDebugMode;

/// 默认初始化
- (instancetype)init;

/// 验证配置是否有效
- (BOOL)validate NS_SWIFT_NAME(validate());

/// 获取当前主题（自动适配系统主题）
+ (TFYPopupTheme)currentTheme NS_SWIFT_NAME(currentTheme());

@end

NS_ASSUME_NONNULL_END
