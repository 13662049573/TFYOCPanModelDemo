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
- (CGFloat)pan_left {
	return self.frame.origin.x;
}

/**
 * @brief 设置frame.origin.x
 */
- (void)setPan_left:(CGFloat)panLeft {
    if (self.frame.origin.x == panLeft) return;
    CGRect frame = self.frame;
    frame.origin.x = panLeft;
    self.frame = frame;
}

/**
 * @brief 获取frame.origin.y
 */
- (CGFloat)pan_top {
	return self.frame.origin.y;
}

/**
 * @brief 设置frame.origin.y
 */
- (void)setPan_top:(CGFloat)panTop {
    if (self.frame.origin.y == panTop) return;
    CGRect frame = self.frame;
    frame.origin.y = panTop;
    self.frame = frame;
}

/**
 * @brief 获取frame.origin.x + frame.size.width
 */
- (CGFloat)pan_right {
	return self.frame.origin.x + self.frame.size.width;
}

/**
 * @brief 设置frame.origin.x + frame.size.width
 * @discussion 实际通过调整origin.x实现right的设置。
 */
- (void)setPan_right:(CGFloat)panRight {
    if (self.pan_right == panRight) return;
    CGRect frame = self.frame;
    frame.origin.x = panRight - self.frame.size.width;
    self.frame = frame;
}

/**
 * @brief 获取frame.origin.y + frame.size.height
 */
- (CGFloat)pan_bottom {
	return self.frame.origin.y + self.frame.size.height;
}

/**
 * @brief 设置frame.origin.y + frame.size.height
 * @discussion 实际通过调整origin.y实现bottom的设置。
 */
- (void)setPan_bottom:(CGFloat)panBottom {
    if (self.pan_bottom == panBottom) return;
    CGRect frame = self.frame;
    frame.origin.y = panBottom - self.frame.size.height;
    self.frame = frame;
}

/**
 * @brief 获取frame.size.width
 */
- (CGFloat)pan_width {
	return self.frame.size.width;
}

/**
 * @brief 设置frame.size.width
 */
- (void)setPan_width:(CGFloat)panWidth {
    if (self.frame.size.width == panWidth) return;
    CGRect frame = self.frame;
    frame.size.width = panWidth;
    self.frame = frame;
}

/**
 * @brief 获取frame.size.height
 */
- (CGFloat)pan_height {
	return self.frame.size.height;
}

/**
 * @brief 设置frame.size.height
 */
- (void)setPan_height:(CGFloat)panHeight {
    if (self.frame.size.height == panHeight) return;
    CGRect frame = self.frame;
    frame.size.height = panHeight;
    self.frame = frame;
}

/**
 * @brief 获取center.x
 */
- (CGFloat)pan_centerX {
	return self.center.x;
}

/**
 * @brief 设置center.x
 */
- (void)setPan_centerX:(CGFloat)panCenterX {
    if (self.center.x == panCenterX) return;
    self.center = CGPointMake(panCenterX, self.center.y);
}

/**
 * @brief 获取center.y
 */
- (CGFloat)pan_centerY {
	return self.center.y;
}

/**
 * @brief 设置center.y
 */
- (void)setPan_centerY:(CGFloat)panCenterY {
    if (self.center.y == panCenterY) return;
    self.center = CGPointMake(self.center.x, panCenterY);
}

/**
 * @brief 获取frame.origin
 */
- (CGPoint)pan_origin {
	return self.frame.origin;
}

/**
 * @brief 设置frame.origin
 */
- (void)setPan_origin:(CGPoint)panOrigin {
    if (CGPointEqualToPoint(self.frame.origin, panOrigin)) return;
    CGRect frame = self.frame;
    frame.origin = panOrigin;
    self.frame = frame;
}

/**
 * @brief 获取frame.size
 */
- (CGSize)pan_size {
	return self.frame.size;
}

/**
 * @brief 设置frame.size
 */
- (void)setPan_size:(CGSize)panSize {
    if (CGSizeEqualToSize(self.frame.size, panSize)) return;
    CGRect frame = self.frame;
    frame.size = panSize;
    self.frame = frame;
}


@end
