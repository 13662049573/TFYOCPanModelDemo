//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalPresentationUpdateProtocol.h
//  TFYPanModal
//
//  Created by heath wang on 2019/10/17.
//

#import "TFYPanModalPresentable.h"
@class TFYDimmedView;

/**
 * TFYPanModalPresentationUpdateProtocol
 * PanModal弹窗展示更新协议，支持动态切换状态、刷新布局、关闭弹窗等
 */
@protocol TFYPanModalPresentationUpdateProtocol <NSObject>
/**
 * 背景遮罩视图（只读）
 */
@property (nonatomic, readonly, nonnull) TFYDimmedView *tfy_dimmedView;
/**
 * 根容器视图（只读）
 */
@property (nonatomic, readonly, nonnull) UIView *tfy_rootContainerView;
/**
 * 内容视图（只读）
 */
@property (nonatomic, readonly, nonnull) UIView *tfy_contentView;
/**
 * 当前弹窗状态（只读）
 */
@property (nonatomic, readonly) PresentationState tfy_presentationState;
/**
 * 强制切换弹窗状态
 * @param state 目标状态
 */
- (void)tfy_panModalTransitionTo:(PresentationState)state NS_SWIFT_NAME(panModalTransitionTo(state:));
/**
 * 强制切换弹窗状态
 * @param state 目标状态
 * @param animated 是否动画
 */
- (void)tfy_panModalTransitionTo:(PresentationState)state animated:(BOOL)animated NS_SWIFT_NAME(panModalTransitionTo(state:animated:));
/**
 * 设置滚动视图的contentOffset（带动画）
 * @param offset 偏移量
 */
- (void)tfy_panModalSetContentOffset:(CGPoint)offset NS_SWIFT_NAME(panModalSetContentOffset(offset:));
/**
 * 设置滚动视图的contentOffset
 * @param offset 偏移量
 * @param animated 是否动画
 */
- (void)tfy_panModalSetContentOffset:(CGPoint)offset animated:(BOOL)animated NS_SWIFT_NAME(panModalSetContentOffset(offset:animated:));
/**
 * 强制刷新布局（如导航控制器push/pop时需调用）
 */
- (void)tfy_panModalSetNeedsLayoutUpdate NS_SWIFT_NAME(panModalSetNeedsLayoutUpdate());
/**
 * 刷新用户交互行为（如事件穿透等）
 */
- (void)tfy_panModalUpdateUserHitBehavior NS_SWIFT_NAME(panModalUpdateUserHitBehavior());
/**
 * 关闭弹窗
 * @param animated 是否动画
 * @param completion 关闭完成回调
 */
- (void)tfy_dismissAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion NS_SWIFT_NAME(panModalDismissAnimated(animated:completion:));

@end
