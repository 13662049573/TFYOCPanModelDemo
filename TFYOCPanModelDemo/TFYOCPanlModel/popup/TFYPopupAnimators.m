//
//  TFYPopupAnimators.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗具体动画器类实现集合
//

#import "TFYPopupAnimators.h"
#import "TFYPopupView.h"
#import "TFYPopupBackgroundView.h"

#pragma mark - TFYPopupFadeInOutAnimator

@implementation TFYPopupFadeInOutAnimator

- (void)setupPopupView:(TFYPopupView *)popupView
           contentView:(UIView *)contentView
        backgroundView:(TFYPopupBackgroundView *)backgroundView {
    [super setupPopupView:popupView contentView:contentView backgroundView:backgroundView];
    
    contentView.alpha = 0;
    backgroundView.alpha = 0;
    
    __weak typeof(contentView) weakContentView = contentView;
    __weak typeof(backgroundView) weakBackgroundView = backgroundView;
    
    self.displayAnimationBlock = ^{
        weakContentView.alpha = 1;
        weakBackgroundView.alpha = 1;
    };
    
    self.dismissAnimationBlock = ^{
        weakContentView.alpha = 0;
        weakBackgroundView.alpha = 0;
    };
}

@end

#pragma mark - TFYPopupZoomInOutAnimator

@implementation TFYPopupZoomInOutAnimator

- (void)setupPopupView:(TFYPopupView *)popupView
           contentView:(UIView *)contentView
        backgroundView:(TFYPopupBackgroundView *)backgroundView {
    [super setupPopupView:popupView contentView:contentView backgroundView:backgroundView];
    
    contentView.alpha = 0;
    backgroundView.alpha = 0;
    contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    __weak typeof(contentView) weakContentView = contentView;
    __weak typeof(backgroundView) weakBackgroundView = backgroundView;
    
    self.displayAnimationBlock = ^{
        weakContentView.alpha = 1;
        weakContentView.transform = CGAffineTransformIdentity;
        weakBackgroundView.alpha = 1;
    };
    
    self.dismissAnimationBlock = ^{
        weakContentView.alpha = 0;
        weakContentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        weakBackgroundView.alpha = 0;
    };
}

@end

#pragma mark - TFYPopup3DFlipAnimator

@implementation TFYPopup3DFlipAnimator

- (void)setupPopupView:(TFYPopupView *)popupView
           contentView:(UIView *)contentView
        backgroundView:(TFYPopupBackgroundView *)backgroundView {
    [super setupPopupView:popupView contentView:contentView backgroundView:backgroundView];
    
    contentView.alpha = 0;
    backgroundView.alpha = 0;
    contentView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    
    __weak typeof(contentView) weakContentView = contentView;
    __weak typeof(backgroundView) weakBackgroundView = backgroundView;
    
    self.displayAnimationBlock = ^{
        weakContentView.alpha = 1;
        weakContentView.layer.transform = CATransform3DIdentity;
        weakBackgroundView.alpha = 1;
    };
    
    self.dismissAnimationBlock = ^{
        weakContentView.alpha = 0;
        weakContentView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        weakBackgroundView.alpha = 0;
    };
}

@end

#pragma mark - TFYPopupSpringAnimator

@implementation TFYPopupSpringAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置弹簧动画参数
        self.displaySpringDampingRatio = 0.7;
        self.hasDisplaySpringDampingRatio = YES;
        self.displaySpringVelocity = 0.5;
        self.hasDisplaySpringVelocity = YES;
        
        self.dismissSpringDampingRatio = 0.8;
        self.hasDismissSpringDampingRatio = YES;
        self.dismissSpringVelocity = 0.3;
        self.hasDismissSpringVelocity = YES;
        
        self.displayDuration = 0.5;
        self.dismissDuration = 0.5;
    }
    return self;
}

- (void)setupPopupView:(TFYPopupView *)popupView
           contentView:(UIView *)contentView
        backgroundView:(TFYPopupBackgroundView *)backgroundView {
    [super setupPopupView:popupView contentView:contentView backgroundView:backgroundView];
    
    contentView.alpha = 0;
    backgroundView.alpha = 0;
    contentView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    __weak typeof(contentView) weakContentView = contentView;
    __weak typeof(backgroundView) weakBackgroundView = backgroundView;
    
    self.displayAnimationBlock = ^{
        weakContentView.alpha = 1;
        weakContentView.transform = CGAffineTransformIdentity;
        weakBackgroundView.alpha = 1;
    };
    
    self.dismissAnimationBlock = ^{
        weakContentView.alpha = 0;
        weakContentView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        weakBackgroundView.alpha = 0;
    };
}

