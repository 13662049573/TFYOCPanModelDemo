//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYDimmedView.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
@class TFYBackgroundConfig;

NS_ASSUME_NONNULL_BEGIN

/**
 * DimState
 * 遮罩视图的显示状态
 */
typedef NS_ENUM(NSInteger, DimState) {
	DimStateMax,      ///< 最大遮罩（全黑/全模糊）
	DimStateOff,      ///< 关闭遮罩（全透明）
	DimStatePercent,  ///< 按百分比显示遮罩
};

/**
 * 点击遮罩回调Block
 */
typedef void(^didTap)(UITapGestureRecognizer *recognizer);

/**
 * TFYDimmedView
 * PanModal弹窗的背景遮罩视图，支持透明度/模糊/点击事件等
 *
 * 主要特性：
 * 1. 支持iOS 13+深色模式自动切换背景色
 * 2. 支持iPad安全区（Safe Area）自动适配，防止遮罩遮挡系统区域
 * 3. 支持无障碍（可访问性），自动为VoiceOver等辅助功能提供友好标签
 * 4. 支持自定义点击回调、模糊效果、动态配置
 */
@interface TFYDimmedView : UIView

/**
 * 遮罩显示状态
 */
@property (nonatomic, assign) DimState dimState;
/**
 * 遮罩显示百分比（0~1）
 */
@property (nonatomic, assign) CGFloat percent;
/**
 * 遮罩点击回调
 */
@property (nullable, nonatomic, copy) didTap tapBlock;
/**
 * 模糊遮罩的tint颜色
 */
@property (nullable, nonatomic, strong) UIColor *blurTintColor;
/**
 * 背景配置对象（只读）
 */
@property (nonatomic, readonly, nonnull) TFYBackgroundConfig *backgroundConfig;

/**
 * 初始化方法，指定最大透明度和最大模糊半径
 * @param dimAlpha 最大透明度
 * @param blurRadius 最大模糊半径
 */
- (instancetype)initWithDimAlpha:(CGFloat)dimAlpha blurRadius:(CGFloat)blurRadius;

/**
 * 初始化方法，指定背景配置对象
 * @param backgroundConfig 背景配置
 */
- (instancetype)initWithBackgroundConfig:(nonnull TFYBackgroundConfig *)backgroundConfig;

/**
 * 重新加载背景配置
 * @param backgroundConfig 新的背景配置
 */
- (void)reloadConfig:(nonnull TFYBackgroundConfig *)backgroundConfig;

@end

NS_ASSUME_NONNULL_END
