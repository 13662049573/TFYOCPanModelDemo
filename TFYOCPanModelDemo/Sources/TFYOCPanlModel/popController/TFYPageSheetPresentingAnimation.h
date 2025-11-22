//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。

#ifndef TFYPAGESHEETPRESENTINGANIMATION_H
#define TFYPAGESHEETPRESENTINGANIMATION_H

//
//  TFYPageSheetPresentingAnimation.h
//  TFYPanModal
//
//  Created by heath wang on 2019/9/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TFYOCPanlModel/TFYPresentingVCAnimatedTransitioning.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class TFYPageSheetPresentingAnimation
 * @brief 仿iOS页面表单样式的present动画实现类，实现TFYPresentingViewControllerAnimatedTransitioning协议。
 * @discussion 用于自定义present时的动画效果。
 */
@interface TFYPageSheetPresentingAnimation : NSObject <TFYPresentingViewControllerAnimatedTransitioning>

@end

NS_ASSUME_NONNULL_END

#endif /* TFYPAGESHEETPRESENTINGANIMATION_H */
