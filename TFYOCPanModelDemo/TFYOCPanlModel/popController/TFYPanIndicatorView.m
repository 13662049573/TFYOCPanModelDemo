//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanIndicatorView.m
//  TFYPanModal
//
//  Created by heath wang on 2019/5/16.
//

#import <TFYOCPanlModel/UIView+TFY_Frame.h>
#import <TFYOCPanlModel/TFYPanIndicatorView.h>

@interface TFYPanIndicatorView ()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, assign) TFYIndicatorState state;

@end

@implementation TFYPanIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:CGRectZero];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		[self addSubview:self.leftView];
		[self addSubview:self.rightView];
		self.indicatorColor = [UIColor colorWithRed:0.792 green:0.788 blue:0.812 alpha:1.00];
	}

	return self;
}

- (void)animate:(void (^)(void))animations {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:animations completion:^(BOOL finished) {
        // nothing
    }];
}

#pragma mark - TFYPanModalIndicatorProtocol

- (void)didChangeToState:(TFYIndicatorState)state {
    self.state = state;
}

- (CGSize)indicatorSize {
	return CGSizeMake(34, 13);
}

- (void)setupSubviews {
	CGSize size = [self indicatorSize];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
	CGFloat height = 5;
	CGFloat correction = height / 2;

	self.leftView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) / 2 + correction, height);
	self.leftView.pan_centerY = self.pan_height / 2;
	self.leftView.layer.cornerRadius = MIN(self.leftView.pan_width, self.leftView.pan_height) / 2;

	self.rightView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - correction, 0, CGRectGetWidth(self.frame) / 2 + correction, height);
	self.rightView.pan_centerY = self.pan_height / 2;
	self.rightView.layer.cornerRadius = MIN(self.rightView.pan_width, self.rightView.pan_height) / 2;

}

#pragma mark - Getter

- (UIView *)leftView {
	if (!_leftView) {
		_leftView = [UIView new];
	}
	return _leftView;
}

- (UIView *)rightView {
	if (!_rightView) {
		_rightView = [UIView new];
	}
	return _rightView;
}


#pragma mark - Setter

- (void)setIndicatorColor:(UIColor *)indicatorColor {
	_indicatorColor = indicatorColor;
	self.leftView.backgroundColor = indicatorColor;
	self.rightView.backgroundColor = indicatorColor;
}

- (void)setState:(TFYIndicatorState)state {
    if (_state == state) return; // 状态未变时直接return，避免重复动画
    _state = state;

	switch (state) {
		case TFYIndicatorStateNormal: {
			CGFloat angle = 20 * M_PI / 180;
			[self animate:^{
				self.leftView.transform = CGAffineTransformMakeRotation(angle);
				self.rightView.transform = CGAffineTransformMakeRotation(-angle);
			}];
		}
			break;
		case TFYIndicatorStatePullDown: {
			[self animate:^{
				self.leftView.transform = CGAffineTransformIdentity;
				self.rightView.transform = CGAffineTransformIdentity;
			}];
		}
			break;
	}
}

@end
