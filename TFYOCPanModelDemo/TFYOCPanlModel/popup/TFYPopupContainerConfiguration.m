//
//  TFYPopupContainerConfiguration.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗容器配置类实现
//

#import "TFYPopupContainerConfiguration.h"

#pragma mark - TFYPopupContainerDimension

@interface TFYPopupContainerDimension ()

@property (nonatomic, assign) TFYContainerDimensionType type;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, copy, nullable) TFYContainerDimensionHandler customHandler;

@end

@implementation TFYPopupContainerDimension

+ (instancetype)fixed:(CGFloat)value {
    TFYPopupContainerDimension *dimension = [[TFYPopupContainerDimension alloc] init];
    dimension.type = TFYContainerDimensionTypeFixed;
    dimension.value = value;
    return dimension;
}

+ (instancetype)automatic {
    TFYPopupContainerDimension *dimension = [[TFYPopupContainerDimension alloc] init];
    dimension.type = TFYContainerDimensionTypeAutomatic;
    dimension.value = 0;
    return dimension;
}

+ (instancetype)ratio:(CGFloat)ratio {
    TFYPopupContainerDimension *dimension = [[TFYPopupContainerDimension alloc] init];
    dimension.type = TFYContainerDimensionTypeRatio;
    dimension.value = ratio;
    return dimension;
}

+ (instancetype)customWithHandler:(TFYContainerDimensionHandler)handler {
    TFYPopupContainerDimension *dimension = [[TFYPopupContainerDimension alloc] init];
    dimension.type = TFYContainerDimensionTypeCustom;
    dimension.value = 0;
    dimension.customHandler = handler;
    return dimension;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupContainerDimension *copy = [[TFYPopupContainerDimension alloc] init];
    copy.type = self.type;
    copy.value = self.value;
    copy.customHandler = self.customHandler;
    return copy;
}

@end

#pragma mark - TFYPopupContainerConfiguration

@implementation TFYPopupContainerConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _width = [TFYPopupContainerDimension fixed:280];
        _height = [TFYPopupContainerDimension automatic];
        _hasMaxWidth = NO;
        _hasMaxHeight = NO;
        _hasMinWidth = NO;
        _hasMinHeight = NO;
        _contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        _cornerRadius = 0;
        _shadowEnabled = NO;
        _shadowColor = [UIColor blackColor];
        _shadowOpacity = 0.3f;
        _shadowRadius = 5;
        _shadowOffset = CGSizeZero;
    }
    return self;
}

- (BOOL)validate {
    if (self.hasMaxWidth && self.hasMinWidth) {
        if (self.maxWidth < self.minWidth) {
            return NO;
        }
    }
    if (self.hasMaxHeight && self.hasMinHeight) {
        if (self.maxHeight < self.minHeight) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupContainerConfiguration *copy = [[TFYPopupContainerConfiguration alloc] init];
    copy.width = [self.width copyWithZone:zone];
    copy.height = [self.height copyWithZone:zone];
    copy.maxWidth = self.maxWidth;
    copy.hasMaxWidth = self.hasMaxWidth;
    copy.maxHeight = self.maxHeight;
    copy.hasMaxHeight = self.hasMaxHeight;
    copy.minWidth = self.minWidth;
    copy.hasMinWidth = self.hasMinWidth;
    copy.minHeight = self.minHeight;
    copy.hasMinHeight = self.hasMinHeight;
    copy.contentInsets = self.contentInsets;
    copy.cornerRadius = self.cornerRadius;
    copy.shadowEnabled = self.shadowEnabled;
    copy.shadowColor = self.shadowColor;
    copy.shadowOpacity = self.shadowOpacity;
    copy.shadowRadius = self.shadowRadius;
    copy.shadowOffset = self.shadowOffset;
    return copy;
}

@end
