//
//  TFYPopupView.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：主要弹窗视图类实现
//

#import "TFYPopupView.h"
#import "TFYPopupBottomSheetAnimator.h"

@interface TFYPopupView () <UIGestureRecognizerDelegate>

// Private Properties
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) id<TFYPopupViewAnimator> animator;
@property (nonatomic, strong) TFYPopupViewConfiguration *configuration;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isBeingCleanedUp;

// Layout Constraints
@property (nonatomic, strong, nullable) NSLayoutConstraint *keyboardAdjustmentConstraint;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *containerConstraints;

// Gesture
@property (nonatomic, strong, nullable) UIPanGestureRecognizer *panGesture;

// Static Properties
@property (nonatomic, class, readonly) NSMutableArray<TFYPopupView *> *currentPopupViews;
@property (nonatomic, class, readonly) dispatch_queue_t popupQueue;

@end

@implementation TFYPopupView

#pragma mark - Static Properties

static NSMutableArray<TFYPopupView *> *_currentPopupViews = nil;
static dispatch_queue_t _popupQueue = nil;

+ (NSMutableArray<TFYPopupView *> *)currentPopupViews {
    if (!_currentPopupViews) {
        _currentPopupViews = [NSMutableArray array];
    }
    return _currentPopupViews;
}

+ (dispatch_queue_t)popupQueue {
    if (!_popupQueue) {
        _popupQueue = dispatch_queue_create("com.tfy.popup.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _popupQueue;
}

#pragma mark - Initialization

- (instancetype)initWithContainerView:(UIView *)containerView
                          contentView:(UIView *)contentView
                             animator:(id<TFYPopupViewAnimator>)animator
                        configuration:(TFYPopupViewConfiguration *)configuration {
    
    NSAssert(containerView != nil, @"TFYPopupView: containerView不能为空");
    NSAssert(contentView != nil, @"TFYPopupView: contentView不能为空");
    NSAssert(animator != nil, @"TFYPopupView: animator不能为空");
    NSAssert(configuration != nil, @"TFYPopupView: configuration不能为空");
    
    // 验证配置
    if (![configuration validate]) {
        NSAssert(NO, @"TFYPopupView: 配置验证失败，请检查配置参数");
        return nil;
    }
    
    // 检查contentView是否已被添加
    if (contentView.superview != nil) {
        NSLog(@"TFYPopupView Warning: contentView 已经被添加到其他视图，可能导致布局异常");
    }
    
    // 检查弹窗数量限制
    if ([self.class currentPopupViews].count >= configuration.maxPopupCount) {
        NSLog(@"TFYPopupView Warning: 弹窗数量已达上限，将自动清理最旧的弹窗");
        [self.class cleanupOldestPopup];
    }
    
    self = [super initWithFrame:containerView.bounds];
    if (self) {
        _containerView = containerView;
        _contentView = contentView;
        _animator = animator;
        _configuration = [configuration copy];
        _backgroundView = [[TFYPopupBackgroundView alloc] initWithFrame:containerView.bounds];
        _isDismissible = configuration.isDismissible;
        _isInteractive = configuration.isInteractive;
        _isPenetrable = configuration.isPenetrable;
        _isPresenting = NO;
        _isAnimating = NO;
        _isBeingCleanedUp = NO;
        _containerConstraints = [NSMutableArray array];
        
        [self setupView];
        [self setupGestures];
        [self setupAccessibility];
        [self setupKeyboardHandling];
        [self setupContainerConstraints];
        [self setupMemoryWarningHandling];
        [self applyTheme];
        
        // 应用背景配置
        [self configureBackgroundWithStyle:configuration.backgroundStyle
                                      color:configuration.backgroundColor
                                  blurStyle:configuration.blurStyle];
    }
    return self;
}

- (instancetype)initWithContainerView:(UIView *)containerView
                          contentView:(UIView *)contentView
                             animator:(id<TFYPopupViewAnimator>)animator {
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    return [self initWithContainerView:containerView
                           contentView:contentView
                              animator:animator
                         configuration:config];
}

#pragma mark - Setup Methods

- (void)setupView {
    // 背景视图的用户交互应该基于dismissOnBackgroundTap配置，而不是isDismissible
    self.backgroundView.userInteractionEnabled = self.configuration.dismissOnBackgroundTap;
    [self.backgroundView addTarget:self
                            action:@selector(backgroundViewClicked)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.contentView];
    
    [self.animator setupPopupView:self
                      contentView:self.contentView
                   backgroundView:self.backgroundView];
}

- (void)setupGestures {
    if (!self.configuration.enableDragToDismiss) return;
    
    // 如果是底部弹出框动画器，跳过手势设置（由动画器自己处理）
    if ([self.animator isKindOfClass:NSClassFromString(@"TFYPopupBottomSheetAnimator")]) {
        return;
    }
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self 
                                                              action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    [self.contentView addGestureRecognizer:self.panGesture];
}

- (void)setupAccessibility {
    if (!self.configuration.enableAccessibility) return;
    
    self.accessibilityElementsHidden = NO;
    self.contentView.accessibilityElementsHidden = NO;
    self.contentView.accessibilityTraits = UIAccessibilityTraitAllowsDirectInteraction;
    
    if (@available(iOS 13.0, *)) {
        self.contentView.accessibilityRespondsToUserInteraction = YES;
    }
}

- (void)setupKeyboardHandling {
    if (!self.configuration.keyboardConfiguration.isEnabled) return;
    
    // 创建键盘调整约束
    self.keyboardAdjustmentConstraint = [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    self.keyboardAdjustmentConstraint.active = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)setupMemoryWarningHandling {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

- (void)setupContainerConstraints {
    // 检查是否为底部弹出框动画器，如果是则跳过容器约束设置
    if ([self.animator isKindOfClass:NSClassFromString(@"TFYPopupBottomSheetAnimator")]) {
        return; // 底部弹出框使用自己的约束系统
    }
    
    // 移除旧的约束
    [NSLayoutConstraint deactivateConstraints:self.containerConstraints];
    [self.containerConstraints removeAllObjects];
    
    TFYPopupContainerConfiguration *config = self.configuration.containerConfiguration;
    
    // 确保 contentView 已经添加到视图层级中
    if (self.contentView.superview == nil) return;
    
    // 设置宽度约束
    switch (config.width.type) {
        case TFYContainerDimensionTypeFixed:
            [self.containerConstraints addObject:
             [self.contentView.widthAnchor constraintEqualToConstant:config.width.value]];
            break;
        case TFYContainerDimensionTypeAutomatic:
            if (config.hasMaxWidth) {
                [self.containerConstraints addObject:
                 [self.contentView.widthAnchor constraintLessThanOrEqualToConstant:config.maxWidth]];
            }
            break;
        case TFYContainerDimensionTypeRatio:
            [self.containerConstraints addObject:
             [self.contentView.widthAnchor constraintEqualToAnchor:self.widthAnchor
                                                        multiplier:config.width.value]];
            break;
        case TFYContainerDimensionTypeCustom:
            if (config.width.customHandler) {
                CGFloat width = config.width.customHandler(self.contentView);
                [self.containerConstraints addObject:
                 [self.contentView.widthAnchor constraintEqualToConstant:width]];
            }
            break;
    }
    
    // 设置高度约束
    switch (config.height.type) {
        case TFYContainerDimensionTypeFixed:
            [self.containerConstraints addObject:
             [self.contentView.heightAnchor constraintEqualToConstant:config.height.value]];
            break;
        case TFYContainerDimensionTypeAutomatic:
            if (config.hasMaxHeight) {
                [self.containerConstraints addObject:
                 [self.contentView.heightAnchor constraintLessThanOrEqualToConstant:config.maxHeight]];
            }
            break;
        case TFYContainerDimensionTypeRatio:
            [self.containerConstraints addObject:
             [self.contentView.heightAnchor constraintEqualToAnchor:self.heightAnchor
                                                         multiplier:config.height.value]];
            break;
        case TFYContainerDimensionTypeCustom:
            if (config.height.customHandler) {
                CGFloat height = config.height.customHandler(self.contentView);
                [self.containerConstraints addObject:
                 [self.contentView.heightAnchor constraintEqualToConstant:height]];
            }
            break;
    }
    
    // 设置最小尺寸约束
    if (config.hasMinWidth) {
        [self.containerConstraints addObject:
         [self.contentView.widthAnchor constraintGreaterThanOrEqualToConstant:config.minWidth]];
    }
    if (config.hasMinHeight) {
        [self.containerConstraints addObject:
         [self.contentView.heightAnchor constraintGreaterThanOrEqualToConstant:config.minHeight]];
    }
    
    // 激活所有约束
    [NSLayoutConstraint activateConstraints:self.containerConstraints];
}

- (void)applyTheme {
    if (!self.configuration.enableAccessibility) return;
    
    switch (self.configuration.theme) {
        case TFYPopupThemeLight:
            self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
            self.contentView.backgroundColor = [UIColor whiteColor];
            break;
        case TFYPopupThemeDark:
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
            self.contentView.backgroundColor = [UIColor blackColor];
            break;
        case TFYPopupThemeCustom:
            if (self.configuration.customThemeBackgroundColor) {
                self.backgroundColor = self.configuration.customThemeBackgroundColor;
                self.contentView.backgroundColor = self.configuration.customThemeBackgroundColor;
                self.contentView.layer.cornerRadius = self.configuration.customThemeCornerRadius;
            }
            break;
        default:
            break;
    }
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    [self.animator refreshLayoutPopupView:self contentView:self.contentView];
}

#pragma mark - Hit Testing

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint pointInContent = [self convertPoint:point toView:self.contentView];
    BOOL isPointInContent = CGRectContainsPoint(self.contentView.bounds, pointInContent);
    
    if (isPointInContent) {
        // 点击在内容视图内部，正常处理
        return self.isInteractive ? [super hitTest:point withEvent:event] : nil;
    } else {
        // 点击在背景区域
        if (self.isPenetrable) {
            return nil; // 允许穿透，不处理事件
        } else {
            // 如果允许背景点击关闭，返回backgroundView来处理事件
            if (self.configuration.dismissOnBackgroundTap && self.backgroundView.userInteractionEnabled) {
                return self.backgroundView;
            }
            return [super hitTest:point withEvent:event];
        }
    }
}

#pragma mark - Configuration Methods

- (instancetype)configureWithConfiguration:(TFYPopupViewConfiguration *)configuration {
    self.configuration = [configuration copy];
    _isDismissible = configuration.isDismissible;
    _isInteractive = configuration.isInteractive;
    _isPenetrable = configuration.isPenetrable;
    
    // 更新背景视图的交互状态
    if (self.backgroundView) {
        self.backgroundView.userInteractionEnabled = configuration.dismissOnBackgroundTap;
    }
    
    [self configureBackgroundWithStyle:configuration.backgroundStyle
                                  color:configuration.backgroundColor
                              blurStyle:configuration.blurStyle];
    [self setupContainerConstraints];
    return self;
}

- (instancetype)configureBackgroundWithStyle:(TFYPopupBackgroundStyle)style
                                        color:(UIColor *)color
                                    blurStyle:(UIBlurEffectStyle)blurStyle {
    self.backgroundView.style = style;
    self.backgroundView.color = color;
    self.backgroundView.blurEffectStyle = blurStyle;
    return self;
}

#pragma mark - Display & Dismiss Methods

- (void)displayAnimated:(BOOL)animated completion:(TFYPopupViewCallback)completion {
    // 检查代理是否允许显示
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewShouldDismiss:)]) {
        if (![self.delegate popupViewShouldDismiss:self]) {
            NSLog(@"TFYPopupView Warning: 代理不允许显示弹窗");
            return;
        }
    }
    
    [self performDisplayAnimated:animated completion:completion];
}

