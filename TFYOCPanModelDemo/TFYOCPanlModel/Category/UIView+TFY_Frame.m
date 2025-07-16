//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  UIView+TFY_Frame.m
//  TFYPanModal
//
//  Created by heath wang on 2019/5/20.
//

#import "UIView+TFY_Frame.h"

@implementation UIView (TFY_Frame)

/**
 * @brief 获取frame.origin.x
 */
- (CGFloat)tfy_left {
	return self.frame.origin.x;
}

/**
 * @brief 设置frame.origin.x
 */
- (void)setTfy_left:(CGFloat)tfyLeft {
    if (self.frame.origin.x == tfyLeft) return;
    CGRect frame = self.frame;
    frame.origin.x = tfyLeft;
    self.frame = frame;
}

/**
 * @brief 获取frame.origin.y
 */
- (CGFloat)tfy_top {
	return self.frame.origin.y;
}

/**
 * @brief 设置frame.origin.y
 */
- (void)setTfy_top:(CGFloat)tfyTop {
    if (self.frame.origin.y == tfyTop) return;
    CGRect frame = self.frame;
    frame.origin.y = tfyTop;
    self.frame = frame;
}

/**
 * @brief 获取frame.origin.x + frame.size.width
 */
- (CGFloat)tfy_right {
	return self.frame.origin.x + self.frame.size.width;
}

/**
 * @brief 设置frame.origin.x + frame.size.width
 * @discussion 实际通过调整origin.x实现right的设置。
 */
- (void)setTfy_right:(CGFloat)tfyRight {
    if (self.tfy_right == tfyRight) return;
    CGRect frame = self.frame;
    frame.origin.x = tfyRight - self.frame.size.width;
    self.frame = frame;
}

/**
 * @brief 获取frame.origin.y + frame.size.height
 */
- (CGFloat)tfy_bottom {
	return self.frame.origin.y + self.frame.size.height;
}

/**
 * @brief 设置frame.origin.y + frame.size.height
 * @discussion 实际通过调整origin.y实现bottom的设置。
 */
- (void)setTfy_bottom:(CGFloat)tfyBottom {
    if (self.tfy_bottom == tfyBottom) return;
    CGRect frame = self.frame;
    frame.origin.y = tfyBottom - self.frame.size.height;
    self.frame = frame;
}

/**
 * @brief 获取frame.size.width
 */
- (CGFloat)tfy_width {
	return self.frame.size.width;
}

/**
 * @brief 设置frame.size.width
 */
- (void)setTfy_width:(CGFloat)tfyWidth {
    if (self.frame.size.width == tfyWidth) return;
    CGRect frame = self.frame;
    frame.size.width = tfyWidth;
    self.frame = frame;
}

/**
 * @brief 获取frame.size.height
 */
- (CGFloat)tfy_height {
	return self.frame.size.height;
}

/**
 * @brief 设置frame.size.height
 */
- (void)setTfy_height:(CGFloat)tfyHeight {
    if (self.frame.size.height == tfyHeight) return;
    CGRect frame = self.frame;
    frame.size.height = tfyHeight;
    self.frame = frame;
}

/**
 * @brief 获取center.x
 */
- (CGFloat)tfy_centerX {
	return self.center.x;
}

/**
 * @brief 设置center.x
 */
- (void)setTfy_centerX:(CGFloat)tfyCenterX {
    if (self.center.x == tfyCenterX) return;
    self.center = CGPointMake(tfyCenterX, self.center.y);
}

/**
 * @brief 获取center.y
 */
- (CGFloat)tfy_centerY {
	return self.center.y;
}

/**
 * @brief 设置center.y
 */
- (void)setTfy_centerY:(CGFloat)tfyCenterY {
    if (self.center.y == tfyCenterY) return;
    self.center = CGPointMake(self.center.x, tfyCenterY);
}

/**
 * @brief 获取frame.origin
 */
- (CGPoint)tfy_origin {
	return self.frame.origin;
}

/**
 * @brief 设置frame.origin
 */
- (void)setTfy_origin:(CGPoint)tfyOrigin {
    if (CGPointEqualToPoint(self.frame.origin, tfyOrigin)) return;
    CGRect frame = self.frame;
    frame.origin = tfyOrigin;
    self.frame = frame;
}

/**
 * @brief 获取frame.size
 */
- (CGSize)tfy_size {
	return self.frame.size;
}

/**
 * @brief 设置frame.size
 */
- (void)setTfy_size:(CGSize)tfySize {
    if (CGSizeEqualToSize(self.frame.size, tfySize)) return;
    CGRect frame = self.frame;
    frame.size = tfySize;
    self.frame = frame;
}


@end
