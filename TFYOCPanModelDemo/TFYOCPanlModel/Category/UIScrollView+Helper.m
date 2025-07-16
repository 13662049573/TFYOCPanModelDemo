//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  UIScrollView+Helper.m
//  TFYPanModal
//
//  Created by heath wang on 2019/10/15.
//

#import "UIScrollView+Helper.h"

@implementation UIScrollView (Helper)

/**
 * @brief 判断UIScrollView当前是否处于滚动状态。
 * @return YES表示正在滚动（拖拽但未减速，或正在跟踪手势）。
 */
- (BOOL)isScrolling {
    if (!self.window) return NO; // 未加入窗口时不认为在滚动，防止崩溃
    return (self.isDragging && !self.isDecelerating) || self.isTracking;
}

/**
 * @brief 判断UIScrollView是否滚动到顶部。
 * @return YES表示已在顶部。
 */
- (BOOL)tfy_isAtTop {
    return self.contentOffset.y <= -self.contentInset.top + 0.5;
}

@end
