//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  UIViewController+PanModalPresenter.m
//  TFYPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import "UIViewController+PanModalPresenter.h"
#import "TFYPanModalPresentationDelegate.h"
#import "TFYPanModalFrequentTapPrevention.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

/// 缓存待present的弹窗信息结构体
@interface TFYPanModalPendingPresentInfo : NSObject
@property (nonatomic, weak) UIViewController *hostVC;
@property (nonatomic, strong) UIViewController<TFYPanModalPresentable> *viewControllerToPresent;
@property (nonatomic, weak) UIView *sourceView;
@property (nonatomic, assign) CGRect sourceRect;
@property (nonatomic, copy) void (^completion)(void);
@end
@implementation TFYPanModalPendingPresentInfo @end

static const void *kTFYPanModalPendingPresentInfoKey = &kTFYPanModalPendingPresentInfoKey;

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
    // 判断当前App是否在前台
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        // 缓存present请求
        TFYPanModalPendingPresentInfo *pendingInfo = [TFYPanModalPendingPresentInfo new];
        pendingInfo.hostVC = self;
        pendingInfo.viewControllerToPresent = viewControllerToPresent;
        pendingInfo.sourceView = sourceView;
        pendingInfo.sourceRect = rect;
        pendingInfo.completion = completion;
        objc_setAssociatedObject(self, kTFYPanModalPendingPresentInfoKey, pendingInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // 注册前台监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pan_handlePanModalPendingPresent) name:UIApplicationDidBecomeActiveNotification object:nil];
        return;
    }
    
    // 检查防频繁点击
    if ([viewControllerToPresent respondsToSelector:@selector(shouldPreventFrequentTapping)] &&
        [viewControllerToPresent shouldPreventFrequentTapping]) {
        
        // 创建临时的防频繁点击管理器进行检查
        NSTimeInterval interval = [viewControllerToPresent respondsToSelector:@selector(frequentTapPreventionInterval)] ? 
                                 [viewControllerToPresent frequentTapPreventionInterval] : 1.0;
        
        static NSMutableDictionary *preventionDict = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            preventionDict = [NSMutableDictionary dictionary];
        });
        
        NSString *key = NSStringFromClass([viewControllerToPresent class]);
        TFYPanModalFrequentTapPrevention *prevention = preventionDict[key];
        if (!prevention) {
            prevention = [TFYPanModalFrequentTapPrevention preventionWithInterval:interval];
            preventionDict[key] = prevention;
        }
        
        // 检查是否可以执行
        if (![prevention canExecute]) {
            // 显示提示
            if ([viewControllerToPresent respondsToSelector:@selector(shouldShowFrequentTapPreventionHint)] &&
                [viewControllerToPresent shouldShowFrequentTapPreventionHint]) {
                
                NSString *hintText = [viewControllerToPresent respondsToSelector:@selector(frequentTapPreventionHintText)] ?
                                    [viewControllerToPresent frequentTapPreventionHintText] : @"请稍后再试";
                
                // 显示提示
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                             message:hintText
                                                                      preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                
                // 2秒后自动消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alert dismissViewControllerAnimated:YES completion:nil];
                });
            }
            
            // 通知状态变更
            if ([viewControllerToPresent respondsToSelector:@selector(panModalFrequentTapPreventionStateChanged:remainingTime:)]) {
                NSTimeInterval remainingTime = [prevention getRemainingTime];
                [viewControllerToPresent panModalFrequentTapPreventionStateChanged:YES remainingTime:remainingTime];
            }
            
            return;
        }
        
        // 触发防频繁点击
        [prevention triggerPrevention];
    }
    
    TFYPanModalPresentationDelegate *delegate = [TFYPanModalPresentationDelegate new];
    viewControllerToPresent.pan_panModalPresentationDelegate = delegate;

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

/// 前台回调，自动present缓存的弹窗
- (void)pan_handlePanModalPendingPresent {
    TFYPanModalPendingPresentInfo *pendingInfo = objc_getAssociatedObject(self, kTFYPanModalPendingPresentInfoKey);
    if (pendingInfo && pendingInfo.hostVC) {
        // 移除监听和缓存
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        objc_setAssociatedObject(self, kTFYPanModalPendingPresentInfoKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // 重新present
        [pendingInfo.hostVC presentPanModal:pendingInfo.viewControllerToPresent sourceView:pendingInfo.sourceView sourceRect:pendingInfo.sourceRect completion:pendingInfo.completion];
    }
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
- (TFYPanModalPresentationDelegate *)pan_panModalPresentationDelegate {
	return objc_getAssociatedObject(self, _cmd);
}

/**
 * @brief 设置转场代理对象
 */
- (void)setPan_panModalPresentationDelegate:(TFYPanModalPresentationDelegate *)pan_panModalPresentationDelegate {
	objc_setAssociatedObject(self, @selector(pan_panModalPresentationDelegate), pan_panModalPresentationDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
