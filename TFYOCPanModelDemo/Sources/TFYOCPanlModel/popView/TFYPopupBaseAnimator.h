//
//  TFYPopupBaseAnimator.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗基础动画器类，提供通用的动画框架
//

#import <UIKit/UIKit.h>
#import <TFYOCPanlModel/TFYPopupViewAnimator.h>
#import <TFYOCPanlModel/TFYPopupAnimatorLayout.h>

NS_ASSUME_NONNULL_BEGIN

@class TFYPopupView, TFYPopupBackgroundView;

/// 动画完成回调
typedef void (^TFYPopupAnimationCompletionBlock)(void) NS_SWIFT_NAME(PopupAnimationCompletionBlock);

/// 弹窗基础动画器类
NS_SWIFT_NAME(PopupBaseAnimator)
@interface TFYPopupBaseAnimator : NSObject <TFYPopupViewAnimator>

#pragma mark - Layout Properties

/// 布局配置
@property (nonatomic, strong) TFYPopupAnimatorLayout *layout;

#pragma mark - Display Animation Properties

/// 显示动画持续时间，默认 0.25
@property (nonatomic, assign) NSTimeInterval displayDuration;

/// 显示动画选项，默认 UIViewAnimationOptionCurveEaseInOut
@property (nonatomic, assign) UIViewAnimationOptions displayAnimationOptions;

/// 显示弹簧阻尼比（可为空，设置后将使用弹簧动画）
@property (nonatomic, assign) CGFloat displaySpringDampingRatio;
@property (nonatomic, assign) BOOL hasDisplaySpringDampingRatio;

/// 显示弹簧初始速度（可为空，设置后将使用弹簧动画）
@property (nonatomic, assign) CGFloat displaySpringVelocity;
@property (nonatomic, assign) BOOL hasDisplaySpringVelocity;

/// 显示动画块（子类重写此属性以定义动画内容）
@property (nonatomic, copy, nullable) TFYPopupAnimationCompletionBlock displayAnimationBlock;

#pragma mark - Dismiss Animation Properties

/// 消失动画持续时间，默认 0.25
@property (nonatomic, assign) NSTimeInterval dismissDuration;

/// 消失动画选项，默认 UIViewAnimationOptionCurveEaseInOut
@property (nonatomic, assign) UIViewAnimationOptions dismissAnimationOptions;

/// 消失弹簧阻尼比（可为空，设置后将使用弹簧动画）
@property (nonatomic, assign) CGFloat dismissSpringDampingRatio;
@property (nonatomic, assign) BOOL hasDismissSpringDampingRatio;

/// 消失弹簧初始速度（可为空，设置后将使用弹簧动画）
@property (nonatomic, assign) CGFloat dismissSpringVelocity;
@property (nonatomic, assign) BOOL hasDismissSpringVelocity;

/// 消失动画块（子类重写此属性以定义动画内容）
@property (nonatomic, copy, nullable) TFYPopupAnimationCompletionBlock dismissAnimationBlock;

#pragma mark - Initialization

/// 使用默认居中布局初始化
- (instancetype)init;

/// 使用指定布局初始化
- (instancetype)initWithLayout:(TFYPopupAnimatorLayout *)layout NS_SWIFT_NAME(init(layout:));

#pragma mark - Layout Setup (Protected Methods - 子类可重写)

/// 设置布局约束（子类可重写以自定义布局逻辑）
- (void)setupLayoutWithPopupView:(TFYPopupView *)popupView contentView:(UIView *)contentView NS_SWIFT_NAME(setupLayout(popupView:contentView:));

/// 设置居中布局
- (void)setupCenterLayoutWithPopupView:(TFYPopupView *)popupView
                           contentView:(UIView *)contentView
                                center:(TFYPopupAnimatorLayoutCenter *)center NS_SWIFT_NAME(setupCenterLayout(popupView:contentView:center:));

/// 设置顶部布局
- (void)setupTopLayoutWithPopupView:(TFYPopupView *)popupView
                        contentView:(UIView *)contentView
                                top:(TFYPopupAnimatorLayoutTop *)top NS_SWIFT_NAME(setupTopLayout(popupView:contentView:top:));

/// 设置底部布局
- (void)setupBottomLayoutWithPopupView:(TFYPopupView *)popupView
                           contentView:(UIView *)contentView
                                bottom:(TFYPopupAnimatorLayoutBottom *)bottom NS_SWIFT_NAME(setupBottomLayout(popupView:contentView:bottom:));

/// 设置左侧布局
- (void)setupLeadingLayoutWithPopupView:(TFYPopupView *)popupView
                            contentView:(UIView *)contentView
                                leading:(TFYPopupAnimatorLayoutLeading *)leading NS_SWIFT_NAME(setupLeadingLayout(popupView:contentView:leading:));

/// 设置右侧布局
- (void)setupTrailingLayoutWithPopupView:(TFYPopupView *)popupView
                             contentView:(UIView *)contentView
                                trailing:(TFYPopupAnimatorLayoutTrailing *)trailing NS_SWIFT_NAME(setupTrailingLayout(popupView:contentView:trailing:));

#pragma mark - Utility Methods

/// 获取安全区域边距
- (UIEdgeInsets)getSafeAreaInsetsForPopupView:(TFYPopupView *)popupView NS_SWIFT_NAME(getSafeAreaInsets(popupView:));

/// 根据安全区域调整常量值
- (CGFloat)adjustConstant:(CGFloat)constant forEdge:(UIRectEdge)edge popupView:(TFYPopupView *)popupView NS_SWIFT_NAME(adjustConstant(_:forEdge:popupView:));

@end

NS_ASSUME_NONNULL_END
