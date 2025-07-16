//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalContainerView.h
//  TFYPanModal
//
//  Created by heath wang on 2019/10/17.
//

#import <UIKit/UIKit.h>
#import "TFYPanModalPresentable.h"

@class TFYPanModalContentView;
@class TFYDimmedView;
@class TFYPanContainerView;

NS_ASSUME_NONNULL_BEGIN

/**
 * TFYPanModalContainerView
 * PanModal弹窗的容器视图，负责内容视图的管理、动画、布局等
 */
@interface TFYPanModalContainerView : UIView

/**
 * 背景遮罩视图（只读）
 */
@property (nonatomic, readonly, nonnull) TFYDimmedView *backgroundView;
/**
 * 内容容器视图（只读）
 */
@property (readonly, nonnull) TFYPanContainerView *panContainerView;
/**
 * 当前弹窗的展示状态（short/medium/long）（只读）
 */
@property (nonatomic, readonly) PresentationState currentPresentationState;

/**
 * 初始化方法
 * @param presentingView 父视图
 * @param contentView    弹窗内容视图，需遵循TFYPanModalPresentable协议
 */
- (instancetype)initWithPresentingView:(nonnull UIView *)presentingView contentView:(nonnull TFYPanModalContentView<TFYPanModalPresentable> *)contentView;

/**
 * 展示弹窗
 */
- (void)show;

/**
 * 关闭弹窗
 * @param flag 是否动画
 * @param completion 关闭完成回调
 */
- (void)dismissAnimated:(BOOL)flag completion:(void (^ _Nullable)(void))completion;

/**
 * 强制刷新布局
 */
- (void)setNeedsLayoutUpdate;

/**
 * 刷新用户交互行为（如事件穿透等）
 */
- (void)updateUserHitBehavior;

/**
 * 切换弹窗状态
 * @param state 目标状态
 * @param animated 是否动画
 */
- (void)transitionToState:(PresentationState)state animated:(BOOL)animated;

/**
 * 设置滚动视图的contentOffset
 * @param offset 偏移量
 * @param animated 是否动画
 */
- (void)setScrollableContentOffset:(CGPoint)offset animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
