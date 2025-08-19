//
//  TFYPopupViewDelegate.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗视图代理协议定义
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TFYPopupView;

/// 弹窗视图代理协议
NS_SWIFT_NAME(PopupViewDelegate)
@protocol TFYPopupViewDelegate <NSObject>

@required

/// 弹窗即将出现
/// @param popupView 弹窗实例
- (void)popupViewWillAppear:(TFYPopupView *)popupView NS_SWIFT_NAME(popupViewWillAppear(_:));

/// 弹窗已经出现
/// @param popupView 弹窗实例
- (void)popupViewDidAppear:(TFYPopupView *)popupView NS_SWIFT_NAME(popupViewDidAppear(_:));

/// 弹窗即将消失
/// @param popupView 弹窗实例
- (void)popupViewWillDisappear:(TFYPopupView *)popupView NS_SWIFT_NAME(popupViewWillDisappear(_:));

/// 弹窗已经消失
/// @param popupView 弹窗实例
- (void)popupViewDidDisappear:(TFYPopupView *)popupView NS_SWIFT_NAME(popupViewDidDisappear(_:));

/// 弹窗收到内存警告
/// @param popupView 弹窗实例
- (void)popupViewDidReceiveMemoryWarning:(TFYPopupView *)popupView NS_SWIFT_NAME(popupViewDidReceiveMemoryWarning(_:));

@optional

/// 弹窗是否应该消失（返回NO可阻止消失）
/// @param popupView 弹窗实例
/// @return 是否允许消失
- (BOOL)popupViewShouldDismiss:(TFYPopupView *)popupView NS_SWIFT_NAME(popupViewShouldDismiss(_:));

/// 点击了背景视图
/// @param popupView 弹窗实例
- (void)popupViewDidTapBackground:(TFYPopupView *)popupView NS_SWIFT_NAME(popupViewDidTapBackground(_:));

/// 通过滑动手势消失
/// @param popupView 弹窗实例
- (void)popupViewDidSwipeToDismiss:(TFYPopupView *)popupView NS_SWIFT_NAME(popupViewDidSwipeToDismiss(_:));

/// 通过拖拽手势消失
/// @param popupView 弹窗实例
- (void)popupViewDidDragToDismiss:(TFYPopupView *)popupView NS_SWIFT_NAME(popupViewDidDragToDismiss(_:));

@end

NS_ASSUME_NONNULL_END
