//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalShadow.m
//  TFYPanModal
//
//  Created by hb on 2023/8/3.
//

#import <TFYOCPanlModel/TFYPanModalShadow.h>

@implementation TFYPanModalShadow

// =====================
// 详细中文注释与健壮性补充
// =====================
//
// 1. 构造方法、无阴影工厂方法等补充中文注释
//
- (instancetype)initWithColor:(UIColor *)shadowColor shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity {
    self = [super init];
    if (self) {
        _shadowColor = shadowColor ? shadowColor : [UIColor clearColor]; // 防御性编程，防止崩溃
        _shadowRadius = shadowRadius;
        _shadowOffset = shadowOffset;
        _shadowOpacity = shadowOpacity;
    }
    
    return self;
}

// 2. 无阴影工厂方法补充中文注释
+ (instancetype)panModalShadowNil {
    return [[TFYPanModalShadow alloc] initWithColor:[UIColor clearColor] shadowRadius:0 shadowOffset:CGSizeZero shadowOpacity:0];
}

- (void)dealloc {
    _shadowColor = nil;
}

@end
