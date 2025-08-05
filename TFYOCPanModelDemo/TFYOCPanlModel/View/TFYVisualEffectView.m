//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYVisualEffectView.m
//  TFYPanModal
//
//  Created by heath wang on 2019/6/14.
//

#import "TFYVisualEffectView.h"

NSString * const kInternalCustomBlurEffect = @"_UICustomBlurEffect";
NSString * const kTFYBlurEffectColorTintKey = @"colorTint";
NSString * const kTFYBlurEffectColorTintAlphaKey = @"colorTintAlpha";
NSString * const kTFYBlurEffectBlurRadiusKey = @"blurRadius";
NSString * const kTFYBlurEffectScaleKey = @"scale";

@interface TFYVisualEffectView ()

@property (nonatomic, strong) UIVisualEffect *blurEffect;

@end

@implementation TFYVisualEffectView

@synthesize colorTint = _colorTint;
@synthesize colorTintAlpha = _colorTintAlpha;
@synthesize blurRadius = _blurRadius;
@synthesize scale = _scale;

#pragma mark - init

- (instancetype)initWithEffect:(UIVisualEffect *)effect {
    self = [super initWithEffect:effect];
    if (self) {
        self.scale = 1;
        if (effect) {
            self.blurEffect = effect;
        }
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scale = 1;
    }
    return self;
}

#pragma mark - public method

- (void)updateBlurEffect:(UIVisualEffect *)effect {
    if (!effect) return; // 防御性编程，防止崩溃
    self.blurEffect = effect;
    self.effect = self.blurEffect;
    // 确保effect生效
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

#pragma mark - private method

- (nullable id)__valueForKey:(NSString *)key {
    if (![NSStringFromClass(self.blurEffect.class) isEqualToString:kInternalCustomBlurEffect]) {
        return @(0);
    }
    return [self.blurEffect valueForKey:key];
}

- (void)__setValue:(id)value forKey:(NSString *)key {
    if (![NSStringFromClass(self.blurEffect.class) isEqualToString:kInternalCustomBlurEffect]) {
        self.effect = self.blurEffect;
        return;
    }
    [self.blurEffect setValue:value forKey:key];
    self.effect = self.blurEffect;
}

#pragma mark - Getter & Setter

- (UIVisualEffect *)blurEffect {
    if (!_blurEffect) {
        if (NSClassFromString(kInternalCustomBlurEffect)) {
            _blurEffect = (UIBlurEffect *)[NSClassFromString(@"_UICustomBlurEffect") new];
        } else {
            _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
    }
    
    return _blurEffect;
}

- (UIColor *)colorTint {
    return [self __valueForKey:kTFYBlurEffectColorTintKey];
}

- (void)setColorTint:(UIColor *)colorTint {
    [self __setValue:colorTint forKey:kTFYBlurEffectColorTintKey];
}

- (CGFloat)colorTintAlpha {
    return ((NSNumber *)[self __valueForKey:kTFYBlurEffectColorTintAlphaKey]).floatValue;
}

- (void)setColorTintAlpha:(CGFloat)colorTintAlpha {
    [self __setValue:@(colorTintAlpha) forKey:kTFYBlurEffectColorTintAlphaKey];
}

- (CGFloat)blurRadius {
    return ((NSNumber *)[self __valueForKey:kTFYBlurEffectBlurRadiusKey]).floatValue;
}

- (void)setBlurRadius:(CGFloat)blurRadius {
    [self __setValue:@(blurRadius) forKey:kTFYBlurEffectBlurRadiusKey];
}

- (CGFloat)scale {
    return ((NSNumber *)[self __valueForKey:kTFYBlurEffectScaleKey]).floatValue;
}

- (void)setScale:(CGFloat)scale {
     [self __setValue:@(scale) forKey:kTFYBlurEffectScaleKey];
}

- (void)dealloc {
    _blurEffect = nil;
}


@end
