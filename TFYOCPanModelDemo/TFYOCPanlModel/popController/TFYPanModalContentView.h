//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalContentView.h
//  TFYPanModal
//
//  Created by heath wang on 2019/10/17.
//

#import <UIKit/UIKit.h>
#import <TFYOCPanlModel/TFYPanModalPresentable.h>
#import <TFYOCPanlModel/TFYPanModalPresentationUpdateProtocol.h>
#import <TFYOCPanlModel/UIViewController+LayoutHelper.h>
#import <TFYOCPanlModel/TFYPanModalPanGestureDelegate.h>

@class TFYPanModalContainerView;

NS_ASSUME_NONNULL_BEGIN

/**
 * TFYPanModalContentView
 * PanModal弹窗内容视图，支持独立present/dismiss，需手动适配安全区
 * 遵循TFYPanModalPresentable等协议，支持高度、动画、手势、展示更新等配置
 */
NS_SWIFT_NAME(PanModalContentView)
@interface TFYPanModalContentView : UIView <TFYPanModalPresentable, TFYPanModalPanGestureDelegate, TFYPanModalPresentationUpdateProtocol, TFYPanModalPresentableLayoutProtocol>

/**
 * 在指定视图中present弹窗内容
 * @param view 目标父视图，若为nil则自动使用keyWindow
 */
- (void)presentInView:(nullable UIView *)view NS_SWIFT_NAME(present(in:));

/**
 * 关闭弹窗内容
 * @param flag 是否动画
 * @param completion 关闭完成回调
 */
- (void)dismissAnimated:(BOOL)flag completion:(void (^)(void))completion NS_SWIFT_NAME(dismiss(animated:completion:));

@end

NS_ASSUME_NONNULL_END
