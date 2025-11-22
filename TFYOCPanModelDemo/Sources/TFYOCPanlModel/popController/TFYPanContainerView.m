//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanContainerView.m
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <TFYOCPanlModel/TFYPanContainerView.h>

@interface TFYPanContainerView ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation TFYPanContainerView

- (instancetype)initWithPresentedView:(UIView *)presentedView frame:(CGRect)frame {
	self = [super initWithFrame:frame];
    if (self) {
        if (!presentedView) return nil; // 防御性编程，防止崩溃
        _contentView = [UIView new];
        
    	_contentView.frame = self.bounds;
		[self addSubview:_contentView];
		[_contentView addSubview:presentedView];
    }
	
    return self;
}

- (void)updateShadow:(UIColor *)shadowColor shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity {
    
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)clearShadow {
	self.layer.shadowColor = nil;
	self.layer.shadowRadius = 3.0;
	self.layer.shadowOffset = CGSizeZero;
	self.layer.shadowOpacity = 0.0;
}

- (void)dealloc {
    if (_contentView) {
        for (UIView *sub in _contentView.subviews) {
            [sub removeFromSuperview];
        }
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
}

@end

@implementation UIView (PanContainer)

- (TFYPanContainerView *)panContainerView {
	for (UIView *subview in self.subviews) {
		if ([subview isKindOfClass:TFYPanContainerView.class]) {
			return (TFYPanContainerView *) subview;
		}
	}
	return nil;
}


@end
