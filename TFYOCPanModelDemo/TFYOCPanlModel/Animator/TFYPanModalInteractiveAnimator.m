//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalInteractiveAnimator.m
//  TFYPanModal
//
//  Created by heath wang on 2019/5/14.
//

#import "TFYPanModalInteractiveAnimator.h"

@implementation TFYPanModalInteractiveAnimator

/**
 * @brief 获取动画完成速度。
 * @return 返回动画完成的速度，0.618为黄金分割比，动画更自然。
 */
- (CGFloat)completionSpeed {
    // 返回值加边界保护，防止异常
    CGFloat speed = 0.618;
    if (speed < 0.1) speed = 0.1;
    if (speed > 1.0) speed = 1.0;
    return speed;
}

@end
