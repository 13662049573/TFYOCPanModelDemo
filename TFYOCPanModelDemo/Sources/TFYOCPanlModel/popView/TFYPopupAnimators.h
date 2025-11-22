//

#ifndef TFYPOPUPANIMATORS_H
#define TFYPOPUPANIMATORS_H

//  TFYPopupAnimators.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗具体动画器类声明集合
//

#import <UIKit/UIKit.h>
#import <TFYOCPanlModel/TFYPopupBaseAnimator.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Basic Animators

/// 淡入淡出动画器
NS_SWIFT_NAME(PopupFadeInOutAnimator)
@interface TFYPopupFadeInOutAnimator : TFYPopupBaseAnimator
@end

/// 缩放动画器
NS_SWIFT_NAME(PopupZoomInOutAnimator)
@interface TFYPopupZoomInOutAnimator : TFYPopupBaseAnimator
@end

/// 3D翻转动画器
NS_SWIFT_NAME(Popup3DFlipAnimator)
@interface TFYPopup3DFlipAnimator : TFYPopupBaseAnimator
@end

/// 弹簧动画器
NS_SWIFT_NAME(PopupSpringAnimator)
@interface TFYPopupSpringAnimator : TFYPopupBaseAnimator
@end

/// 弹性动画器
NS_SWIFT_NAME(PopupBounceAnimator)
@interface TFYPopupBounceAnimator : TFYPopupBaseAnimator
@end

/// 旋转动画器
NS_SWIFT_NAME(PopupRotateAnimator)
@interface TFYPopupRotateAnimator : TFYPopupBaseAnimator
@end

#pragma mark - Directional Animators

/// 方向动画器基类
NS_SWIFT_NAME(PopupDirectionalAnimator)
@interface TFYPopupDirectionalAnimator : TFYPopupBaseAnimator

/// 获取初始变换（子类重写）
- (CGAffineTransform)getInitialTransformForPopupView:(TFYPopupView *)popupView contentView:(UIView *)contentView NS_SWIFT_NAME(getInitialTransform(popupView:contentView:));

@end

/// 向上滑入动画器
NS_SWIFT_NAME(PopupUpwardAnimator)
@interface TFYPopupUpwardAnimator : TFYPopupDirectionalAnimator
@end

/// 向下滑入动画器
NS_SWIFT_NAME(PopupDownwardAnimator)
@interface TFYPopupDownwardAnimator : TFYPopupDirectionalAnimator
@end

/// 向左滑入动画器
NS_SWIFT_NAME(PopupLeftwardAnimator)
@interface TFYPopupLeftwardAnimator : TFYPopupDirectionalAnimator
@end

/// 向右滑入动画器
NS_SWIFT_NAME(PopupRightwardAnimator)
@interface TFYPopupRightwardAnimator : TFYPopupDirectionalAnimator
@end

#pragma mark - Slide Animator

/// 滑动方向枚举
typedef NS_ENUM(NSUInteger, TFYPopupSlideDirection) {
    TFYPopupSlideDirectionFromTop = 0,    // 从顶部滑入
    TFYPopupSlideDirectionFromBottom,     // 从底部滑入
    TFYPopupSlideDirectionFromLeft,       // 从左侧滑入
    TFYPopupSlideDirectionFromRight       // 从右侧滑入
} NS_SWIFT_NAME(PopupSlideDirection);

/// 滑动动画器
NS_SWIFT_NAME(PopupSlideAnimator)
@interface TFYPopupSlideAnimator : TFYPopupBaseAnimator

@property (nonatomic, assign, readonly) TFYPopupSlideDirection direction;

/// 指定初始化方法
- (instancetype)initWithDirection:(TFYPopupSlideDirection)direction NS_SWIFT_NAME(init(direction:));

/// 使用指定方向和布局初始化
- (instancetype)initWithDirection:(TFYPopupSlideDirection)direction layout:(TFYPopupAnimatorLayout *)layout NS_SWIFT_NAME(init(direction:layout:));

@end

NS_ASSUME_NONNULL_END

#endif /* TFYPOPUPANIMATORS_H */
