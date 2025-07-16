//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalAnimator.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <Foundation/Foundation.h>
#import "TFYPanModalPresentable.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 动画执行Block
 */
typedef void(^AnimationBlockType)(void);
/**
 * 动画完成回调Block
 * @param completion 是否完成
 */
typedef void(^AnimationCompletionType)(BOOL completion);

/**
 * 默认转场动画时长
 */
static NSTimeInterval kTransitionDuration = 0.5;

/**
 * TFYPanModalAnimator
 * PanModal弹窗动画工具类，统一管理弹窗的弹出、消失、平滑动画
 */
@interface TFYPanModalAnimator : NSObject

/**
 * 弹窗弹出/切换动画
 * @param animations 动画Block
 * @param config 配置对象（可选）
 * @param completion 动画完成回调
 */
+ (void)animate:(nonnull AnimationBlockType)animations config:(nullable id <TFYPanModalPresentable>)config completion:(nullable AnimationCompletionType)completion;

/**
 * 弹窗消失动画
 * @param animations 动画Block
 * @param config 配置对象（可选）
 * @param completion 动画完成回调
 */
+ (void)dismissAnimate:(nonnull AnimationBlockType)animations config:(nullable id <TFYPanModalPresentable>)config completion:(nullable AnimationCompletionType)completion;

/**
 * 平滑线性动画（无弹性）
 * @param animations 动画Block
 * @param duration 动画时长
 * @param completion 动画完成回调
 */
+ (void)smoothAnimate:(nonnull AnimationBlockType)animations duration:(NSTimeInterval)duration completion:(nullable AnimationCompletionType)completion;

@end

NS_ASSUME_NONNULL_END
