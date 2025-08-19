//
//  TFYPopupAnimatorLayout.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗动画器布局配置类实现
//

#import "TFYPopupAnimatorLayout.h"

#pragma mark - TFYPopupAnimatorLayout

@interface TFYPopupAnimatorLayout ()

@property (nonatomic, assign) TFYPopupAnimatorLayoutType type;

@end

@implementation TFYPopupAnimatorLayout

+ (instancetype)centerLayout:(TFYPopupAnimatorLayoutCenter *)center {
    TFYPopupAnimatorLayout *layout = [[TFYPopupAnimatorLayout alloc] init];
    layout.type = TFYPopupAnimatorLayoutTypeCenter;
    layout.centerLayout = center;
    return layout;
}

+ (instancetype)topLayout:(TFYPopupAnimatorLayoutTop *)top {
    TFYPopupAnimatorLayout *layout = [[TFYPopupAnimatorLayout alloc] init];
    layout.type = TFYPopupAnimatorLayoutTypeTop;
    layout.topLayout = top;
    return layout;
}

+ (instancetype)bottomLayout:(TFYPopupAnimatorLayoutBottom *)bottom {
    TFYPopupAnimatorLayout *layout = [[TFYPopupAnimatorLayout alloc] init];
    layout.type = TFYPopupAnimatorLayoutTypeBottom;
    layout.bottomLayout = bottom;
    return layout;
}

+ (instancetype)leadingLayout:(TFYPopupAnimatorLayoutLeading *)leading {
    TFYPopupAnimatorLayout *layout = [[TFYPopupAnimatorLayout alloc] init];
    layout.type = TFYPopupAnimatorLayoutTypeLeading;
    layout.leadingLayout = leading;
    return layout;
}

+ (instancetype)trailingLayout:(TFYPopupAnimatorLayoutTrailing *)trailing {
    TFYPopupAnimatorLayout *layout = [[TFYPopupAnimatorLayout alloc] init];
    layout.type = TFYPopupAnimatorLayoutTypeTrailing;
    layout.trailingLayout = trailing;
    return layout;
}

+ (instancetype)frameLayout:(CGRect)frame {
    TFYPopupAnimatorLayout *layout = [[TFYPopupAnimatorLayout alloc] init];
    layout.type = TFYPopupAnimatorLayoutTypeFrame;
    layout.frameLayout = frame;
    return layout;
}

- (CGFloat)offsetX {
    switch (self.type) {
        case TFYPopupAnimatorLayoutTypeCenter:
            return self.centerLayout.offsetX;
        case TFYPopupAnimatorLayoutTypeTop:
            return self.topLayout.offsetX;
        case TFYPopupAnimatorLayoutTypeBottom:
            return self.bottomLayout.offsetX;
        case TFYPopupAnimatorLayoutTypeLeading:
        case TFYPopupAnimatorLayoutTypeTrailing:
        case TFYPopupAnimatorLayoutTypeFrame:
            return 0;
    }
}

- (CGFloat)offsetY {
    switch (self.type) {
        case TFYPopupAnimatorLayoutTypeCenter:
            return self.centerLayout.offsetY;
        case TFYPopupAnimatorLayoutTypeLeading:
            return self.leadingLayout.offsetY;
        case TFYPopupAnimatorLayoutTypeTrailing:
            return self.trailingLayout.offsetY;
        case TFYPopupAnimatorLayoutTypeTop:
        case TFYPopupAnimatorLayoutTypeBottom:
        case TFYPopupAnimatorLayoutTypeFrame:
            return 0;
    }
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupAnimatorLayout *copy = [[TFYPopupAnimatorLayout alloc] init];
    copy.type = self.type;
    copy.centerLayout = [self.centerLayout copyWithZone:zone];
    copy.topLayout = [self.topLayout copyWithZone:zone];
    copy.bottomLayout = [self.bottomLayout copyWithZone:zone];
    copy.leadingLayout = [self.leadingLayout copyWithZone:zone];
    copy.trailingLayout = [self.trailingLayout copyWithZone:zone];
    copy.frameLayout = self.frameLayout;
    return copy;
}

@end

#pragma mark - TFYPopupAnimatorLayoutCenter

@implementation TFYPopupAnimatorLayoutCenter

+ (instancetype)layoutWithOffsetY:(CGFloat)offsetY
                          offsetX:(CGFloat)offsetX
                            width:(CGFloat)width
                           height:(CGFloat)height {
    TFYPopupAnimatorLayoutCenter *layout = [[TFYPopupAnimatorLayoutCenter alloc] init];
    layout.offsetY = offsetY;
    layout.offsetX = offsetX;
    layout.width = width;
    layout.hasWidth = width > 0;
    layout.height = height;
    layout.hasHeight = height > 0;
    return layout;
}

+ (instancetype)layoutWithOffsetY:(CGFloat)offsetY offsetX:(CGFloat)offsetX {
    return [self layoutWithOffsetY:offsetY offsetX:offsetX width:0 height:0];
}

+ (instancetype)defaultLayout {
    return [self layoutWithOffsetY:0 offsetX:0 width:0 height:0];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupAnimatorLayoutCenter *copy = [[TFYPopupAnimatorLayoutCenter alloc] init];
    copy.offsetY = self.offsetY;
    copy.offsetX = self.offsetX;
    copy.width = self.width;
    copy.hasWidth = self.hasWidth;
    copy.height = self.height;
    copy.hasHeight = self.hasHeight;
    return copy;
}

@end

#pragma mark - TFYPopupAnimatorLayoutTop

@implementation TFYPopupAnimatorLayoutTop

