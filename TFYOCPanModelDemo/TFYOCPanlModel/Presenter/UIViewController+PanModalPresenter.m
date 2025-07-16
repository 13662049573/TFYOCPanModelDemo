//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  UIViewController+PanModalPresenter.m
//  TFYPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "UIViewController+PanModalPresenter.h"
#import "TFYPanModalPresentationDelegate.h"
#import <objc/runtime.h>

/**
 * @category UIViewController (PanModalPresenter)
 * @brief PanModal弹窗presenter扩展实现，便捷present/dismiss
 * @discussion 通过分类实现TFYPanModalPresenter协议，支持iPad popover和底部弹出，自动管理转场代理
 */

@implementation UIViewController (PanModalPresenter)

/**
 * @brief 判断当前是否为PanModal弹窗展示状态
 * @return YES为弹窗展示，NO为普通状态
 */
- (BOOL)isPanModalPresented {
	return [self.transitioningDelegate isKindOfClass:TFYPanModalPresentationDelegate.class];
}

/**
 * @brief iPad专用present方法，支持popover，带完成回调
 */
- (void)presentPanModal:(UIViewController<TFYPanModalPresentable> *)viewControllerToPresent sourceView:(UIView *)sourceView sourceRect:(CGRect)rect completion:(void (^)(void))completion {
    
    TFYPanModalPresentationDelegate *delegate = [TFYPanModalPresentationDelegate new];
    viewControllerToPresent.tfy_panModalPresentationDelegate = delegate;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad &&
        (sourceView && !CGRectEqualToRect(rect, CGRectZero))) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationPopover;
        viewControllerToPresent.popoverPresentationController.sourceRect = rect;
        viewControllerToPresent.popoverPresentationController.sourceView = sourceView;
        viewControllerToPresent.popoverPresentationController.delegate = delegate;
    } else {

        viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
        viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = YES;
        viewControllerToPresent.transitioningDelegate = delegate;
    }
    
    // fix for iOS 8 issue: the present action will delay.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:viewControllerToPresent animated:YES completion:completion];
    });
}

/**
 * @brief iPad专用present方法，支持popover
 */
- (void)presentPanModal:(UIViewController <TFYPanModalPresentable> *)viewControllerToPresent sourceView:(nullable UIView *)sourceView sourceRect:(CGRect)rect {
    [self presentPanModal:viewControllerToPresent sourceView:sourceView sourceRect:rect completion:nil];

}

/**
 * @brief 底部弹出present方法
 */
- (void)presentPanModal:(UIViewController <TFYPanModalPresentable> *)viewControllerToPresent {
	[self presentPanModal:viewControllerToPresent sourceView:nil sourceRect:CGRectZero];
}

/**
 * @brief 底部弹出present方法，带完成回调
 */
- (void)presentPanModal:(UIViewController<TFYPanModalPresentable> *)viewControllerToPresent completion:(void (^)(void))completion {
    [self presentPanModal:viewControllerToPresent sourceView:nil sourceRect:CGRectZero completion:completion];
}

/**
 * @brief 获取转场代理对象
 */
- (TFYPanModalPresentationDelegate *)tfy_panModalPresentationDelegate {
	return objc_getAssociatedObject(self, _cmd);
}

/**
 * @brief 设置转场代理对象
 */
- (void)setTfy_panModalPresentationDelegate:(TFYPanModalPresentationDelegate *)tfy_panModalPresentationDelegate {
	objc_setAssociatedObject(self, @selector(tfy_panModalPresentationDelegate), tfy_panModalPresentationDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