- (void)dismissAnimated:(BOOL)animated completion:(TFYPopupViewCallback)completion {
    if (self.isAnimating) {
        NSLog(@"TFYPopupView Debug: 弹窗正在动画中，忽略消失请求");
        return;
    }
    
    // 检查代理是否允许消失
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewShouldDismiss:)]) {
        if (![self.delegate popupViewShouldDismiss:self]) {
            NSLog(@"TFYPopupView Warning: 代理不允许消失弹窗");
            return;
        }
    }
    
    self.isAnimating = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewWillDisappear:)]) {
        [self.delegate popupViewWillDisappear:self];
    }
    if (self.willDismissCallback) {
        self.willDismissCallback();
    }
    
    // 从当前显示的弹窗数组中移除（仅在非cleanupOldestPopup调用时）
    if (!self.isBeingCleanedUp) {
        dispatch_barrier_async([self.class popupQueue], ^{
            [[self.class currentPopupViews] removeObject:self];
        });
    }
    
    __weak typeof(self) weakSelf = self;
    [self.animator dismissContentView:self.contentView
                       backgroundView:self.backgroundView
                             animated:animated
                           completion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf->_isPresenting = NO;
            
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(popupViewDidDisappear:)]) {
                [strongSelf.delegate popupViewDidDisappear:strongSelf];
            }
            
            [strongSelf cleanup];
            
            if (completion) {
                completion();
            }
            
            strongSelf.isAnimating = NO;
            
            if (strongSelf.didDismissCallback) {
                strongSelf.didDismissCallback();
            }
        }
    }];
}

