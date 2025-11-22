//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalPresenterProtocol.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFYPanModalPresentable.h"

@class TFYPanModalPresentationDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 * @protocol TFYPanModalPresenter
 * @brief PanModal弹窗的presenter协议，统一管理present/dismiss流程
 * @discussion 提供多种present方式，支持iPad popover和底部弹出，便于扩展和维护
 */
@protocol TFYPanModalPresenter <NSObject>

/**
 * @brief 当前是否为PanModal弹窗展示状态
 */
@property (nonatomic, assign, readonly) BOOL isPanModalPresented;
/**
 * @brief 转场代理对象，内部通过runtime存储
 */
@property (nonatomic, strong, nonnull) TFYPanModalPresentationDelegate *pan_panModalPresentationDelegate;

/**
 * @brief iPad专用present方法，支持popover
 * @param viewControllerToPresent 需present的控制器
 * @param sourceView popover锚点视图
 * @param rect popover锚点区域
 */
- (void)presentPanModal:(nonnull UIViewController<TFYPanModalPresentable> *)viewControllerToPresent
             sourceView:(nullable UIView *)sourceView
             sourceRect:(CGRect)rect;

/**
 * @brief iPad专用present方法，支持popover，带完成回调
 * @param viewControllerToPresent 需present的控制器
 * @param sourceView popover锚点视图
 * @param rect popover锚点区域
 * @param completion 完成回调
 */
- (void)presentPanModal:(nonnull UIViewController<TFYPanModalPresentable> *)viewControllerToPresent
             sourceView:(nullable UIView *)sourceView
             sourceRect:(CGRect)rect
             completion:(void (^ __nullable)(void))completion;

/**
 * @brief 底部弹出present方法
 * @param viewControllerToPresent 需present的控制器
 */
- (void)presentPanModal:(nonnull UIViewController<TFYPanModalPresentable> *)viewControllerToPresent;

/**
 * @brief 底部弹出present方法，带完成回调
 * @param viewControllerToPresent 需present的控制器
 * @param completion 完成回调
 */
- (void)presentPanModal:(nonnull UIViewController<TFYPanModalPresentable> *)viewControllerToPresent
             completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END

