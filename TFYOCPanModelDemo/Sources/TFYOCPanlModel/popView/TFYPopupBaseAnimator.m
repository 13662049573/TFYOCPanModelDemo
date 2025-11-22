//
//  TFYPopupBaseAnimator.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗基础动画器类实现
//

#import <TFYOCPanlModel/TFYPopupBaseAnimator.h>
#import <TFYOCPanlModel/TFYPopupView.h>
#import <TFYOCPanlModel/TFYPopupBackgroundView.h>

@implementation TFYPopupBaseAnimator

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithLayout:[TFYPopupAnimatorLayout centerLayout:[TFYPopupAnimatorLayoutCenter defaultLayout]]];
}

- (instancetype)initWithLayout:(TFYPopupAnimatorLayout *)layout {
    self = [super init];
    if (self) {
        _layout = layout;
        _displayDuration = 0.25;
        _displayAnimationOptions = UIViewAnimationOptionCurveEaseInOut;
        _hasDisplaySpringDampingRatio = NO;
        _hasDisplaySpringVelocity = NO;
        
        _dismissDuration = 0.25;
        _dismissAnimationOptions = UIViewAnimationOptionCurveEaseInOut;
        _hasDismissSpringDampingRatio = NO;
        _hasDismissSpringVelocity = NO;
    }
    return self;
}

#pragma mark - TFYPopupViewAnimator Protocol

- (void)setupPopupView:(TFYPopupView *)popupView
           contentView:(UIView *)contentView
        backgroundView:(TFYPopupBackgroundView *)backgroundView {
    [self setupLayoutWithPopupView:popupView contentView:contentView];
}

- (void)refreshLayoutPopupView:(TFYPopupView *)popupView contentView:(UIView *)contentView {
    if (self.layout.type == TFYPopupAnimatorLayoutTypeFrame) {
        contentView.frame = self.layout.frameLayout;
    }
}

- (void)displayContentView:(UIView *)contentView
            backgroundView:(TFYPopupBackgroundView *)backgroundView
                  animated:(BOOL)animated
                completion:(void (^)(void))completion {
    if (animated) {
        if (self.hasDisplaySpringDampingRatio && self.hasDisplaySpringVelocity) {
            [UIView animateWithDuration:self.displayDuration
                                  delay:0
                 usingSpringWithDamping:self.displaySpringDampingRatio
                  initialSpringVelocity:self.displaySpringVelocity
                                options:self.displayAnimationOptions
                             animations:^{
                if (self.displayAnimationBlock) {
                    self.displayAnimationBlock();
                }
            } completion:^(BOOL finished) {
                completion();
            }];
        } else {
            [UIView animateWithDuration:self.displayDuration
                                  delay:0
                                options:self.displayAnimationOptions
                             animations:^{
                if (self.displayAnimationBlock) {
                    self.displayAnimationBlock();
                }
            } completion:^(BOOL finished) {
                completion();
            }];
        }
    } else {
        if (self.displayAnimationBlock) {
            self.displayAnimationBlock();
        }
        completion();
    }
}

- (void)dismissContentView:(UIView *)contentView
            backgroundView:(TFYPopupBackgroundView *)backgroundView
                  animated:(BOOL)animated
                completion:(void (^)(void))completion {
    if (animated) {
        if (self.hasDismissSpringDampingRatio && self.hasDismissSpringVelocity) {
            [UIView animateWithDuration:self.dismissDuration
                                  delay:0
                 usingSpringWithDamping:self.dismissSpringDampingRatio
                  initialSpringVelocity:self.dismissSpringVelocity
                                options:self.dismissAnimationOptions
                             animations:^{
                if (self.dismissAnimationBlock) {
                    self.dismissAnimationBlock();
                }
            } completion:^(BOOL finished) {
                completion();
            }];
        } else {
            [UIView animateWithDuration:self.dismissDuration
                                  delay:0
                                options:self.dismissAnimationOptions
                             animations:^{
                if (self.dismissAnimationBlock) {
                    self.dismissAnimationBlock();
                }
            } completion:^(BOOL finished) {
                completion();
            }];
        }
    } else {
        if (self.dismissAnimationBlock) {
            self.dismissAnimationBlock();
        }
        completion();
    }
}

#pragma mark - Layout Setup Methods

- (void)setupLayoutWithPopupView:(TFYPopupView *)popupView contentView:(UIView *)contentView {
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    switch (self.layout.type) {
        case TFYPopupAnimatorLayoutTypeCenter:
            [self setupCenterLayoutWithPopupView:popupView
                                     contentView:contentView
                                          center:self.layout.centerLayout];
            break;
        case TFYPopupAnimatorLayoutTypeTop:
            [self setupTopLayoutWithPopupView:popupView
                                  contentView:contentView
                                          top:self.layout.topLayout];
            break;
        case TFYPopupAnimatorLayoutTypeBottom:
            [self setupBottomLayoutWithPopupView:popupView
                                     contentView:contentView
                                          bottom:self.layout.bottomLayout];
            break;
        case TFYPopupAnimatorLayoutTypeLeading:
            [self setupLeadingLayoutWithPopupView:popupView
                                      contentView:contentView
                                          leading:self.layout.leadingLayout];
            break;
        case TFYPopupAnimatorLayoutTypeTrailing:
            [self setupTrailingLayoutWithPopupView:popupView
                                       contentView:contentView
                                          trailing:self.layout.trailingLayout];
            break;
        case TFYPopupAnimatorLayoutTypeFrame:
            contentView.frame = self.layout.frameLayout;
            contentView.translatesAutoresizingMaskIntoConstraints = YES;
            break;
    }
}

