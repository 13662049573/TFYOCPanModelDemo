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
@property (nonatomic, assign) CGFloat tfy_left;
/** frame.origin.y 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_top;
/** frame.origin.x + frame.size.width 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_right;
/** frame.origin.y + frame.size.height 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_bottom;
/** frame.size.width 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_width;
/** frame.size.height 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_height;
/** center.x 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_centerX;
/** center.y 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_centerY;
/** frame.origin 快捷访问/设置 */
@property (nonatomic, assign) CGPoint tfy_origin;
/** frame.size 快捷访问/设置 */
@property (nonatomic, assign) CGSize  tfy_size;

@end

NS_ASSUME_NONNULL_END
