//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalIndicatorProtocol.h
//  TFYPanModal
//
//  Created by heath wang on 2019/8/9.
//

/**
 * TFYIndicatorState
 * 拖拽指示器的状态
 */
typedef NS_ENUM(NSUInteger, TFYIndicatorState) {
    TFYIndicatorStateNormal NS_SWIFT_NAME(normal),     ///< 默认状态
    TFYIndicatorStatePullDown NS_SWIFT_NAME(pull),     ///< 下拉状态
};

/**
 * 拖拽指示器顶部偏移量常量
 */
static CGFloat const kIndicatorYOffset = 5;

/**
 * TFYPanModalIndicatorProtocol
 * 拖拽指示器协议，支持自定义UI和状态切换
 */
@protocol TFYPanModalIndicatorProtocol <NSObject>

/**
 * 拖拽状态变更回调
 * @param state 当前状态
 */
- (void)didChangeToState:(TFYIndicatorState)state;
/**
 * 返回指示器尺寸
 */
- (CGSize)indicatorSize;
/**
 * 指示器添加到父视图时的布局回调
 */
- (void)setupSubviews;

@end

