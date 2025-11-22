//
//  TFYPopupBottomSheetAnimator.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：底部弹出框动画器实现
//

#import "TFYPopupBottomSheetAnimator.h"
#import "TFYPopupView.h"
#import "TFYPopupBackgroundView.h"

#pragma mark - TFYPopupBottomSheetConfiguration

@implementation TFYPopupBottomSheetConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _defaultHeight = 300;
        _minimumHeight = 100;
        _maximumHeight = [UIScreen mainScreen].bounds.size.height;
        _allowsFullScreen = YES;
        _snapToDefaultThreshold = 80;
        _springDamping = 0.8;
        _springVelocity = 0.4;
        _animationDuration = 0.35;
        _enableGestures = NO; // 默认关闭手势功能
        _cornerRadius = 10;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupBottomSheetConfiguration *copy = [[TFYPopupBottomSheetConfiguration alloc] init];
    copy.defaultHeight = self.defaultHeight;
    copy.minimumHeight = self.minimumHeight;
    copy.maximumHeight = self.maximumHeight;
    copy.allowsFullScreen = self.allowsFullScreen;
    copy.snapToDefaultThreshold = self.snapToDefaultThreshold;
    copy.springDamping = self.springDamping;
    copy.springVelocity = self.springVelocity;
    copy.animationDuration = self.animationDuration;
    copy.enableGestures = self.enableGestures;
    return copy;
}

@end

#pragma mark - TFYPopupBottomSheetAnimator

@interface TFYPopupBottomSheetAnimator ()

@property (nonatomic, strong) TFYPopupBottomSheetConfiguration *configuration;
@property (nonatomic, weak, nullable) TFYPopupView *popupView;
@property (nonatomic, weak, nullable) UIView *contentView;
@property (nonatomic, weak, nullable) TFYPopupBackgroundView *backgroundView;
@property (nonatomic, strong, nullable) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat currentHeight;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) CGPoint initialTouchPoint;
@property (nonatomic, strong, nullable) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong, nullable) NSLayoutConstraint *bottomConstraint;

@end

@implementation TFYPopupBottomSheetAnimator

#pragma mark - Initialization

- (instancetype)initWithConfiguration:(TFYPopupBottomSheetConfiguration *)configuration {
    self = [super init];
    if (self) {
        _configuration = [configuration copy];
        _currentHeight = 0;
        _isDragging = NO;
        _initialTouchPoint = CGPointZero;
    }
    return self;
}

- (instancetype)init {
    return [self initWithConfiguration:[[TFYPopupBottomSheetConfiguration alloc] init]];
}

#pragma mark - TFYPopupViewAnimator Protocol

- (void)setupPopupView:(TFYPopupView *)popupView
           contentView:(UIView *)contentView
        backgroundView:(TFYPopupBackgroundView *)backgroundView {
    self.popupView = popupView;
    self.contentView = contentView;
    self.backgroundView = backgroundView;
    
    contentView.layer.cornerRadius = self.configuration.cornerRadius;
    contentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    contentView.clipsToBounds = YES;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setupLayoutWithPopupView:popupView contentView:contentView];
    
    // 根据配置决定是否添加手势
    if (self.configuration.enableGestures) {
        [self addPanGestureToView:contentView];
    }
}

- (void)refreshLayoutPopupView:(TFYPopupView *)popupView contentView:(UIView *)contentView {
    // 避免在拖拽过程中重置高度，导致手势效果被覆盖
    if (!self.heightConstraint) {
        return;
    }
    if (self.isDragging) {
        return;
    }

    // 在非拖拽时，确保当前高度在[min, max]范围内；若未设置则使用默认高度的夹值
    CGFloat clampedDefault = MIN(MAX(self.configuration.defaultHeight, self.configuration.minimumHeight), self.configuration.maximumHeight);
    CGFloat current = self.heightConstraint.constant;
    if (current <= 0) {
        self.heightConstraint.constant = clampedDefault;
    } else {
        self.heightConstraint.constant = MIN(MAX(current, self.configuration.minimumHeight), self.configuration.maximumHeight);
    }
}

- (void)displayContentView:(UIView *)contentView
            backgroundView:(TFYPopupBackgroundView *)backgroundView
                  animated:(BOOL)animated
                completion:(void (^)(void))completion {
    if (!self.popupView) {
        completion();
        return;
    }
    
    // 初始状态：在屏幕底部外
    self.bottomConstraint.constant = self.configuration.defaultHeight;
    self.heightConstraint.constant = self.configuration.defaultHeight;
    backgroundView.alpha = 0;
    
    // 强制更新布局
    [self.popupView layoutIfNeeded];
    
    if (animated) {
        [UIView animateWithDuration:self.configuration.animationDuration
                              delay:0
             usingSpringWithDamping:self.configuration.springDamping
              initialSpringVelocity:self.configuration.springVelocity
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            // 最终状态：显示在底部
            self.bottomConstraint.constant = 0;
            backgroundView.alpha = 1;
            [self.popupView layoutIfNeeded];
        } completion:^(BOOL finished) {
            completion();
        }];
    } else {
        self.bottomConstraint.constant = 0;
        backgroundView.alpha = 1;
        [self.popupView layoutIfNeeded];
        completion();
    }
}

