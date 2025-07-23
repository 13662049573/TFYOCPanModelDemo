//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  UIScrollView+Helper.h
//  TFYPanModal
//
//  Created by heath wang on 2019/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @category UIScrollView (Helper)
 * @brief UIScrollView滚动状态辅助分类，提供便捷属性判断当前是否正在滚动。
 */
@interface UIScrollView (Helper)

/**
 * @brief 当前是否正在滚动（拖拽但未减速，或正在跟踪手势）。
 */
@property (nonatomic, assign, readonly) BOOL isScrolling;

/**
 * @brief 判断UIScrollView是否滚动到顶部
 */
- (BOOL)pan_isAtTop NS_SWIFT_NAME(isAtTop());

@end

NS_ASSUME_NONNULL_END
