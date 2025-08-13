//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  UIView+TFY_Frame.h
//  TFYPanModal
//
//  Created by heath wang on 2019/5/20.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * UIView (TFY_Frame)
 * UIView便捷布局扩展，提供frame/center/size等属性的快捷访问和设置
 */
@interface UIView (TFY_Frame)

/** frame.origin.x 快捷访问/设置 */
@property (nonatomic, assign) CGFloat pan_left NS_SWIFT_NAME(panLeft);
/** frame.origin.y 快捷访问/设置 */
@property (nonatomic, assign) CGFloat pan_top NS_SWIFT_NAME(panTop);
/** frame.origin.x + frame.size.width 快捷访问/设置 */
@property (nonatomic, assign) CGFloat pan_right NS_SWIFT_NAME(panRight);
/** frame.origin.y + frame.size.height 快捷访问/设置 */
@property (nonatomic, assign) CGFloat pan_bottom NS_SWIFT_NAME(panBottom);
/** frame.size.width 快捷访问/设置 */
@property (nonatomic, assign) CGFloat pan_width NS_SWIFT_NAME(panWidth);
/** frame.size.height 快捷访问/设置 */
@property (nonatomic, assign) CGFloat pan_height NS_SWIFT_NAME(panHeight);
/** center.x 快捷访问/设置 */
@property (nonatomic, assign) CGFloat pan_centerX NS_SWIFT_NAME(panCenterX);
/** center.y 快捷访问/设置 */
@property (nonatomic, assign) CGFloat pan_centerY NS_SWIFT_NAME(panCenterY);
/** frame.origin 快捷访问/设置 */
@property (nonatomic, assign) CGPoint pan_origin NS_SWIFT_NAME(panRrigin);
/** frame.size 快捷访问/设置 */
@property (nonatomic, assign) CGSize  pan_size NS_SWIFT_NAME(panSize);

@end

NS_ASSUME_NONNULL_END
