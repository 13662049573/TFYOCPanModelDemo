//
//  TFYPopupBackgroundView.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗背景视图实现
//

#import <TFYOCPanlModel/TFYPopupBackgroundView.h>

@interface TFYPopupBackgroundView ()

@property (nonatomic, strong, nullable) UIVisualEffectView *effectView;
@property (nonatomic, strong, nullable) CAGradientLayer *gradientLayer;

@end

@implementation TFYPopupBackgroundView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

#pragma mark - Setup

- (void)setupView {
    _style = TFYPopupBackgroundStyleSolidColor;
    _color = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _blurEffectStyle = UIBlurEffectStyleDark;
    _gradientColors = @[
        [[UIColor blackColor] colorWithAlphaComponent:0.5],
        [[UIColor blackColor] colorWithAlphaComponent:0.3]
    ];
    _gradientLocations = @[@0.0, @1.0];
    _gradientStartPoint = CGPointMake(0.5, 0);
    _gradientEndPoint = CGPointMake(0.5, 1);
    
    self.layer.allowsGroupOpacity = NO;
    [self refreshBackgroundStyle];
}

#pragma mark - Properties

- (void)setStyle:(TFYPopupBackgroundStyle)style {
    if (_style != style) {
        _style = style;
        [self refreshBackgroundStyle];
    }
}

- (void)setColor:(UIColor *)color {
    if (_color != color) {
        _color = color;
        if (_style == TFYPopupBackgroundStyleSolidColor) {
            self.backgroundColor = color;
        }
    }
}

- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle {
    if (_blurEffectStyle != blurEffectStyle) {
        _blurEffectStyle = blurEffectStyle;
        if (_style == TFYPopupBackgroundStyleBlur) {
            [self refreshBackgroundStyle];
        }
    }
}

- (void)setGradientColors:(NSArray<UIColor *> *)gradientColors {
    if (_gradientColors != gradientColors) {
        _gradientColors = [gradientColors copy];
        if (_style == TFYPopupBackgroundStyleGradient) {
            [self refreshBackgroundStyle];
        }
    }
}

- (void)setGradientLocations:(NSArray<NSNumber *> *)gradientLocations {
    if (_gradientLocations != gradientLocations) {
        _gradientLocations = [gradientLocations copy];
        if (_style == TFYPopupBackgroundStyleGradient) {
            [self refreshBackgroundStyle];
        }
    }
}

- (void)setGradientStartPoint:(CGPoint)gradientStartPoint {
    if (!CGPointEqualToPoint(_gradientStartPoint, gradientStartPoint)) {
        _gradientStartPoint = gradientStartPoint;
        if (_style == TFYPopupBackgroundStyleGradient) {
            [self refreshBackgroundStyle];
        }
    }
}

- (void)setGradientEndPoint:(CGPoint)gradientEndPoint {
    if (!CGPointEqualToPoint(_gradientEndPoint, gradientEndPoint)) {
        _gradientEndPoint = gradientEndPoint;
        if (_style == TFYPopupBackgroundStyleGradient) {
            [self refreshBackgroundStyle];
        }
    }
}

#pragma mark - Private Methods

- (void)refreshBackgroundStyle {
    // 清除现有效果
    [self.effectView removeFromSuperview];
    self.effectView = nil;
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = nil;
    
    switch (self.style) {
        case TFYPopupBackgroundStyleSolidColor:
            self.backgroundColor = self.color;
            break;
            
        case TFYPopupBackgroundStyleBlur:
            self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:self.blurEffectStyle]];
            self.effectView.frame = self.bounds;
            [self insertSubview:self.effectView atIndex:0];
            break;
            
        case TFYPopupBackgroundStyleGradient: {
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = self.bounds;
            
            NSMutableArray *cgColors = [NSMutableArray array];
            for (UIColor *color in self.gradientColors) {
                [cgColors addObject:(__bridge id)color.CGColor];
            }
            self.gradientLayer.colors = cgColors;
            self.gradientLayer.locations = self.gradientLocations;
            self.gradientLayer.startPoint = self.gradientStartPoint;
            self.gradientLayer.endPoint = self.gradientEndPoint;
            
            [self.layer insertSublayer:self.gradientLayer atIndex:0];
            break;
        }
            
        case TFYPopupBackgroundStyleCustom:
            // 自定义样式由外部处理
            break;
    }
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    self.effectView.frame = self.bounds;
    self.gradientLayer.frame = self.bounds;
}

#pragma mark - Public Methods

- (void)applyBackgroundEffect:(TFYPopupBackgroundEffect)effect 
                customHandler:(TFYPopupBackgroundCustomHandler)customHandler {
    switch (effect) {
        case TFYPopupBackgroundEffectNone:
            self.backgroundColor = [UIColor clearColor];
            break;
            
        case TFYPopupBackgroundEffectBlur:
            [self applyBlurEffect:UIBlurEffectStyleDark];
            break;
            
        case TFYPopupBackgroundEffectGradient:
            [self applyGradientEffectWithColors:@[
                [[UIColor blackColor] colorWithAlphaComponent:0.5],
                [[UIColor blackColor] colorWithAlphaComponent:0.3]
            ] locations:@[@0.0, @1.0]];
            break;
            
        case TFYPopupBackgroundEffectDimmed:
            [self applyDimmedEffectWithColor:[UIColor blackColor] alpha:0.3];
            break;
            
        case TFYPopupBackgroundEffectCustom:
            if (customHandler) {
                customHandler(self);
            }
            break;
    }
}

- (void)applyBlurEffect:(UIBlurEffectStyle)style {
    // 移除现有效果视图
    if (self.effectView) {
        [self.effectView removeFromSuperview];
        self.effectView = nil;
    }
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:blurView atIndex:0];
    self.effectView = blurView;
}

- (void)applyGradientEffectWithColors:(NSArray<UIColor *> *)colors 
                            locations:(NSArray<NSNumber *> *)locations {
    // 移除现有渐变层
    if (self.gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
        self.gradientLayer = nil;
    }
    
    if (!colors || colors.count == 0) {
        return;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        if (color) {
            [cgColors addObject:(__bridge id)color.CGColor];
        }
    }
    
    if (cgColors.count == 0) {
        return;
    }
    
    gradientLayer.colors = cgColors;
    gradientLayer.locations = locations;
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
    self.gradientLayer = gradientLayer;
}

- (void)applyDimmedEffectWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    self.backgroundColor = [color colorWithAlphaComponent:alpha];
}

@end