#pragma mark - Private Methods

- (void)performDisplayAnimated:(BOOL)animated completion:(TFYPopupViewCallback)completion {
    if (self.isAnimating) return;
    
    _isPresenting = YES;
    self.isAnimating = YES;
    
    // 确保视图已添加到容器中（仅在未添加时）
    if (self.superview == nil) {
        [self.containerView addSubview:self];
        self.frame = self.containerView.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    // 设置约束（仅在首次显示时）
    if (self.containerConstraints.count == 0) {
        [self setupInitialLayout];
        [self setupContainerConstraints];
    }
    
    // 调用代理方法和显示回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewWillAppear:)]) {
        [self.delegate popupViewWillAppear:self];
    }
    if (self.willDisplayCallback) {
        self.willDisplayCallback();
    }
    
    // 执行动画
    __weak typeof(self) weakSelf = self;
    [self.animator displayContentView:self.contentView
                       backgroundView:self.backgroundView
                             animated:animated
                           completion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(popupViewDidAppear:)]) {
                [strongSelf.delegate popupViewDidAppear:strongSelf];
            }
            
            if (completion) {
                completion();
            }
            
            strongSelf.isAnimating = NO;
            
            if (strongSelf.didDisplayCallback) {
                strongSelf.didDisplayCallback();
            }
        }
    }];
}

