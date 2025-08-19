//
//  TFYPopupContainerConfiguration.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗容器配置类，处理尺寸和布局相关设置
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIView;

/// 容器尺寸类型
typedef NS_ENUM(NSUInteger, TFYContainerDimensionType) {
    TFYContainerDimensionTypeFixed = 0,     // 固定尺寸
    TFYContainerDimensionTypeAutomatic,     // 自动尺寸
    TFYContainerDimensionTypeRatio,         // 比例尺寸
    TFYContainerDimensionTypeCustom         // 自定义尺寸
} NS_SWIFT_NAME(PopupContainerDimensionType);

/// 容器尺寸计算 block
typedef CGFloat (^TFYContainerDimensionHandler)(UIView *contentView) NS_SWIFT_NAME(PopupContainerDimensionHandler);

/// 容器尺寸配置类
NS_SWIFT_NAME(PopupContainerDimension)
@interface TFYPopupContainerDimension : NSObject <NSCopying>

@property (nonatomic, assign, readonly) TFYContainerDimensionType type;
@property (nonatomic, assign, readonly) CGFloat value;
@property (nonatomic, copy, readonly, nullable) TFYContainerDimensionHandler customHandler;

+ (instancetype)fixed:(CGFloat)value NS_SWIFT_NAME(fixed(_:));
+ (instancetype)automatic NS_SWIFT_NAME(automatic());
+ (instancetype)ratio:(CGFloat)ratio NS_SWIFT_NAME(ratio(_:));
+ (instancetype)customWithHandler:(TFYContainerDimensionHandler)handler NS_SWIFT_NAME(custom(handler:));

@end

/// 容器配置类
NS_SWIFT_NAME(PopupContainerConfiguration)
@interface TFYPopupContainerConfiguration : NSObject <NSCopying>

/// 宽度配置，默认固定280
@property (nonatomic, strong) TFYPopupContainerDimension *width;

/// 高度配置，默认自动
@property (nonatomic, strong) TFYPopupContainerDimension *height;

/// 最大宽度，可为空
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) BOOL hasMaxWidth;

/// 最大高度，可为空
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) BOOL hasMaxHeight;

/// 最小宽度，可为空
@property (nonatomic, assign) CGFloat minWidth;
@property (nonatomic, assign) BOOL hasMinWidth;

/// 最小高度，可为空
@property (nonatomic, assign) CGFloat minHeight;
@property (nonatomic, assign) BOOL hasMinHeight;

/// 内容边距，默认 (20, 20, 20, 20)
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/// 圆角半径，默认 0
@property (nonatomic, assign) CGFloat cornerRadius;

/// 是否启用阴影，默认 NO
@property (nonatomic, assign) BOOL shadowEnabled;

/// 阴影颜色，默认黑色
@property (nonatomic, strong) UIColor *shadowColor;

/// 阴影透明度，默认 0.3
@property (nonatomic, assign) float shadowOpacity;

/// 阴影半径，默认 5
@property (nonatomic, assign) CGFloat shadowRadius;

/// 阴影偏移，默认 (0, 0)
@property (nonatomic, assign) CGSize shadowOffset;

/// 默认初始化
- (instancetype)init;

/// 验证配置是否有效
- (BOOL)validate NS_SWIFT_NAME(validate());

@end

NS_ASSUME_NONNULL_END
