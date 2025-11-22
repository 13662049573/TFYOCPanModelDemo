//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。

#ifndef UIVIEWCONTROLLER_PANMODALPRESENTER_H
#define UIVIEWCONTROLLER_PANMODALPRESENTER_H

//
//  UIViewController+PanModalPresenter.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/29.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <TFYOCPanlModel/TFYPanModalPresenterProtocol.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @category UIViewController (PanModalPresenter)
 * @brief PanModal弹窗presenter扩展，便捷present/dismiss
 * @discussion 通过分类实现TFYPanModalPresenter协议，支持多种present方式
 */
@interface UIViewController (PanModalPresenter) <TFYPanModalPresenter>

@end

NS_ASSUME_NONNULL_END

#endif /* UIVIEWCONTROLLER_PANMODALPRESENTER_H */
