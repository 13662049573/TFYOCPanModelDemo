//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。

#ifndef TFYPANMODALPRESENTATIONDELEGATE_H
#define TFYPANMODALPRESENTATIONDELEGATE_H

//
//  TFYPanModalPresentationDelegate.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TFYOCPanlModel/TFYPanModalPresentationController.h> // 修复strong属性类型错误，需完整类型声明

@class TFYPanModalInteractiveAnimator;

/**
 * @enum PanModalInteractiveMode
 * @brief PanModal弹窗的交互模式枚举
 * @discussion 用于区分不同的交互关闭方式，如无交互、侧滑、下拉等
 */
typedef NS_ENUM(NSInteger, PanModalInteractiveMode) {
    PanModalInteractiveModeNone NS_SWIFT_NAME(none),           ///< 无交互
    PanModalInteractiveModeSideslip NS_SWIFT_NAME(sideslip),       ///< 侧滑返回
    PanModalInteractiveModeDragDown NS_SWIFT_NAME(dragDown),       ///< 向下拖拽返回
} NS_SWIFT_NAME(PanModalInteractiveMode);

NS_ASSUME_NONNULL_BEGIN

/**
 * @class TFYPanModalPresentationDelegate
 * @brief PanModal弹窗的转场代理，负责动画与交互的管理
 * @discussion 实现UIViewControllerTransitioningDelegate等协议，统一管理弹窗的present/dismiss动画与交互
 */
NS_SWIFT_NAME(PanModalPresentationDelegate)
@interface TFYPanModalPresentationDelegate : NSObject <UIViewControllerTransitioningDelegate, UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate>

/**
 * @brief 当前是否为交互式关闭
 */
@property (nonatomic, assign) BOOL interactive;
/**
 * @brief 当前交互模式
 */
@property (nonatomic, assign) PanModalInteractiveMode interactiveMode;
/**
 * @brief 交互式关闭动画器（只读）
 */
@property (nonatomic, strong, readonly, nonnull) TFYPanModalInteractiveAnimator *interactiveDismissalAnimator;
/**
 * @brief 强引用PresentationController，防止生命周期内被提前释放
 */
@property (nonatomic, strong, nullable) TFYPanModalPresentationController *strongPresentationController;

@end

NS_ASSUME_NONNULL_END

#endif /* TFYPANMODALPRESENTATIONDELEGATE_H */