- (void)setupInitialLayout {
    // 检查是否为需要自定义布局的动画器，如果是则跳过center约束设置
    if ([self.animator isKindOfClass:NSClassFromString(@"TFYPopupBottomSheetAnimator")] ||
        [self.animator isKindOfClass:NSClassFromString(@"TFYPopupBaseAnimator")]) {
        return; // 这些动画器使用自己的约束系统
    }
    
    // 设置内容视图的中心约束（仅用于简单动画器）
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.contentView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.contentView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
}

- (void)cleanup {
    [self.contentView removeFromSuperview];
    [self removeFromSuperview];
    
    // 清理通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 清理手势识别器
    for (UIGestureRecognizer *gesture in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:gesture];
    }
    for (UIGestureRecognizer *gesture in self.backgroundView.gestureRecognizers) {
        [self.backgroundView removeGestureRecognizer:gesture];
    }
}

#pragma mark - Static Methods

+ (void)cleanupOldestPopup {
    dispatch_barrier_async([self popupQueue], ^{
        if ([self currentPopupViews].count > 0) {
            TFYPopupView *oldestPopup = [self currentPopupViews].firstObject;
            [[self currentPopupViews] removeObjectAtIndex:0];
            
            // 设置清理标志
            oldestPopup.isBeingCleanedUp = YES;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [oldestPopup dismissAnimated:NO completion:nil];
            });
        }
    });
}

+ (void)cleanupAllPopups {
    dispatch_barrier_async([self popupQueue], ^{
        NSArray<TFYPopupView *> *popups = [[self currentPopupViews] copy];
        [[self currentPopupViews] removeAllObjects];
        
        for (TFYPopupView *popup in popups) {
            popup.isBeingCleanedUp = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [popup dismissAnimated:NO completion:nil];
            });
        }
    });
}

#pragma mark - Static Public Methods

+ (instancetype)showContentView:(UIView *)contentView
                  configuration:(TFYPopupViewConfiguration *)configuration
                       animator:(id<TFYPopupViewAnimator>)animator
                       animated:(BOOL)animated
                     completion:(TFYPopupViewCallback)completion {
    
    // 验证配置
    if (![configuration validate]) {
        NSAssert(NO, @"TFYPopupView: 配置验证失败，请检查配置参数");
        return nil;
    }
    
    // 获取当前窗口
    UIWindow *window = [self currentWindow];
    if (!window) {
        NSAssert(NO, @"TFYPopupView: 无法获取当前窗口");
        return nil;
    }
    
    // 检查弹窗数量限制
    if ([self currentPopupViews].count >= configuration.maxPopupCount) {
        [self cleanupOldestPopup];
    }
    
    // 创建弹窗
    TFYPopupView *popupView = [[TFYPopupView alloc] initWithContainerView:window
                                                              contentView:contentView
                                                                 animator:animator
                                                            configuration:configuration];
    
    // 确保背景配置被正确应用
    [popupView configureBackgroundWithStyle:configuration.backgroundStyle
                                       color:configuration.backgroundColor
                                   blurStyle:configuration.blurStyle];
    
    // 设置frame和autoresizing
    popupView.frame = window.bounds;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // 添加到窗口
    [window addSubview:popupView];
    
    // 添加到当前显示的弹窗数组
    dispatch_barrier_async([self popupQueue], ^{
        [[self currentPopupViews] addObject:popupView];
    });
    
    // 显示弹窗
    [popupView displayAnimated:animated completion:completion];
    
    // 设置自动消失
    if (configuration.autoDismissDelay > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(configuration.autoDismissDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [popupView dismissAnimated:YES completion:nil];
        });
    }
    
    return popupView;
}

