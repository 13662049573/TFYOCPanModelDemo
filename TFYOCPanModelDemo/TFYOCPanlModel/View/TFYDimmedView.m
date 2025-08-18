//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYDimmedView.m
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import "TFYDimmedView.h"
#import "TFYVisualEffectView.h"
#import "TFYBackgroundConfig.h"

@interface TFYDimmedView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) TFYVisualEffectView *blurView;
@property (nonatomic, strong) TFYBackgroundConfig *backgroundConfig;

@property (nonatomic, assign) CGFloat maxDimAlpha;
@property (nonatomic, assign) CGFloat maxBlurRadius;
@property (nonatomic, assign) CGFloat maxBlurTintAlpha;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) BOOL isBlurMode;

@end

@implementation TFYDimmedView

// =====================
// 详细中文注释与健壮性补充
// =====================
//
// 1. 构造方法、布局、点击、配置等关键方法补充中文注释
// 2. 重要属性、内部状态、回调点补充注释
// 3. 关键分支、易混淆逻辑增加注释说明
//
//  Created by heath wang on 2019/4/26.
//

- (instancetype)initWithDimAlpha:(CGFloat)dimAlpha blurRadius:(CGFloat)blurRadius {
	self = [super initWithFrame:CGRectZero];
	if (self) {
		_maxBlurRadius = blurRadius;
		_maxDimAlpha = dimAlpha;
        [self commonInit];
    }

	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_maxDimAlpha = 0.7;
        [self commonInit];
    }

	return self;
}

- (instancetype)initWithBackgroundConfig:(TFYBackgroundConfig *)backgroundConfig {
	self = [super initWithFrame:CGRectZero];
	if (self) {
		self.backgroundConfig = backgroundConfig;
		_maxDimAlpha = backgroundConfig.backgroundAlpha;
		_maxBlurRadius = backgroundConfig.backgroundBlurRadius;
		_blurTintColor = backgroundConfig.blurTintColor;

		[self commonInit];
	}

	return self;
}

- (void)commonInit {
    _dimState = DimStateOff;
    _maxBlurTintAlpha = 0.5;
    // default, max alpha.
    _percent = 1;
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
    [self addGestureRecognizer:_tapGestureRecognizer];

    // 可访问性支持
    self.isAccessibilityElement = YES;
    self.accessibilityLabel = @"弹窗背景遮罩";
    self.accessibilityTraits = UIAccessibilityTraitButton;

    [self setupView];
}

- (void)setupView {
	self.isBlurMode = self.maxBlurRadius > 0 || self.backgroundConfig.visualEffect;
	if (self.isBlurMode) {
		[self addSubview:self.blurView];
        [self configBlurView];
	} else {
		[self addSubview:self.backgroundView];
	}
    
    // 确保视图可见
    self.backgroundColor = [UIColor clearColor];
    
    // 强制更新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    static CGRect lastBounds = {0};
    if (CGRectEqualToRect(lastBounds, self.bounds)) return; // frame未变时不刷新，提升性能
    lastBounds = self.bounds;
    _blurView.frame = self.bounds;
    _backgroundView.frame = self.bounds;
#if TARGET_OS_IOS
    // iPad安全区适配
    if (@available(iOS 11.0, *)) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            UIEdgeInsets safeInsets = self.safeAreaInsets;
            _blurView.frame = UIEdgeInsetsInsetRect(self.bounds, safeInsets);
            _backgroundView.frame = UIEdgeInsetsInsetRect(self.bounds, safeInsets);
        }
    }
#endif
}

#pragma mark - touch action

- (void)didTapView {
	self.tapBlock ? self.tapBlock(self.tapGestureRecognizer) : nil;
}

#pragma mark - public method

- (void)reloadConfig:(TFYBackgroundConfig *)backgroundConfig {
    // 保存当前状态
    DimState currentState = self.dimState;
    CGFloat currentPercent = self.percent;
    
    // 移除所有子视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // 更新配置
    self.backgroundConfig = backgroundConfig;
    _maxDimAlpha = backgroundConfig.backgroundAlpha;
    _maxBlurRadius = backgroundConfig.backgroundBlurRadius;
    _blurTintColor = backgroundConfig.blurTintColor;
    
    // 重新设置视图
    [self setupView];
    
    // 恢复状态
    self.dimState = currentState;
    self.percent = currentPercent;
}

#pragma mark - private method

- (void)updateAlpha {
	CGFloat alpha = 0;
	CGFloat blurRadius = 0;
	CGFloat blurTintAlpha = 0;

	switch (self.dimState) {
		case DimStateMax:{
			alpha = self.maxDimAlpha;
			blurRadius = self.maxBlurRadius;
            blurTintAlpha = self.maxBlurTintAlpha;
		}
			break;
		case DimStatePercent: {
			CGFloat percent = MAX(0, MIN(1.0f, self.percent));
			alpha = self.maxDimAlpha * percent;
			blurRadius = self.maxBlurRadius * percent;
            blurTintAlpha = self.maxBlurTintAlpha * percent;
		}
		default:
			break;
	}

	if (self.isBlurMode) {
		if (self.backgroundConfig.visualEffect) {
			// 当使用visualEffect时，设置blurView的alpha值
			self.blurView.alpha = alpha;
			// 确保visualEffect可见
			self.blurView.hidden = (alpha <= 0);
			// 强制更新
			[self.blurView setNeedsDisplay];
		} else {
			self.blurView.blurRadius = blurRadius;
			self.blurView.colorTintAlpha = blurTintAlpha;
		}
	} else {
		self.backgroundView.alpha = alpha;
	}
}

- (void)configBlurView {
    if (self.backgroundConfig.visualEffect) {
        [_blurView updateBlurEffect:self.backgroundConfig.visualEffect];
        // 不强制设置alpha，让updateAlpha方法来控制
    } else {
        _blurView.colorTint = [UIColor whiteColor];
        _blurView.colorTintAlpha = self.maxBlurTintAlpha;
        _blurView.userInteractionEnabled = NO;
    }
}

#pragma mark - Setter

- (void)setDimState:(DimState)dimState {
	_dimState = dimState;
	[self updateAlpha];
}

- (void)setPercent:(CGFloat)percent {
	_percent = percent;
	[self updateAlpha];
}

#pragma mark - Getter

- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [UIView new];
		_backgroundView.userInteractionEnabled = NO;
		_backgroundView.alpha = 0;
        _backgroundView.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor colorWithWhite:0 alpha:0.6]; // 深色模式下更浅的黑色
            } else {
                return [UIColor blackColor];
            }
        }];
	}
	return _backgroundView;
}

- (TFYVisualEffectView *)blurView {
	if (!_blurView) {
		_blurView = [TFYVisualEffectView new];
        // 确保blurView正确初始化
        _blurView.userInteractionEnabled = NO;
	}
	return _blurView;
}

#pragma mark - Setter

- (void)setBlurTintColor:(UIColor *)blurTintColor {
    _blurTintColor = blurTintColor;
    _blurView.colorTint = _blurTintColor;
}

- (void)dealloc {
    self.tapBlock = nil;
    if (_tapGestureRecognizer) {
        [self removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}


@end
