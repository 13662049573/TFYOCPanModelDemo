//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalPresentationController.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
#import "TFYPanModalPresentable.h"

@class TFYDimmedView;

NS_ASSUME_NONNULL_BEGIN

/**
 * TFYPanModalPresentationController
 * 自定义弹窗的UIPresentationController，负责弹窗的展示、布局、交互等核心逻辑
 */
NS_SWIFT_NAME(PanModalPresentationController)
@interface TFYPanModalPresentationController : UIPresentationController

/**
 * 背景遮罩视图（只读）
 */
@property (nonatomic, readonly, nonnull) TFYDimmedView *backgroundView;
/**
 * 当前弹窗的展示状态（short/medium/long）（只读）
 */
@property (nonatomic, readonly) PresentationState currentPresentationState;
/**
 * 弹窗视图是否正在动画（只读）
 */
@property (nonatomic, assign, readonly) BOOL isPresentedViewAnimating;

/**
 * 强制刷新布局
 */
- (void)setNeedsLayoutUpdate NS_SWIFT_NAME(setNeedsLayoutUpdate());

/**
 * 刷新用户交互行为（如事件穿透等）
 */
- (void)updateUserHitBehavior NS_SWIFT_NAME(updateUserHitBehavior());

/**
 * 切换弹窗状态
 * @param state 目标状态
 * @param animated 是否动画
 */
- (void)transitionToState:(PresentationState)state animated:(BOOL)animated NS_SWIFT_NAME(transition(to:animated:));

/**
 * 设置滚动视图的contentOffset
 * @param offset 偏移量
 * @param animated 是否动画
 */
- (void)setScrollableContentOffset:(CGPoint)offset animated:(BOOL)animated NS_SWIFT_NAME(setScrollableContentOffset(_:animated:));

/**
 * 关闭弹窗
 * @param animated 是否动画
 * @param completion 关闭完成回调
 */
- (void)dismissAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion NS_SWIFT_NAME(dismiss(animated:completion:));

@end

NS_ASSUME_NONNULL_END
