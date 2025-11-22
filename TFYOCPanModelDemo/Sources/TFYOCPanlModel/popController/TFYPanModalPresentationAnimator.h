//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。

#ifndef TFYPANMODALPRESENTATIONANIMATOR_H
#define TFYPANMODALPRESENTATIONANIMATOR_H

//
//  TFYPanModalPresentationAnimator.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <TFYOCPanlModel/TFYPanModalPresentationDelegate.h>

/**
 * TransitionStyle
 * 转场动画类型（弹出/消失）
 */
typedef NS_ENUM(NSInteger, TransitionStyle) {
	TransitionStylePresentation, ///< 弹出动画
	TransitionStyleDismissal,    ///< 消失动画
};

NS_ASSUME_NONNULL_BEGIN

/**
 * TFYPanModalPresentationAnimator
 * PanModal弹窗自定义转场动画实现，支持弹出/消失、交互式等
 */
@interface TFYPanModalPresentationAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/**
 * 初始化方法
 * @param transitionStyle 转场类型
 * @param mode 交互模式
 */
- (instancetype)initWithTransitionStyle:(TransitionStyle)transitionStyle interactiveMode:(PanModalInteractiveMode)mode NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

#endif /* TFYPANMODALPRESENTATIONANIMATOR_H */
