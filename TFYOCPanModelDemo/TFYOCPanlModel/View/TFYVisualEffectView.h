//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYVisualEffectView.h
//  TFYPanModal
//
//  Created by heath wang on 2019/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(VisualEffectView)
@interface TFYVisualEffectView : UIVisualEffectView

/**
 * tint color
 * default is nil
 */
@property (nullable, nonatomic, strong) UIColor *colorTint;
/**
 * tint color alpha
 * default is 0.0
 */
@property (nonatomic, assign) CGFloat colorTintAlpha;
/**
 * blur radius, change it to make blur affect
 * default is 0.0
 */
@property (nonatomic, assign) CGFloat blurRadius;
/**
 * scale factor.
 * default is 1.0
 */
@property (nonatomic, assign) CGFloat scale;

- (void)updateBlurEffect:(nullable UIVisualEffect *)effect NS_SWIFT_NAME(updateBlurEffect(_:)) NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
