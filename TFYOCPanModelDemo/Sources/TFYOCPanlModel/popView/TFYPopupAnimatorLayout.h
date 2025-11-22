//

#ifndef TFYPOPUPANIMATORLAYOUT_H
#define TFYPOPUPANIMATORLAYOUT_H

//  TFYPopupAnimatorLayout.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗动画器布局配置类
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TFYPopupAnimatorLayoutCenter;
@class TFYPopupAnimatorLayoutTop;
@class TFYPopupAnimatorLayoutBottom;
@class TFYPopupAnimatorLayoutLeading;
@class TFYPopupAnimatorLayoutTrailing;

/// 动画器布局类型
typedef NS_ENUM(NSUInteger, TFYPopupAnimatorLayoutType) {
    TFYPopupAnimatorLayoutTypeCenter = 0,   // 居中布局
    TFYPopupAnimatorLayoutTypeTop,          // 顶部布局
    TFYPopupAnimatorLayoutTypeBottom,       // 底部布局
    TFYPopupAnimatorLayoutTypeLeading,      // 左侧布局
    TFYPopupAnimatorLayoutTypeTrailing,     // 右侧布局
    TFYPopupAnimatorLayoutTypeFrame         // 固定框架布局
} NS_SWIFT_NAME(PopupAnimatorLayoutType);

/// 布局配置基类
NS_SWIFT_NAME(PopupAnimatorLayout)
@interface TFYPopupAnimatorLayout : NSObject <NSCopying>

@property (nonatomic, assign, readonly) TFYPopupAnimatorLayoutType type;

/// 创建居中布局
+ (instancetype)centerLayout:(TFYPopupAnimatorLayoutCenter *)center NS_SWIFT_NAME(center(_:));

/// 创建顶部布局
+ (instancetype)topLayout:(TFYPopupAnimatorLayoutTop *)top NS_SWIFT_NAME(top(_:));

/// 创建底部布局
+ (instancetype)bottomLayout:(TFYPopupAnimatorLayoutBottom *)bottom NS_SWIFT_NAME(bottom(_:));

/// 创建左侧布局
+ (instancetype)leadingLayout:(TFYPopupAnimatorLayoutLeading *)leading NS_SWIFT_NAME(leading(_:));

/// 创建右侧布局
+ (instancetype)trailingLayout:(TFYPopupAnimatorLayoutTrailing *)trailing NS_SWIFT_NAME(trailing(_:));

/// 创建固定框架布局
+ (instancetype)frameLayout:(CGRect)frame NS_SWIFT_NAME(frame(_:));

/// 获取X偏移量
- (CGFloat)offsetX NS_SWIFT_NAME(offsetX());

/// 获取Y偏移量
- (CGFloat)offsetY NS_SWIFT_NAME(offsetY());

/// 内部属性（子类使用）
@property (nonatomic, strong, nullable) TFYPopupAnimatorLayoutCenter *centerLayout;
@property (nonatomic, strong, nullable) TFYPopupAnimatorLayoutTop *topLayout;
@property (nonatomic, strong, nullable) TFYPopupAnimatorLayoutBottom *bottomLayout;
@property (nonatomic, strong, nullable) TFYPopupAnimatorLayoutLeading *leadingLayout;
@property (nonatomic, strong, nullable) TFYPopupAnimatorLayoutTrailing *trailingLayout;
@property (nonatomic, assign) CGRect frameLayout;

@end

#pragma mark - Layout Structures

/// 居中布局配置
NS_SWIFT_NAME(PopupAnimatorLayoutCenter)
@interface TFYPopupAnimatorLayoutCenter : NSObject <NSCopying>

@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL hasWidth;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL hasHeight;

+ (instancetype)layoutWithOffsetY:(CGFloat)offsetY
                          offsetX:(CGFloat)offsetX
                            width:(CGFloat)width
                           height:(CGFloat)height NS_SWIFT_NAME(init(offsetY:offsetX:width:height:));

+ (instancetype)layoutWithOffsetY:(CGFloat)offsetY
                          offsetX:(CGFloat)offsetX NS_SWIFT_NAME(init(offsetY:offsetX:));

+ (instancetype)defaultLayout NS_SWIFT_NAME(default());

@end

/// 顶部布局配置
NS_SWIFT_NAME(PopupAnimatorLayoutTop)
@interface TFYPopupAnimatorLayoutTop : NSObject <NSCopying>

@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL hasWidth;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL hasHeight;

+ (instancetype)layoutWithTopMargin:(CGFloat)topMargin
                            offsetX:(CGFloat)offsetX
                              width:(CGFloat)width
                             height:(CGFloat)height NS_SWIFT_NAME(init(topMargin:offsetX:width:height:));

+ (instancetype)layoutWithTopMargin:(CGFloat)topMargin
                            offsetX:(CGFloat)offsetX NS_SWIFT_NAME(init(topMargin:offsetX:));

+ (instancetype)defaultLayout NS_SWIFT_NAME(default());

@end

/// 底部布局配置
NS_SWIFT_NAME(PopupAnimatorLayoutBottom)
@interface TFYPopupAnimatorLayoutBottom : NSObject <NSCopying>

@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL hasWidth;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL hasHeight;

+ (instancetype)layoutWithBottomMargin:(CGFloat)bottomMargin
                               offsetX:(CGFloat)offsetX
                                 width:(CGFloat)width
                                height:(CGFloat)height NS_SWIFT_NAME(init(bottomMargin:offsetX:width:height:));

+ (instancetype)layoutWithBottomMargin:(CGFloat)bottomMargin
                               offsetX:(CGFloat)offsetX NS_SWIFT_NAME(init(bottomMargin:offsetX:));

+ (instancetype)defaultLayout NS_SWIFT_NAME(default());

@end

/// 左侧布局配置
NS_SWIFT_NAME(PopupAnimatorLayoutLeading)
@interface TFYPopupAnimatorLayoutLeading : NSObject <NSCopying>

@property (nonatomic, assign) CGFloat leadingMargin;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL hasWidth;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL hasHeight;

+ (instancetype)layoutWithLeadingMargin:(CGFloat)leadingMargin
                                offsetY:(CGFloat)offsetY
                                  width:(CGFloat)width
                                 height:(CGFloat)height NS_SWIFT_NAME(init(leadingMargin:offsetY:width:height:));

+ (instancetype)layoutWithLeadingMargin:(CGFloat)leadingMargin
                                offsetY:(CGFloat)offsetY NS_SWIFT_NAME(init(leadingMargin:offsetY:));

+ (instancetype)defaultLayout NS_SWIFT_NAME(default());

@end

/// 右侧布局配置
NS_SWIFT_NAME(PopupAnimatorLayoutTrailing)
@interface TFYPopupAnimatorLayoutTrailing : NSObject <NSCopying>

@property (nonatomic, assign) CGFloat trailingMargin;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL hasWidth;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL hasHeight;

+ (instancetype)layoutWithTrailingMargin:(CGFloat)trailingMargin
                                 offsetY:(CGFloat)offsetY
                                   width:(CGFloat)width
                                  height:(CGFloat)height NS_SWIFT_NAME(init(trailingMargin:offsetY:width:height:));

+ (instancetype)layoutWithTrailingMargin:(CGFloat)trailingMargin
                                 offsetY:(CGFloat)offsetY NS_SWIFT_NAME(init(trailingMargin:offsetY:));

+ (instancetype)defaultLayout NS_SWIFT_NAME(default());

@end

NS_ASSUME_NONNULL_END

#endif /* TFYPOPUPANIMATORLAYOUT_H */
