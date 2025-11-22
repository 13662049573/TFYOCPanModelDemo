//

#ifndef TFYPOPUPVIEWANIMATOR_H
#define TFYPOPUPVIEWANIMATOR_H

//  TFYPopupViewAnimator.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗动画器协议定义
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TFYPopupView;
@class TFYPopupBackgroundView;

/// 弹窗动画器协议
NS_SWIFT_NAME(PopupViewAnimator)
@protocol TFYPopupViewAnimator <NSObject>

@required

/// 初始化配置动画驱动器
/// @param popupView TFYPopupView实例
/// @param contentView 自定义的弹框视图
/// @param backgroundView 背景视图
- (void)setupPopupView:(TFYPopupView *)popupView
           contentView:(UIView *)contentView
        backgroundView:(TFYPopupBackgroundView *)backgroundView NS_SWIFT_NAME(setup(popupView:contentView:backgroundView:));

/// 横竖屏切换的时候，刷新布局
/// @param popupView TFYPopupView实例
/// @param contentView 自定义的弹框视图
- (void)refreshLayoutPopupView:(TFYPopupView *)popupView
                   contentView:(UIView *)contentView NS_SWIFT_NAME(refreshLayout(popupView:contentView:));

/// 处理展示动画
/// @param contentView 自定义的弹框视图
/// @param backgroundView 背景视图
/// @param animated 是否需要动画
/// @param completion 动画完成后的回调
- (void)displayContentView:(UIView *)contentView
            backgroundView:(TFYPopupBackgroundView *)backgroundView
                  animated:(BOOL)animated
                completion:(void (^)(void))completion NS_SWIFT_NAME(display(contentView:backgroundView:animated:completion:));

/// 处理消失动画
/// @param contentView 自定义的弹框视图
/// @param backgroundView 背景视图
/// @param animated 是否需要动画
/// @param completion 动画完成后的回调
- (void)dismissContentView:(UIView *)contentView
            backgroundView:(TFYPopupBackgroundView *)backgroundView
                  animated:(BOOL)animated
                completion:(void (^)(void))completion NS_SWIFT_NAME(dismiss(contentView:backgroundView:animated:completion:));

@end

NS_ASSUME_NONNULL_END

#endif /* TFYPOPUPVIEWANIMATOR_H */