+ (instancetype)layoutWithTopMargin:(CGFloat)topMargin
                            offsetX:(CGFloat)offsetX
                              width:(CGFloat)width
                             height:(CGFloat)height {
    TFYPopupAnimatorLayoutTop *layout = [[TFYPopupAnimatorLayoutTop alloc] init];
    layout.topMargin = topMargin;
    layout.offsetX = offsetX;
    layout.width = width;
    layout.hasWidth = width > 0;
    layout.height = height;
    layout.hasHeight = height > 0;
    return layout;
}

+ (instancetype)layoutWithTopMargin:(CGFloat)topMargin offsetX:(CGFloat)offsetX {
    return [self layoutWithTopMargin:topMargin offsetX:offsetX width:0 height:0];
}

+ (instancetype)defaultLayout {
    return [self layoutWithTopMargin:0 offsetX:0 width:0 height:0];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupAnimatorLayoutTop *copy = [[TFYPopupAnimatorLayoutTop alloc] init];
    copy.topMargin = self.topMargin;
    copy.offsetX = self.offsetX;
    copy.width = self.width;
    copy.hasWidth = self.hasWidth;
    copy.height = self.height;
    copy.hasHeight = self.hasHeight;
    return copy;
}

@end

#pragma mark - TFYPopupAnimatorLayoutBottom

@implementation TFYPopupAnimatorLayoutBottom

+ (instancetype)layoutWithBottomMargin:(CGFloat)bottomMargin
                               offsetX:(CGFloat)offsetX
                                 width:(CGFloat)width
                                height:(CGFloat)height {
    TFYPopupAnimatorLayoutBottom *layout = [[TFYPopupAnimatorLayoutBottom alloc] init];
    layout.bottomMargin = bottomMargin;
    layout.offsetX = offsetX;
    layout.width = width;
    layout.hasWidth = width > 0;
    layout.height = height;
    layout.hasHeight = height > 0;
    return layout;
}

+ (instancetype)layoutWithBottomMargin:(CGFloat)bottomMargin offsetX:(CGFloat)offsetX {
    return [self layoutWithBottomMargin:bottomMargin offsetX:offsetX width:0 height:0];
}

+ (instancetype)defaultLayout {
    return [self layoutWithBottomMargin:0 offsetX:0 width:0 height:0];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupAnimatorLayoutBottom *copy = [[TFYPopupAnimatorLayoutBottom alloc] init];
    copy.bottomMargin = self.bottomMargin;
    copy.offsetX = self.offsetX;
    copy.width = self.width;
    copy.hasWidth = self.hasWidth;
    copy.height = self.height;
    copy.hasHeight = self.hasHeight;
    return copy;
}

@end

#pragma mark - TFYPopupAnimatorLayoutLeading

@implementation TFYPopupAnimatorLayoutLeading

+ (instancetype)layoutWithLeadingMargin:(CGFloat)leadingMargin
                                offsetY:(CGFloat)offsetY
                                  width:(CGFloat)width
                                 height:(CGFloat)height {
    TFYPopupAnimatorLayoutLeading *layout = [[TFYPopupAnimatorLayoutLeading alloc] init];
    layout.leadingMargin = leadingMargin;
    layout.offsetY = offsetY;
    layout.width = width;
    layout.hasWidth = width > 0;
    layout.height = height;
    layout.hasHeight = height > 0;
    return layout;
}

+ (instancetype)layoutWithLeadingMargin:(CGFloat)leadingMargin offsetY:(CGFloat)offsetY {
    return [self layoutWithLeadingMargin:leadingMargin offsetY:offsetY width:0 height:0];
}

+ (instancetype)defaultLayout {
    return [self layoutWithLeadingMargin:0 offsetY:0 width:0 height:0];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupAnimatorLayoutLeading *copy = [[TFYPopupAnimatorLayoutLeading alloc] init];
    copy.leadingMargin = self.leadingMargin;
    copy.offsetY = self.offsetY;
    copy.width = self.width;
    copy.hasWidth = self.hasWidth;
    copy.height = self.height;
    copy.hasHeight = self.hasHeight;
    return copy;
}

@end

#pragma mark - TFYPopupAnimatorLayoutTrailing

@implementation TFYPopupAnimatorLayoutTrailing

+ (instancetype)layoutWithTrailingMargin:(CGFloat)trailingMargin
                                 offsetY:(CGFloat)offsetY
                                   width:(CGFloat)width
                                  height:(CGFloat)height {
    TFYPopupAnimatorLayoutTrailing *layout = [[TFYPopupAnimatorLayoutTrailing alloc] init];
    layout.trailingMargin = trailingMargin;
    layout.offsetY = offsetY;
    layout.width = width;
    layout.hasWidth = width > 0;
    layout.height = height;
    layout.hasHeight = height > 0;
    return layout;
}

+ (instancetype)layoutWithTrailingMargin:(CGFloat)trailingMargin offsetY:(CGFloat)offsetY {
    return [self layoutWithTrailingMargin:trailingMargin offsetY:offsetY width:0 height:0];
}

+ (instancetype)defaultLayout {
    return [self layoutWithTrailingMargin:0 offsetY:0 width:0 height:0];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupAnimatorLayoutTrailing *copy = [[TFYPopupAnimatorLayoutTrailing alloc] init];
    copy.trailingMargin = self.trailingMargin;
    copy.offsetY = self.offsetY;
    copy.width = self.width;
    copy.hasWidth = self.hasWidth;
    copy.height = self.height;
    copy.hasHeight = self.hasHeight;
    return copy;
}

@end