+ (instancetype)showContentView:(UIView *)contentView
                       animated:(BOOL)animated
                     completion:(TFYPopupViewCallback)completion {
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    // 这里需要默认动画器，稍后会在动画器类中实现
    id animator = [[NSClassFromString(@"TFYPopupFadeInOutAnimator") alloc] init];
    return [self showContentView:contentView
                   configuration:config
                        animator:animator
                        animated:animated
                      completion:completion];
}

+ (void)dismissAllAnimated:(BOOL)animated completion:(TFYPopupViewCallback)completion {
    dispatch_barrier_async([self popupQueue], ^{
        NSArray<TFYPopupView *> *popups = [[self currentPopupViews] copy];
        [[self currentPopupViews] removeAllObjects];
        
        if (popups.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion();
            });
            return;
        }
        
        dispatch_group_t group = dispatch_group_create();
        
        for (TFYPopupView *popup in popups) {
            dispatch_group_enter(group);
            // 设置清理标志，避免重复移除
            popup.isBeingCleanedUp = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [popup dismissAnimated:animated completion:^{
                    dispatch_group_leave(group);
                }];
            });
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (completion) completion();
        });
    });
}

+ (NSInteger)currentPopupCount {
    __block NSInteger count = 0;
    dispatch_sync([self popupQueue], ^{
        count = [self currentPopupViews].count;
    });
    return count;
}

+ (NSArray<TFYPopupView *> *)allCurrentPopups {
    __block NSArray<TFYPopupView *> *popups = nil;
    dispatch_sync([self popupQueue], ^{
        popups = [[self currentPopupViews] copy];
    });
    return popups;
}

+ (instancetype)showBottomSheetWithContentView:(UIView *)contentView
                                      animated:(BOOL)animated
                                    completion:(TFYPopupViewCallback)completion {
    // 这里需要底部弹出框动画器，稍后会在动画器类中实现
    id animator = [[NSClassFromString(@"TFYPopupBottomSheetAnimator") alloc] init];
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    return [self showContentView:contentView
                   configuration:config
                        animator:animator
                        animated:animated
                      completion:completion];
}

+ (UIWindow *)currentWindow {
    if (@available(iOS 15.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    }
    return nil;
}

#pragma mark - Bottom Sheet Methods

- (void)enableBottomSheetGestures {
    if ([self.animator isKindOfClass:[TFYPopupBottomSheetAnimator class]]) {
        TFYPopupBottomSheetAnimator *bottomSheetAnimator = (TFYPopupBottomSheetAnimator *)self.animator;
        [bottomSheetAnimator enableGestures];
    }
}

- (void)disableBottomSheetGestures {
    if ([self.animator isKindOfClass:[TFYPopupBottomSheetAnimator class]]) {
        TFYPopupBottomSheetAnimator *bottomSheetAnimator = (TFYPopupBottomSheetAnimator *)self.animator;
        [bottomSheetAnimator disableGestures];
    }
}

- (BOOL)isBottomSheetGesturesEnabled {
    if ([self.animator isKindOfClass:[TFYPopupBottomSheetAnimator class]]) {
        TFYPopupBottomSheetAnimator *bottomSheetAnimator = (TFYPopupBottomSheetAnimator *)self.animator;
        return bottomSheetAnimator.isGesturesEnabled;
    }
    return NO;
}

#pragma mark - Gesture Handling

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    CGPoint velocity = [gesture velocityInView:self];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self handlePanBegan];
            break;
        case UIGestureRecognizerStateChanged:
            [self handlePanChangedWithTranslation:translation];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self handlePanEndedWithTranslation:translation velocity:velocity];
            break;
        default:
            break;
    }
}

- (void)handlePanBegan {
    // 停止任何正在进行的动画
    [self.layer removeAllAnimations];
    [self.contentView.layer removeAllAnimations];
    [self.backgroundView.layer removeAllAnimations];
}

