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
NS_SWIFT_NAME(TFYFrame)
@interface UIView (TFY_Frame)

/** frame.origin.x 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_left NS_SWIFT_NAME(left);
/** frame.origin.y 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_top NS_SWIFT_NAME(top);
/** frame.origin.x + frame.size.width 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_right NS_SWIFT_NAME(right);
/** frame.origin.y + frame.size.height 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_bottom NS_SWIFT_NAME(bottom);
/** frame.size.width 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_width NS_SWIFT_NAME(width);
/** frame.size.height 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_height NS_SWIFT_NAME(height);
/** center.x 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_centerX NS_SWIFT_NAME(centerX);
/** center.y 快捷访问/设置 */
@property (nonatomic, assign) CGFloat tfy_centerY NS_SWIFT_NAME(centerY);
/** frame.origin 快捷访问/设置 */
@property (nonatomic, assign) CGPoint tfy_origin NS_SWIFT_NAME(origin);
/** frame.size 快捷访问/设置 */
@property (nonatomic, assign) CGSize  tfy_size NS_SWIFT_NAME(size);

@end

NS_ASSUME_NONNULL_END
