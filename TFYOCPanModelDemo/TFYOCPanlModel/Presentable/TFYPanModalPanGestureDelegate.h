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
@protocol TFYPanModalPanGestureDelegate <NSObject>
@optional
/**
 * 判断手势是否可开始
 * @param gestureRecognizer 手势识别器
 */
- (BOOL)tfy_gestureRecognizerShouldBegin:(nonnull UIGestureRecognizer *)gestureRecognizer;
/**
 * 是否允许与其他手势同时识别
 * @param gestureRecognizer 当前手势
 * @param otherGestureRecognizer 其他手势
 */
- (BOOL)tfy_gestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer;
/**
 * 是否要求当前手势失败后再识别其他手势
 * @param gestureRecognizer 当前手势
 * @param otherGestureRecognizer 其他手势
 */
- (BOOL)tfy_gestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer;
/**
 * 是否要求其他手势失败后再识别当前手势
 * @param gestureRecognizer 当前手势
 * @param otherGestureRecognizer 其他手势
 */
- (BOOL)tfy_gestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer;

@end

NS_ASSUME_NONNULL_END