- (void)dismissContentView:(UIView *)contentView
            backgroundView:(TFYPopupBackgroundView *)backgroundView
                  animated:(BOOL)animated
                completion:(void (^)(void))completion {
    if (!self.popupView) {
        completion();
        return;
    }
    
    if (animated) {
        [UIView animateWithDuration:self.configuration.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            // 移动到屏幕底部外
            self.bottomConstraint.constant = self.configuration.defaultHeight;
            backgroundView.alpha = 0;
            [self.popupView layoutIfNeeded];
        } completion:^(BOOL finished) {
            completion();
        }];
    } else {
        self.bottomConstraint.constant = self.configuration.defaultHeight;
        backgroundView.alpha = 0;
        [self.popupView layoutIfNeeded];
        completion();
    }
}

#pragma mark - Private Methods

- (void)setupLayoutWithPopupView:(TFYPopupView *)popupView contentView:(UIView *)contentView {
    // 创建约束
    self.heightConstraint = [contentView.heightAnchor constraintEqualToConstant:self.configuration.defaultHeight];
    self.bottomConstraint = [contentView.bottomAnchor constraintEqualToAnchor:popupView.bottomAnchor
                                                                     constant:self.configuration.defaultHeight];
    
    NSArray *constraints = @[
        [contentView.leadingAnchor constraintEqualToAnchor:popupView.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:popupView.trailingAnchor],
        self.bottomConstraint,
        self.heightConstraint,
        [contentView.heightAnchor constraintGreaterThanOrEqualToConstant:self.configuration.minimumHeight],
        [contentView.heightAnchor constraintLessThanOrEqualToConstant:self.configuration.maximumHeight]
    ];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    // 设置约束优先级
    self.heightConstraint.priority = UILayoutPriorityDefaultHigh;
    self.bottomConstraint.priority = UILayoutPriorityRequired;
}

- (void)addPanGestureToView:(UIView *)view {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handlePan:)];
    pan.delegate = self;
    [view addGestureRecognizer:pan];
    self.panGesture = pan;
}

#pragma mark - 动态手势控制

- (void)enableGestures {
    if (!self.contentView) return;
    
    // 如果已经有手势，先移除
    if (self.panGesture) {
        [self.contentView removeGestureRecognizer:self.panGesture];
    }
    
    // 添加新手势
    [self addPanGestureToView:self.contentView];
}

- (void)disableGestures {
    if (!self.contentView || !self.panGesture) return;
    
    [self.contentView removeGestureRecognizer:self.panGesture];
    self.panGesture = nil;
}

- (BOOL)isGesturesEnabled {
    return self.panGesture != nil;
}

#pragma mark - Gesture Handling

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if (!self.popupView || !self.heightConstraint || !self.bottomConstraint) {
        return;
    }
    
    // 确保在主线程执行UI操作
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handlePan:gesture];
        });
        return;
    }
    
    CGPoint translation = [gesture translationInView:self.popupView];
    CGPoint velocity = [gesture velocityInView:self.popupView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.isDragging = YES;
            self.initialTouchPoint = [gesture locationInView:self.popupView];
            self.currentHeight = self.heightConstraint.constant;
            break;
            
        case UIGestureRecognizerStateChanged: {
            // 根据拖拽方向调整高度和位置
            CGFloat dragOffset = translation.y;
            
            if (dragOffset < 0) {
                // 向上拖拽：增加高度（最大到maximumHeight）
                CGFloat newHeight = MIN(self.currentHeight - dragOffset, self.configuration.maximumHeight);
                self.heightConstraint.constant = newHeight;
                self.bottomConstraint.constant = 0;
            } else {
                // 向下拖拽：减少高度或移动位置
                if (self.currentHeight > self.configuration.defaultHeight) {
                    // 如果当前高度大于默认高度，先减少高度
                    CGFloat newHeight = MAX(self.currentHeight - dragOffset, self.configuration.defaultHeight);
                    self.heightConstraint.constant = newHeight;
                    self.bottomConstraint.constant = 0;
                } else {
                    // 否则移动位置准备关闭
                    CGFloat newOffset = MIN(dragOffset, self.configuration.defaultHeight);
                    self.bottomConstraint.constant = newOffset;
                    self.heightConstraint.constant = self.configuration.defaultHeight;
                }
            }
            
            [self.popupView layoutIfNeeded];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            self.isDragging = NO;
            CGFloat currentOffset = self.bottomConstraint.constant;
            CGFloat currentHeightValue = self.heightConstraint.constant;
            
            // 判断是否应该关闭
            if (currentOffset > self.configuration.minimumHeight) {
                // 关闭弹窗
                [self.popupView dismissAnimated:YES completion:nil];
                return;
            }
            
            // 判断是否应该全屏展开
            if (velocity.y < -500 && self.configuration.allowsFullScreen) {
                // 快速向上滑动，展开到全屏
                [self animateToHeight:self.configuration.maximumHeight popupView:self.popupView];
            } else if (currentHeightValue > self.configuration.defaultHeight + self.configuration.snapToDefaultThreshold) {
                // 高度超过阈值，展开到全屏
                [self animateToHeight:self.configuration.maximumHeight popupView:self.popupView];
            } else {
                // 回到默认高度
                [self animateToHeight:self.configuration.defaultHeight popupView:self.popupView];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)animateToHeight:(CGFloat)height popupView:(TFYPopupView *)popupView {
    [UIView animateWithDuration:self.configuration.animationDuration
                          delay:0
         usingSpringWithDamping:self.configuration.springDamping
          initialSpringVelocity:self.configuration.springVelocity
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.heightConstraint.constant = height;
        self.bottomConstraint.constant = 0;
        [popupView layoutIfNeeded];
    } completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 允许与UIScrollView的手势识别器同时工作
    return [otherGestureRecognizer.view isKindOfClass:[UIScrollView class]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

@end
