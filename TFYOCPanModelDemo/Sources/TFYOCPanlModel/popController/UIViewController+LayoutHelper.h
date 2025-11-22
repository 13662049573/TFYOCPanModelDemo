//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  UIViewController+LayoutHelper.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class TFYPanModalPresentationController;

NS_ASSUME_NONNULL_BEGIN

@protocol TFYPanModalPresentableLayoutProtocol <NSObject>

@property (nonatomic, assign, readonly) CGFloat topLayoutOffset;

@property (nonatomic, assign, readonly) CGFloat bottomLayoutOffset;

@property (nonatomic, assign, readonly) CGFloat shortFormYPos;

@property (nonatomic, assign, readonly) CGFloat mediumFormYPos;

@property (nonatomic, assign, readonly) CGFloat longFormYPos;

@property (nonatomic, assign, readonly) CGFloat bottomYPos;

@end

/**
 * Help presentedViewController/presented View to layout.
 */
@interface UIViewController (LayoutHelper) <TFYPanModalPresentableLayoutProtocol>

@property (nullable, nonatomic, strong, readonly) TFYPanModalPresentationController *pan_presentedVC;

@end

NS_ASSUME_NONNULL_END
