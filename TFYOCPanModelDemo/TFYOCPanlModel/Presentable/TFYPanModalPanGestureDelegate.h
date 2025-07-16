//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalPanGestureDelegate.h
//  TFYPanModal
//
//  Created by heath wang on 2022/8/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * TFYPanModalPanGestureDelegate
 * PanModal弹窗手势代理协议，支持自定义拖拽、边缘滑动等手势行为
 * 实现本协议可自定义手势识别逻辑，谨慎使用
 */
NS_SWIFT_NAME(PanModalPanGestureDelegate)
@protocol TFYPanModalPanGestureDelegate <NSObject>
@optional
/**
 * 判断手势是否可开始
 * @param gestureRecognizer 手势识别器
 */
- (BOOL)panGestureRecognizerShouldBegin:(nonnull UIGestureRecognizer *)gestureRecognizer NS_SWIFT_NAME(panGestureRecognizerShouldBegin(_:)) NS_REFINED_FOR_SWIFT;
/**
 * 是否允许与其他手势同时识别
 * @param gestureRecognizer 当前手势
 * @param otherGestureRecognizer 其他手势
 */
- (BOOL)panGestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer NS_SWIFT_NAME(panGestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)) NS_REFINED_FOR_SWIFT;
/**
 * 是否要求当前手势失败后再识别其他手势
 * @param gestureRecognizer 当前手势
 * @param otherGestureRecognizer 其他手势
 */
- (BOOL)panGestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer NS_SWIFT_NAME(panGestureRecognizer(_:shouldBeRequiredToFailBy:)) NS_REFINED_FOR_SWIFT;
/**
 * 是否要求其他手势失败后再识别当前手势
 * @param gestureRecognizer 当前手势
 * @param otherGestureRecognizer 其他手势
 */
- (BOOL)panGestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer NS_SWIFT_NAME(panGestureRecognizer(_:shouldRequireFailureOf:)) NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END

