//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。

#ifndef TFYPANINDICATORVIEW_H
#define TFYPANINDICATORVIEW_H

//
//  TFYPanIndicatorView.h
//  TFYPanModal
//
//  Created by heath wang on 2019/5/16.
//

#import <UIKit/UIKit.h>
#import <TFYOCPanlModel/TFYPanModalIndicatorProtocol.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * TFYPanIndicatorView
 * PanModal拖拽指示器视图，支持自定义颜色
 */
NS_SWIFT_NAME(PanIndicatorView)
@interface TFYPanIndicatorView : UIView <TFYPanModalIndicatorProtocol>

/**
 * 指示器颜色，默认灰色
 */
@property (nonnull, nonatomic, strong) UIColor *indicatorColor;

@end

NS_ASSUME_NONNULL_END

#endif /* TFYPANINDICATORVIEW_H */