@end

#pragma mark - TFYPopupBounceAnimator

@implementation TFYPopupBounceAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置弹性动画参数
        self.displaySpringDampingRatio = 0.6;
        self.hasDisplaySpringDampingRatio = YES;
        self.displaySpringVelocity = 0.8;
        self.hasDisplaySpringVelocity = YES;
        
        self.dismissSpringDampingRatio = 0.8;
        self.hasDismissSpringDampingRatio = YES;
        self.dismissSpringVelocity = 0.5;
        self.hasDismissSpringVelocity = YES;
        
        self.displayDuration = 0.6;
        self.dismissDuration = 0.6;
    }
    return self;
}

- (void)setupPopupView:(TFYPopupView *)popupView
           contentView:(UIView *)contentView
        backgroundView:(TFYPopupBackgroundView *)backgroundView {
    [super setupPopupView:popupView contentView:contentView backgroundView:backgroundView];
    
    contentView.alpha = 0;
    backgroundView.alpha = 0;
    contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    __weak typeof(contentView) weakContentView = contentView;
    __weak typeof(backgroundView) weakBackgroundView = backgroundView;
    
    self.displayAnimationBlock = ^{
        weakContentView.alpha = 1;
        weakContentView.transform = CGAffineTransformIdentity;
        weakBackgroundView.alpha = 1;
    };
    
    self.dismissAnimationBlock = ^{
        weakContentView.alpha = 0;
        weakContentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        weakBackgroundView.alpha = 0;
    };
}

@end

#pragma mark - TFYPopupRotateAnimator

@implementation TFYPopupRotateAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置更长的动画时间以突出旋转效果
        self.displayDuration = 0.8;
        self.dismissDuration = 0.8;
        self.displayAnimationOptions = UIViewAnimationOptionCurveEaseInOut;
        self.dismissAnimationOptions = UIViewAnimationOptionCurveEaseInOut;
    }
    return self;
}

- (void)setupPopupView:(TFYPopupView *)popupView
           contentView:(UIView *)contentView
        backgroundView:(TFYPopupBackgroundView *)backgroundView {
    [super setupPopupView:popupView contentView:contentView backgroundView:backgroundView];
    
    contentView.alpha = 0;
    backgroundView.alpha = 0;
    // 设置初始旋转角度为 -180 度，这样会有明显的旋转效果
    contentView.transform = CGAffineTransformMakeRotation(-M_PI);
    
    __weak typeof(contentView) weakContentView = contentView;
    __weak typeof(backgroundView) weakBackgroundView = backgroundView;
    
    self.displayAnimationBlock = ^{
        weakContentView.alpha = 1;
        weakContentView.transform = CGAffineTransformIdentity;
        weakBackgroundView.alpha = 1;
    };
    
    self.dismissAnimationBlock = ^{
        weakContentView.alpha = 0;
        weakContentView.transform = CGAffineTransformMakeRotation(M_PI);
        weakBackgroundView.alpha = 0;
    };
}

@end

#pragma mark - TFYPopupDirectionalAnimator

@implementation TFYPopupDirectionalAnimator

- (CGAffineTransform)getInitialTransformForPopupView:(TFYPopupView *)popupView contentView:(UIView *)contentView {
    return CGAffineTransformIdentity;
}

- (void)setupPopupView:(TFYPopupView *)popupView
           contentView:(UIView *)contentView
        backgroundView:(TFYPopupBackgroundView *)backgroundView {
    [super setupPopupView:popupView contentView:contentView backgroundView:backgroundView];
    
    CGAffineTransform initialTransform = [self getInitialTransformForPopupView:popupView contentView:contentView];
    contentView.transform = initialTransform;
    contentView.alpha = 0;
    backgroundView.alpha = 0;
    
    __weak typeof(contentView) weakContentView = contentView;
    __weak typeof(backgroundView) weakBackgroundView = backgroundView;
    
    self.displayAnimationBlock = ^{
        weakContentView.transform = CGAffineTransformIdentity;
        weakContentView.alpha = 1;
        weakBackgroundView.alpha = 1;
    };
    
    self.dismissAnimationBlock = ^{
        weakContentView.transform = initialTransform;
        weakContentView.alpha = 0;
        weakBackgroundView.alpha = 0;
    };
}

