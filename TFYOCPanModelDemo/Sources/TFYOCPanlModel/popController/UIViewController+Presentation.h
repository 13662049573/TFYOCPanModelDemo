//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。

#ifndef UIVIEWCONTROLLER_PRESENTATION_H
#define UIVIEWCONTROLLER_PRESENTATION_H

//
//  UIViewController+Presentation.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <TFYOCPanlModel/TFYPanModalPresentable.h>
#import <TFYOCPanlModel/TFYPanModalPresentationUpdateProtocol.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * The presented Controller can use the category to update UIPresentationController container.
 */
@interface UIViewController (Presentation) <TFYPanModalPresentationUpdateProtocol>

@end

NS_ASSUME_NONNULL_END

#endif /* UIVIEWCONTROLLER_PRESENTATION_H */