- (void)setupCenterLayoutWithPopupView:(TFYPopupView *)popupView
                           contentView:(UIView *)contentView
                                center:(TFYPopupAnimatorLayoutCenter *)center {
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObject:
     [contentView.centerXAnchor constraintEqualToAnchor:popupView.centerXAnchor constant:center.offsetX]];
    [constraints addObject:
     [contentView.centerYAnchor constraintEqualToAnchor:popupView.centerYAnchor constant:center.offsetY]];
    
    if (center.hasWidth) {
        [constraints addObject:
         [contentView.widthAnchor constraintEqualToConstant:center.width]];
    }
    if (center.hasHeight) {
        [constraints addObject:
         [contentView.heightAnchor constraintEqualToConstant:center.height]];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupTopLayoutWithPopupView:(TFYPopupView *)popupView
                        contentView:(UIView *)contentView
                                top:(TFYPopupAnimatorLayoutTop *)top {
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObject:
     [contentView.topAnchor constraintEqualToAnchor:popupView.topAnchor constant:top.topMargin]];
    [constraints addObject:
     [contentView.centerXAnchor constraintEqualToAnchor:popupView.centerXAnchor constant:top.offsetX]];
    
    if (top.hasWidth) {
        [constraints addObject:
         [contentView.widthAnchor constraintEqualToConstant:top.width]];
    }
    if (top.hasHeight) {
        [constraints addObject:
         [contentView.heightAnchor constraintEqualToConstant:top.height]];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupBottomLayoutWithPopupView:(TFYPopupView *)popupView
                           contentView:(UIView *)contentView
                                bottom:(TFYPopupAnimatorLayoutBottom *)bottom {
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObject:
     [contentView.bottomAnchor constraintEqualToAnchor:popupView.bottomAnchor constant:-bottom.bottomMargin]];
    [constraints addObject:
     [contentView.centerXAnchor constraintEqualToAnchor:popupView.centerXAnchor constant:bottom.offsetX]];
    
    if (bottom.hasWidth) {
        [constraints addObject:
         [contentView.widthAnchor constraintEqualToConstant:bottom.width]];
    }
    if (bottom.hasHeight) {
        [constraints addObject:
         [contentView.heightAnchor constraintEqualToConstant:bottom.height]];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupLeadingLayoutWithPopupView:(TFYPopupView *)popupView
                            contentView:(UIView *)contentView
                                leading:(TFYPopupAnimatorLayoutLeading *)leading {
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObject:
     [contentView.leadingAnchor constraintEqualToAnchor:popupView.leadingAnchor constant:leading.leadingMargin]];
    [constraints addObject:
     [contentView.centerYAnchor constraintEqualToAnchor:popupView.centerYAnchor constant:leading.offsetY]];
    
    if (leading.hasWidth) {
        [constraints addObject:
         [contentView.widthAnchor constraintEqualToConstant:leading.width]];
    }
    if (leading.hasHeight) {
        [constraints addObject:
         [contentView.heightAnchor constraintEqualToConstant:leading.height]];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupTrailingLayoutWithPopupView:(TFYPopupView *)popupView
                             contentView:(UIView *)contentView
                                trailing:(TFYPopupAnimatorLayoutTrailing *)trailing {
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObject:
     [contentView.trailingAnchor constraintEqualToAnchor:popupView.trailingAnchor constant:-trailing.trailingMargin]];
    [constraints addObject:
     [contentView.centerYAnchor constraintEqualToAnchor:popupView.centerYAnchor constant:trailing.offsetY]];
    
    if (trailing.hasWidth) {
        [constraints addObject:
         [contentView.widthAnchor constraintEqualToConstant:trailing.width]];
    }
    if (trailing.hasHeight) {
        [constraints addObject:
         [contentView.heightAnchor constraintEqualToConstant:trailing.height]];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Utility Methods

- (UIEdgeInsets)getSafeAreaInsetsForPopupView:(TFYPopupView *)popupView {
    if (@available(iOS 11.0, *)) {
        return popupView.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)adjustConstant:(CGFloat)constant forEdge:(UIRectEdge)edge popupView:(TFYPopupView *)popupView {
    UIEdgeInsets safeAreaInsets = [self getSafeAreaInsetsForPopupView:popupView];
    switch (edge) {
        case UIRectEdgeTop:
            return constant + safeAreaInsets.top;
        case UIRectEdgeBottom:
            return constant + safeAreaInsets.bottom;
        case UIRectEdgeLeft:
            return constant + safeAreaInsets.left;
        case UIRectEdgeRight:
            return constant + safeAreaInsets.right;
        default:
            return constant;
    }
}

@end
