//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  UIViewController+Presentation.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <UIKit/UIKit.h>
#import "TFYPanModalPresentable.h"
#import "TFYPanModalPresentationUpdateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * The presented Controller can use the category to update UIPresentationController container.
 */
@interface UIViewController (Presentation) <TFYPanModalPresentationUpdateProtocol>

@end

NS_ASSUME_NONNULL_END