- (void)handlePanChangedWithTranslation:(CGPoint)translation {
    CGFloat dragDistance = translation.y;
    CGFloat progress = fabs(dragDistance / self.bounds.size.height);
    
    // 应用拖动变换
    self.contentView.transform = CGAffineTransformMakeTranslation(0, dragDistance);
    
    // 更新背景透明度
    self.backgroundView.alpha = 1 - (progress * 0.8); // 保留一些最小透明度
}

- (void)handlePanEndedWithTranslation:(CGPoint)translation velocity:(CGPoint)velocity {
    CGFloat dragDistance = translation.y;
    CGFloat progress = fabs(dragDistance / self.bounds.size.height);
    
    if (progress > self.configuration.dragDismissThreshold || fabs(velocity.y) > 1000) {
        // 完成消失动画
        CGFloat remainingDistance = self.bounds.size.height - fabs(dragDistance);
        NSTimeInterval duration = remainingDistance / fabs(velocity.y);
        
        [UIView animateWithDuration:MIN(duration, 0.3) delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentView.transform = CGAffineTransformMakeTranslation(0, dragDistance > 0 ? self.bounds.size.height : -self.bounds.size.height);
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissAnimated:NO completion:nil];
        }];
    } else {
        // 恢复原位
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentView.transform = CGAffineTransformIdentity;
            self.backgroundView.alpha = 1;
        } completion:nil];
    }
}

#pragma mark - Event Handlers

- (void)backgroundViewClicked {
    if (!self.configuration.dismissOnBackgroundTap) return;
    
    // 检查代理是否允许消失
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewShouldDismiss:)]) {
        if (![self.delegate popupViewShouldDismiss:self]) {
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidTapBackground:)]) {
        [self.delegate popupViewDidTapBackground:self];
    }
    
    [self dismissAnimated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.configuration.keyboardConfiguration.isEnabled) return;
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat keyboardHeight = keyboardFrame.size.height;
    CGRect contentFrame = [self.contentView convertRect:self.contentView.bounds toView:nil];
    CGFloat overlap = CGRectGetMaxY(contentFrame) - (self.bounds.size.height - keyboardHeight);
    
    if (overlap > 0) {
        CGFloat offset = overlap + self.configuration.keyboardConfiguration.additionalOffset;
        
        // 添加触觉反馈
        if (self.configuration.enableHapticFeedback) {
            UIImpactFeedbackGenerator *impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [impactFeedback impactOccurred];
        }
        
        [UIView animateWithDuration:duration delay:0 options:(UIViewAnimationOptions)curve animations:^{
            switch (self.configuration.keyboardConfiguration.avoidingMode) {
                case TFYKeyboardAvoidingModeTransform:
                    self.contentView.transform = CGAffineTransformMakeTranslation(0, -offset);
                    break;
                case TFYKeyboardAvoidingModeConstraint:
                    // 更新约束
                    self.keyboardAdjustmentConstraint.constant = -offset;
                    [self layoutIfNeeded];
                    break;
                case TFYKeyboardAvoidingModeResize:
                    self.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - keyboardHeight);
                    break;
            }
        } completion:nil];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:(UIViewAnimationOptions)curve animations:^{
        switch (self.configuration.keyboardConfiguration.avoidingMode) {
            case TFYKeyboardAvoidingModeTransform:
                self.contentView.transform = CGAffineTransformIdentity;
                break;
            case TFYKeyboardAvoidingModeConstraint:
                self.keyboardAdjustmentConstraint.constant = 0;
                [self layoutIfNeeded];
                break;
            case TFYKeyboardAvoidingModeResize:
                self.frame = self.bounds;
                break;
        }
    } completion:nil];
}

- (void)didReceiveMemoryWarning:(NSNotification *)notification {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidReceiveMemoryWarning:)]) {
        [self.delegate popupViewDidReceiveMemoryWarning:self];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 允许与UIScrollView的手势识别器同时工作
    return [otherGestureRecognizer.view isKindOfClass:[UIScrollView class]];
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma mark - UIView Category Implementation

@implementation UIView (TFYPopupView)

- (TFYPopupView *)popupView {
    if ([self.superview isKindOfClass:[TFYPopupView class]]) {
        return (TFYPopupView *)self.superview;
    }
    return nil;
}

- (TFYPopupView *)findPopupView {
    UIView *currentView = self;
    while (currentView != nil) {
        if ([currentView isKindOfClass:[TFYPopupView class]]) {
            return (TFYPopupView *)currentView;
        }
        currentView = currentView.superview;
    }
    return nil;
}

@end