@end

#pragma mark - Specific Directional Animators

@implementation TFYPopupUpwardAnimator

- (CGAffineTransform)getInitialTransformForPopupView:(TFYPopupView *)popupView contentView:(UIView *)contentView {
    return CGAffineTransformMakeTranslation(0, popupView.bounds.size.height);
}

@end

@implementation TFYPopupDownwardAnimator

- (CGAffineTransform)getInitialTransformForPopupView:(TFYPopupView *)popupView contentView:(UIView *)contentView {
    return CGAffineTransformMakeTranslation(0, -popupView.bounds.size.height);
}

@end

@implementation TFYPopupLeftwardAnimator

- (CGAffineTransform)getInitialTransformForPopupView:(TFYPopupView *)popupView contentView:(UIView *)contentView {
    return CGAffineTransformMakeTranslation(popupView.bounds.size.width, 0);
}

@end

@implementation TFYPopupRightwardAnimator

- (CGAffineTransform)getInitialTransformForPopupView:(TFYPopupView *)popupView contentView:(UIView *)contentView {
    return CGAffineTransformMakeTranslation(-popupView.bounds.size.width, 0);
}

@end

#pragma mark - TFYPopupSlideAnimator

@interface TFYPopupSlideAnimator ()

@property (nonatomic, assign) TFYPopupSlideDirection direction;

@end

@implementation TFYPopupSlideAnimator

- (instancetype)initWithDirection:(TFYPopupSlideDirection)direction {
    return [self initWithDirection:direction 
                            layout:[TFYPopupAnimatorLayout centerLayout:[TFYPopupAnimatorLayoutCenter defaultLayout]]];
}

- (instancetype)initWithDirection:(TFYPopupSlideDirection)direction layout:(TFYPopupAnimatorLayout *)layout {
    self = [super initWithLayout:layout];
    if (self) {
        _direction = direction;
    }
    return self;
}

- (void)setupPopupView:(TFYPopupView *)popupView
           contentView:(UIView *)contentView
        backgroundView:(TFYPopupBackgroundView *)backgroundView {
    [super setupPopupView:popupView contentView:contentView backgroundView:backgroundView];
    
    contentView.alpha = 0;
    backgroundView.alpha = 0;
    
    // 根据方向设置初始位置
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGAffineTransform initialTransform;
    
    switch (self.direction) {
        case TFYPopupSlideDirectionFromTop:
            initialTransform = CGAffineTransformMakeTranslation(0, -screenBounds.size.height);
            break;
        case TFYPopupSlideDirectionFromBottom:
            initialTransform = CGAffineTransformMakeTranslation(0, screenBounds.size.height);
            break;
        case TFYPopupSlideDirectionFromLeft:
            initialTransform = CGAffineTransformMakeTranslation(-screenBounds.size.width, 0);
            break;
        case TFYPopupSlideDirectionFromRight:
            initialTransform = CGAffineTransformMakeTranslation(screenBounds.size.width, 0);
            break;
    }
    
    contentView.transform = initialTransform;
    
    __weak typeof(contentView) weakContentView = contentView;
    __weak typeof(backgroundView) weakBackgroundView = backgroundView;
    
    self.displayAnimationBlock = ^{
        weakContentView.alpha = 1;
        weakContentView.transform = CGAffineTransformIdentity;
        weakBackgroundView.alpha = 1;
    };
    
    __weak typeof(self) weakSelf = self;
    self.dismissAnimationBlock = ^{
        weakContentView.alpha = 0;
        switch (weakSelf.direction) {
            case TFYPopupSlideDirectionFromTop:
                weakContentView.transform = CGAffineTransformMakeTranslation(0, -screenBounds.size.height);
                break;
            case TFYPopupSlideDirectionFromBottom:
                weakContentView.transform = CGAffineTransformMakeTranslation(0, screenBounds.size.height);
                break;
            case TFYPopupSlideDirectionFromLeft:
                weakContentView.transform = CGAffineTransformMakeTranslation(-screenBounds.size.width, 0);
                break;
            case TFYPopupSlideDirectionFromRight:
                weakContentView.transform = CGAffineTransformMakeTranslation(screenBounds.size.width, 0);
                break;
            default:break;
        }
        weakBackgroundView.alpha = 0;
    };
}

@end
