//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalShadow.h
//  TFYPanModal
//
//  Created by hb on 2023/8/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * TFYPanModalShadow
 * PanModal弹窗阴影配置对象，支持自定义颜色、半径、偏移、透明度
 */
@interface TFYPanModalShadow : NSObject

/**
 * 阴影颜色
 */
@property (nonatomic, strong, nonnull) UIColor *shadowColor;
/**
 * 阴影半径
 */
@property (nonatomic, assign) CGFloat shadowRadius;
/**
 * 阴影偏移量
 */
@property (nonatomic, assign) CGSize shadowOffset;
/**
 * 阴影透明度
 */
@property (nonatomic, assign) CGFloat shadowOpacity;

/**
 * 初始化方法
 * @param shadowColor 阴影颜色
 * @param shadowRadius 阴影半径
 * @param shadowOffset 阴影偏移
 * @param shadowOpacity 阴影透明度
 */
- (instancetype)initWithColor:(nonnull UIColor *)shadowColor shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity;

/**
 * 返回无阴影配置
 */
+ (instancetype)panModalShadowNil;

@end

NS_ASSUME_NONNULL_END
