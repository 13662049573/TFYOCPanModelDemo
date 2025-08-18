//
//  TFYPopupBackgroundView.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗背景视图，支持多种背景效果
//

#import <UIKit/UIKit.h>
#import "TFYPopupViewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/// 背景效果类型
typedef NS_ENUM(NSUInteger, TFYPopupBackgroundEffect) {
    TFYPopupBackgroundEffectNone = 0,       // 无效果
    TFYPopupBackgroundEffectBlur,           // 模糊效果
    TFYPopupBackgroundEffectGradient,       // 渐变效果
    TFYPopupBackgroundEffectDimmed,         // 变暗效果
    TFYPopupBackgroundEffectCustom          // 自定义效果
} NS_SWIFT_NAME(PopupBackgroundEffect);

/// 自定义背景效果处理 block
typedef void (^TFYPopupBackgroundCustomHandler)(UIControl *backgroundView) NS_SWIFT_NAME(PopupBackgroundCustomHandler);

/// 弹窗背景视图类
NS_SWIFT_NAME(PopupBackgroundView)
@interface TFYPopupBackgroundView : UIControl

/// 背景样式，默认 TFYPopupBackgroundStyleSolidColor
@property (nonatomic, assign) TFYPopupBackgroundStyle style;

/// 背景颜色，默认黑色半透明
@property (nonatomic, strong) UIColor *color;

/// 模糊效果样式，默认 UIBlurEffectStyleDark
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;

/// 渐变颜色数组，默认黑色渐变
@property (nonatomic, strong) NSArray<UIColor *> *gradientColors;

/// 渐变位置数组，默认 [0.0, 1.0]
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *gradientLocations;

/// 渐变起始点，默认 (0.5, 0)
@property (nonatomic, assign) CGPoint gradientStartPoint;

/// 渐变结束点，默认 (0.5, 1)
@property (nonatomic, assign) CGPoint gradientEndPoint;

/// 默认初始化
- (instancetype)initWithFrame:(CGRect)frame;

/// 应用背景效果
/// @param effect 效果类型
/// @param customHandler 自定义处理器（仅当effect为Custom时使用）
- (void)applyBackgroundEffect:(TFYPopupBackgroundEffect)effect 
                customHandler:(nullable TFYPopupBackgroundCustomHandler)customHandler NS_SWIFT_NAME(applyBackgroundEffect(_:customHandler:));

/// 应用模糊效果
/// @param style 模糊样式
- (void)applyBlurEffect:(UIBlurEffectStyle)style NS_SWIFT_NAME(applyBlurEffect(_:));

/// 应用渐变效果
/// @param colors 渐变颜色数组
/// @param locations 位置数组（可为空）
- (void)applyGradientEffectWithColors:(NSArray<UIColor *> *)colors 
                            locations:(nullable NSArray<NSNumber *> *)locations NS_SWIFT_NAME(applyGradientEffect(colors:locations:));

/// 应用变暗效果
/// @param color 颜色
/// @param alpha 透明度
- (void)applyDimmedEffectWithColor:(UIColor *)color alpha:(CGFloat)alpha NS_SWIFT_NAME(applyDimmedEffect(color:alpha:));

@end

NS_ASSUME_NONNULL_END
