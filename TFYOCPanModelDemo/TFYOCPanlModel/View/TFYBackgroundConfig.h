//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYBackgroundConfig.h
//  TFYPanModal
//
//  Created by heath wang on 2020/4/17.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * TFYBackgroundBehavior
 * 背景遮罩的显示模式
 */
typedef NS_ENUM(NSUInteger, TFYBackgroundBehavior) {
    TFYBackgroundBehaviorDefault NS_SWIFT_NAME(default),
    TFYBackgroundBehaviorSystemVisualEffect NS_SWIFT_NAME(systemVisualEffect),
    TFYBackgroundBehaviorCustomBlurEffect NS_SWIFT_NAME(customBlurEffect),
} NS_SWIFT_NAME(BackgroundBehavior);

/**
 * TFYBackgroundConfig
 * PanModal弹窗的背景配置对象，支持多种遮罩模式、模糊、透明度等
 */
NS_SWIFT_NAME(BackgroundConfig)
@interface TFYBackgroundConfig : NSObject

/**
 * 背景显示模式
 */
@property (nonatomic, assign) TFYBackgroundBehavior backgroundBehavior;
/**
 * 背景透明度，仅在Default模式下生效，默认0.7
 */
@property (nonatomic, assign) CGFloat backgroundAlpha;
/**
 * 系统模糊效果，仅在SystemVisualEffect模式下生效，默认UIBlurEffectStyleLight
 */
@property (nonatomic, strong, nullable) UIVisualEffect *visualEffect;
/**
 * 自定义模糊的tint颜色，仅在CustomBlurEffect模式下生效，默认白色
 */
@property (nonatomic, strong, nullable) UIColor *blurTintColor;
/**
 * 自定义模糊半径，仅在CustomBlurEffect模式下生效，默认10
 */
@property (nonatomic, assign) CGFloat backgroundBlurRadius;

/**
 * 初始化方法，指定背景显示模式
 * @param backgroundBehavior 显示模式
 */
- (instancetype)initWithBehavior:(TFYBackgroundBehavior)backgroundBehavior NS_SWIFT_NAME(init(behavior:));

/**
 * 工厂方法，指定背景显示模式
 * @param backgroundBehavior 显示模式
 */
+ (instancetype)configWithBehavior:(TFYBackgroundBehavior)backgroundBehavior NS_SWIFT_NAME(config(behavior:));

@end

NS_ASSUME_NONNULL_END
