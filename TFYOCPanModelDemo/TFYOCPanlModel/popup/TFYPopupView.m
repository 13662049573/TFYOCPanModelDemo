//
//  TFYPopupView.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：主要弹窗视图类实现
//  功能：提供完整的弹窗功能，包括显示、消失、优先级管理、容器自动发现等
//

#import "TFYPopupView.h"
#import "TFYPopupBottomSheetAnimator.h"
#import "TFYPopupBaseAnimator.h"
#import "TFYPopupAnimators.h"
#import "TFYPopupPriorityManager.h"
#import "TFYPopupContainerManager.h"
#import "TFYPopup.h"

@interface TFYPopupView () <UIGestureRecognizerDelegate>

#pragma mark - Private Properties

/// 容器视图
@property (nonatomic, weak) UIView *containerView;

/// 内容视图
@property (nonatomic, strong) UIView *contentView;

/// 动画器
@property (nonatomic, strong) id<TFYPopupViewAnimator> animator;

/// 配置对象
@property (nonatomic, strong) TFYPopupViewConfiguration *configuration;

/// 是否正在动画中
@property (nonatomic, assign) BOOL isAnimating;

/// 是否正在清理中
@property (nonatomic, assign) BOOL isBeingCleanedUp;

/// 当前优先级
@property (nonatomic, assign) TFYPopupPriority currentPriority;

#pragma mark - Layout Constraints

/// 键盘调整约束
@property (nonatomic, strong, nullable) NSLayoutConstraint *keyboardAdjustmentConstraint;

/// 容器约束数组
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *containerConstraints;

#pragma mark - Gesture Recognizers

/// 拖拽手势
@property (nonatomic, strong, nullable) UIPanGestureRecognizer *panGesture;

/// 向上滑动手势
@property (nonatomic, strong, nullable) UISwipeGestureRecognizer *swipeUpGesture;

/// 向下滑动手势
@property (nonatomic, strong, nullable) UISwipeGestureRecognizer *swipeDownGesture;

/// 向左滑动手势
@property (nonatomic, strong, nullable) UISwipeGestureRecognizer *swipeLeftGesture;

/// 向右滑动手势
@property (nonatomic, strong, nullable) UISwipeGestureRecognizer *swipeRightGesture;

#pragma mark - Static Properties

/// 当前显示的弹窗数组
@property (nonatomic, class, readonly) NSMutableArray<TFYPopupView *> *currentPopupViews;

/// 弹窗操作队列
@property (nonatomic, class, readonly) dispatch_queue_t popupQueue;

@end

@implementation TFYPopupView
#pragma mark - Property Setters

/// 设置是否可消失
/// @param isDismissible 是否可消失
- (void)setIsDismissible:(BOOL)isDismissible {
    _isDismissible = isDismissible;
    if (self.backgroundView) {
        self.backgroundView.userInteractionEnabled = (self.configuration.dismissOnBackgroundTap && _isDismissible);
    }
}

#pragma mark - Internal Helpers

/// 处理优先级弹窗显示的内部方法
/// @param selectedContainer 选中的容器信息
/// @param contentView 内容视图
/// @param configuration 配置对象
/// @param animator 动画器
/// @param animated 是否动画
/// @param completion 完成回调
/// @return 是否成功处理
+ (BOOL)tfy_handlePriorityShowWithSelectedContainer:(TFYPopupContainerInfo *)selectedContainer
                                        contentView:(UIView *)contentView
                                      configuration:(TFYPopupViewConfiguration *)configuration
                                           animator:(id<TFYPopupViewAnimator>)animator
                                           animated:(BOOL)animated
                                         completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    if (!selectedContainer || !selectedContainer.containerView) {
        if (completion) completion(nil);
        return NO;
    }
    __block BOOL result = NO;
    void (^work)(void) = ^{
        TFYPopupView *popup = [[TFYPopupView alloc] initWithContainerView:selectedContainer.containerView
                                                              contentView:contentView
                                                                 animator:animator
                                                            configuration:configuration];
        if (!popup) {
            if (completion) completion(nil);
            result = NO;
            return;
        }
        popup.currentPriority = configuration.priority;
        BOOL success = [[TFYPopupPriorityManager sharedManager] addPopup:popup
                                                                priority:configuration.priority
                                                                strategy:configuration.priorityStrategy
                                                              completion:^{
            [popup displayAnimated:animated completion:completion];
        }];
        if (!success && completion) completion(popup);
        result = success;
    };
    if ([NSThread isMainThread]) {
        work();
    } else {
        dispatch_sync(dispatch_get_main_queue(), work);
    }
    return result;
}

#pragma mark - Static Properties

/// 当前显示的弹窗数组（静态变量）
static NSMutableArray<TFYPopupView *> *_currentPopupViews = nil;

/// 弹窗操作队列（静态变量）
static dispatch_queue_t _popupQueue = nil;

/// 获取当前显示的弹窗数组
/// @return 当前显示的弹窗数组
+ (NSMutableArray<TFYPopupView *> *)currentPopupViews {
    if (!_currentPopupViews) {
        _currentPopupViews = [NSMutableArray array];
    }
    return _currentPopupViews;
}

/// 获取弹窗操作队列
/// @return 弹窗操作队列
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
    
    // 参数验证
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

        // 应用状态处理（后台自动消失等）
        [self setupApplicationStateHandling];
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
    self.backgroundView.userInteractionEnabled = (self.configuration.dismissOnBackgroundTap && self.isDismissible);
    [self.backgroundView addTarget:self
                            action:@selector(backgroundViewClicked)
                  forControlEvents:UIControlEventTouchUpInside];
    
    // 确保内容视图使用Auto Layout
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 设置内容视图的约束优先级，确保自动尺寸能够正常工作
    [self.contentView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.contentView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.contentView];
    
    [self.animator setupPopupView:self
                      contentView:self.contentView
                   backgroundView:self.backgroundView];
}

- (void)setupGestures {
    // 如果是底部弹出框动画器，跳过手势设置（由动画器自己处理）
    if ([self.animator isKindOfClass:NSClassFromString(@"TFYPopupBottomSheetAnimator")]) {
        return;
    }
    
    // 设置拖拽手势
    if (self.configuration.enableDragToDismiss) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self 
                                                                  action:@selector(handlePanGesture:)];
        self.panGesture.delegate = self;
        [self.contentView addGestureRecognizer:self.panGesture];
    }
    
    // 设置滑动手势
    if (self.configuration.enableSwipeToDismiss) {
        [self setupSwipeGestures];
    }
}

- (void)setupSwipeGestures {
    // 向上滑动
    self.swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    self.swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.contentView addGestureRecognizer:self.swipeUpGesture];
    
    // 向下滑动
    self.swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    self.swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.contentView addGestureRecognizer:self.swipeDownGesture];
    
    // 向左滑动
    self.swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    self.swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.contentView addGestureRecognizer:self.swipeLeftGesture];
    
    // 向右滑动
    self.swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    self.swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.contentView addGestureRecognizer:self.swipeRightGesture];
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

- (void)setupApplicationStateHandling {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
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
            // 自动宽度：根据内容自动计算
            if (config.hasMaxWidth) {
                [self.containerConstraints addObject:
                 [self.contentView.widthAnchor constraintLessThanOrEqualToConstant:config.maxWidth]];
            }
            // 添加最小宽度约束，确保弹窗不会过小
            if (config.hasMinWidth) {
                [self.containerConstraints addObject:
                 [self.contentView.widthAnchor constraintGreaterThanOrEqualToConstant:config.minWidth]];
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
            // 自动高度：根据内容自动计算
            if (config.hasMaxHeight) {
                [self.containerConstraints addObject:
                 [self.contentView.heightAnchor constraintLessThanOrEqualToConstant:config.maxHeight]];
            }
            // 添加最小高度约束，确保弹窗不会过小
            if (config.hasMinHeight) {
                [self.containerConstraints addObject:
                 [self.contentView.heightAnchor constraintGreaterThanOrEqualToConstant:config.minHeight]];
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
    // 应用主题配置
    switch (self.configuration.theme) {
        case TFYPopupThemeLight:
            self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
            self.contentView.backgroundColor = [UIColor whiteColor];
            break;
        case TFYPopupThemeDark:
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            self.contentView.backgroundColor = [UIColor blackColor];
            break;
        case TFYPopupThemeCustom:
            if (self.configuration.customThemeBackgroundColor) {
                self.backgroundColor = self.configuration.customThemeBackgroundColor;
                self.contentView.backgroundColor = self.configuration.customThemeBackgroundColor;
                self.contentView.layer.cornerRadius = self.configuration.customThemeCornerRadius;
                self.contentView.layer.masksToBounds = YES;
            }
            break;
        default:
            break;
    }
    
    // 应用通用的圆角配置
    [self applyCornerRadius];
}

- (void)applyCornerRadius {
    // 优先使用容器配置的圆角
    CGFloat cornerRadius = 0;
    
    if (self.configuration.containerConfiguration.cornerRadius > 0) {
        cornerRadius = self.configuration.containerConfiguration.cornerRadius;
    } else if (self.configuration.cornerRadius > 0) {
        cornerRadius = self.configuration.cornerRadius;
    }
    
    if (cornerRadius > 0) {
        self.contentView.layer.cornerRadius = cornerRadius;
        self.contentView.layer.masksToBounds = YES;
        
        // 如果有阴影配置，需要使用容器视图来设置阴影
        if (self.configuration.containerConfiguration.shadowEnabled) {
            [self applyShadowWithCornerRadius:cornerRadius];
        }
    }
}

- (void)applyShadowWithCornerRadius:(CGFloat)cornerRadius {
    // 为了同时显示圆角和阴影，需要使用两层视图
    // contentView 设置圆角和裁剪
    // self 设置阴影（不能裁剪）
    
    TFYPopupContainerConfiguration *config = self.configuration.containerConfiguration;
    
    // 设置阴影
    self.layer.shadowColor = config.shadowColor.CGColor;
    self.layer.shadowOpacity = config.shadowOpacity;
    self.layer.shadowRadius = config.shadowRadius;
    self.layer.shadowOffset = config.shadowOffset;
    self.layer.masksToBounds = NO;
    
    // 延迟设置阴影路径，确保 contentView 已经有正确的 frame
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateShadowPathWithCornerRadius:cornerRadius];
    });
}

- (void)updateShadowPathWithCornerRadius:(CGFloat)cornerRadius {
    // 使用 contentView 的 frame（相对于 self）来创建阴影路径
    CGRect shadowRect = self.contentView.frame;
    if (!CGRectIsEmpty(shadowRect)) {
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowRect 
                                                              cornerRadius:cornerRadius];
        self.layer.shadowPath = shadowPath.CGPath;
    }
}

- (void)animateShadowDisplay {
    // 获取动画持续时间，与内容动画保持一致
    NSTimeInterval duration = 0.25; // 默认动画时长
    
    // 尝试从动画器获取更精确的时长
    if ([self.animator isKindOfClass:[TFYPopupBaseAnimator class]]) {
        TFYPopupBaseAnimator *baseAnimator = (TFYPopupBaseAnimator *)self.animator;
        duration = baseAnimator.displayDuration;
    }
    
    // 保存目标透明度值
    CGFloat targetOpacity = self.configuration.containerConfiguration.shadowOpacity;
    
    // 先设置透明度为 0
    self.layer.shadowOpacity = 0.0;
    
    // 动画阴影透明度从 0 到目标值
    CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowOpacityAnimation.fromValue = @(0.0);
    shadowOpacityAnimation.toValue = @(targetOpacity);
    shadowOpacityAnimation.duration = duration;
    shadowOpacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shadowOpacityAnimation.fillMode = kCAFillModeForwards;
    shadowOpacityAnimation.removedOnCompletion = NO;
    
    [self.layer addAnimation:shadowOpacityAnimation forKey:@"shadowDisplayAnimation"];
    // 同步模型值，确保后续动画从正确状态开始
    self.layer.shadowOpacity = targetOpacity;
}

- (void)animateShadowDismiss {
    // 获取动画持续时间，与内容动画保持一致
    NSTimeInterval duration = 0.25; // 默认动画时长
    
    // 尝试从动画器获取更精确的时长
    if ([self.animator isKindOfClass:[TFYPopupBaseAnimator class]]) {
        TFYPopupBaseAnimator *baseAnimator = (TFYPopupBaseAnimator *)self.animator;
        duration = baseAnimator.dismissDuration;
    }
    
    // 动画阴影透明度从当前值到 0
    CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowOpacityAnimation.fromValue = @(self.layer.shadowOpacity);
    shadowOpacityAnimation.toValue = @(0.0);
    shadowOpacityAnimation.duration = duration;
    shadowOpacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shadowOpacityAnimation.fillMode = kCAFillModeForwards;
    shadowOpacityAnimation.removedOnCompletion = NO;
    
    [self.layer addAnimation:shadowOpacityAnimation forKey:@"shadowDismissAnimation"];
    // 同步模型值
    self.layer.shadowOpacity = 0.0f;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    [self.animator refreshLayoutPopupView:self contentView:self.contentView];
    
    // 更新阴影路径（如果有的话）
    if (self.configuration.containerConfiguration.shadowEnabled && self.layer.shadowPath) {
        CGFloat cornerRadius = self.configuration.containerConfiguration.cornerRadius > 0 
            ? self.configuration.containerConfiguration.cornerRadius 
            : self.configuration.cornerRadius;
        
        if (cornerRadius > 0) {
            [self updateShadowPathWithCornerRadius:cornerRadius];
        }
    }
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
        self.backgroundView.userInteractionEnabled = (configuration.dismissOnBackgroundTap && self.isDismissible);
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

- (void)displayAnimated:(BOOL)animated completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    [self performDisplayAnimated:animated completion:completion];
}

- (void)dismissAnimated:(BOOL)animated completion:(nullable TFYPopupViewCallback)completion {
    // 如果启用了优先级管理，通知优先级管理器
    if (self.configuration.enablePriorityManagement) {
        [[TFYPopupPriorityManager sharedManager] removePopup:self];
    }
    
    [self performDismissAnimated:animated completion:completion];
}

- (void)performDismissAnimated:(BOOL)animated completion:(nullable TFYPopupViewCallback)completion {
    // 清理模式：跳过一切限制，强制关闭
    if (self.isBeingCleanedUp) {
        NSLog(@"TFYPopupView: 强制关闭弹窗（清理模式）");
        // 直接继续执行关闭动画与清理
    } else {
        // 正常模式下才检查可消失和代理
        if (!self.isDismissible) {
            if (completion) completion();
            return;
        }
        if (self.isAnimating) {
            if (completion) completion();
            return;
        }
        // 检查代理是否允许消失
        if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewShouldDismiss:)]) {
            if (![self.delegate popupViewShouldDismiss:self]) {
                if (completion) completion();
                return;
            }
        }
    }
    
    self.isAnimating = YES;
    
    // 触发即将消失回调和代理
    if (self.willDismissCallback) {
        self.willDismissCallback();
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewWillDisappear:)]) {
        [self.delegate popupViewWillDisappear:self];
    }
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupWillDisappearNotification object:self];
    
    // 从当前显示的弹窗数组中移除（仅在非cleanupOldestPopup调用时）
    if (!self.isBeingCleanedUp) {
        dispatch_barrier_async([self.class popupQueue], ^{
            [[self.class currentPopupViews] removeObject:self];
        });
    }
    
    // 如果有阴影且需要动画，同时动画阴影透明度
    if (animated && self.configuration.containerConfiguration.shadowEnabled && self.layer.shadowOpacity > 0) {
        [self animateShadowDismiss];
    }
    
    __weak typeof(self) weakSelf = self;
    NSLog(@"TFYPopupView: 开始执行关闭动画，animated: %@", animated ? @"YES" : @"NO");
    [self.animator dismissContentView:self.contentView
                       backgroundView:self.backgroundView
                             animated:animated
                           completion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"TFYPopupView: 弹窗已被释放，无法完成清理");
            return;
        }
        
        strongSelf->_isPresenting = NO;
        strongSelf.isAnimating = NO;
        
        // 触发已经消失回调和代理
        if (strongSelf.didDismissCallback) {
            strongSelf.didDismissCallback();
        }
        
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(popupViewDidDisappear:)]) {
            [strongSelf.delegate popupViewDidDisappear:strongSelf];
        }
        
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupDidDisappearNotification object:strongSelf];
        [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupCountDidChangeNotification object:strongSelf];
        
        [strongSelf cleanup];
        
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Private Methods

- (void)performDisplayAnimated:(BOOL)animated completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    if (self.isAnimating) return;
    
    _isPresenting = YES;
    self.isAnimating = YES;
    
    // 确保视图已添加到容器中（仅在未添加时）
    if (self.superview == nil) {
        [self.containerView addSubview:self];
        self.frame = self.containerView.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    // 确保加入全局数组（优先级路径可能绕过了 showContentView:containerInfo: 中的添加）
    dispatch_barrier_async([self.class popupQueue], ^{
        if (![[self.class currentPopupViews] containsObject:self]) {
            [[self.class currentPopupViews] addObject:self];
        }
    });
    
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
    // 发送即将显示通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupWillAppearNotification object:self];
    
    // 如果有阴影且需要动画，同时动画阴影透明度
    if (animated && self.configuration.containerConfiguration.shadowEnabled) {
        [self animateShadowDisplay];
    }
    
    // 执行动画
    __weak typeof(self) weakSelf = self;
    [self.animator displayContentView:self.contentView
                       backgroundView:self.backgroundView
                             animated:animated
                           completion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(popupViewDidAppear:)]) {
            [strongSelf.delegate popupViewDidAppear:strongSelf];
        }
        
        if (completion) {
            completion(strongSelf);
        }
        
        strongSelf.isAnimating = NO;
        
        if (strongSelf.didDisplayCallback) {
            strongSelf.didDisplayCallback();
        }
        // 发送已显示与数量变化通知
        [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupDidAppearNotification object:strongSelf];
        [[NSNotificationCenter defaultCenter] postNotificationName:TFYPopupCountDidChangeNotification object:strongSelf];
    }];
}

- (void)setupInitialLayout {
    // 检查是否为需要自定义布局的动画器，如果是则跳过center约束设置
    if ([self.animator isKindOfClass:NSClassFromString(@"TFYPopupBottomSheetAnimator")] ||
        [self.animator isKindOfClass:NSClassFromString(@"TFYPopupBaseAnimator")]) {
        return; // 这些动画器使用自己的约束系统
    }
    
    // 设置内容视图的布局属性
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 对于自动尺寸，我们需要设置内容视图能够根据内容自动调整大小
    TFYPopupContainerConfiguration *config = self.configuration.containerConfiguration;
    
    if (config.width.type == TFYContainerDimensionTypeAutomatic || 
        config.height.type == TFYContainerDimensionTypeAutomatic) {
        
        // 自动尺寸：设置内容视图能够根据内容自动调整大小
        [NSLayoutConstraint activateConstraints:@[
            [self.contentView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [self.contentView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
        ]];
        // 强制布局更新
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];
    
    } else {
        // 固定尺寸：使用简单的中心约束
        [NSLayoutConstraint activateConstraints:@[
            [self.contentView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [self.contentView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
        ]];
    }
}

- (CGSize)calculateAutomaticSizeForContentView:(UIView *)contentView 
                                   withConfig:(TFYPopupContainerConfiguration *)config {
    CGSize automaticSize = CGSizeZero;
    
    // 获取屏幕尺寸
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    // 计算可用空间（减去安全区域和配置的边距）
    UIEdgeInsets safeInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeInsets = self.safeAreaInsets;
    }
    
    // 使用配置中的屏幕边距，如果没有设置则使用默认值
    UIEdgeInsets screenInsets = config.screenInsets;
    if (UIEdgeInsetsEqualToEdgeInsets(screenInsets, UIEdgeInsetsZero)) {
        screenInsets = UIEdgeInsetsMake(20, 20, 20, 20); // 默认屏幕边距
    }
    
    // 使用配置中的内容边距，如果没有设置则使用默认值
    UIEdgeInsets contentInsets = config.contentInsets;
    if (UIEdgeInsetsEqualToEdgeInsets(contentInsets, UIEdgeInsetsZero)) {
        contentInsets = UIEdgeInsetsMake(20, 20, 20, 20); // 默认内容边距
    }
    
    // 计算可用空间：屏幕尺寸 - 安全区域 - 屏幕边距
    CGFloat availableWidth = screenSize.width - safeInsets.left - safeInsets.right - screenInsets.left - screenInsets.right;
    CGFloat availableHeight = screenSize.height - safeInsets.top - safeInsets.bottom - screenInsets.top - screenInsets.bottom;
    
    // 尝试获取内容视图的固有尺寸
    CGSize intrinsicSize = contentView.intrinsicContentSize;
    
    if (!CGSizeEqualToSize(intrinsicSize, CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric))) {
        // 有固有尺寸，使用它作为基础
        automaticSize = intrinsicSize;
    } else {
        // 没有固有尺寸，尝试使用sizeThatFits
        CGSize fitsSize = [contentView sizeThatFits:CGSizeMake(availableWidth, availableHeight)];
        if (!CGSizeEqualToSize(fitsSize, CGSizeZero)) {
            automaticSize = fitsSize;
        } else {
            // 都没有，使用默认尺寸（基于配置的边距计算）
            CGFloat defaultWidth = MIN(280, availableWidth);
            CGFloat defaultHeight = MIN(200, availableHeight);
            automaticSize = CGSizeMake(defaultWidth, defaultHeight);
        }
    }
    
    // 应用最大最小尺寸限制
    if (config.hasMaxWidth && automaticSize.width > config.maxWidth) {
        automaticSize.width = config.maxWidth;
    }
    if (config.hasMaxHeight && automaticSize.height > config.maxHeight) {
        automaticSize.height = config.maxHeight;
    }
    if (config.hasMinWidth && automaticSize.width < config.minWidth) {
        automaticSize.width = config.minWidth;
    }
    if (config.hasMinHeight && automaticSize.height < config.minHeight) {
        automaticSize.height = config.minHeight;
    }
    
    // 确保不超过可用空间
    if (automaticSize.width > availableWidth) {
        automaticSize.width = availableWidth;
    }
    if (automaticSize.height > availableHeight) {
        automaticSize.height = availableHeight;
    }
    
    // 最终尺寸：内容尺寸 + 内容内边距
    automaticSize.width += contentInsets.left + contentInsets.right;
    automaticSize.height += contentInsets.top + contentInsets.bottom;
    
    return automaticSize;
}

- (void)cleanup {
    // 幂等保护：如果已不在视图层级，直接返回
    if (self.superview == nil && self.contentView.superview == nil) {
        return;
    }
    // 标记进入清理流程（允许在清理模式下继续向下执行）
    self.isBeingCleanedUp = YES;
    
    // 清理阴影动画
    [self.layer removeAnimationForKey:@"shadowDismissAnimation"];
    [self.layer removeAnimationForKey:@"shadowDisplayAnimation"];
    
    // 移除视图层级
    [self.contentView removeFromSuperview];
    [self removeFromSuperview];
    
    // 清理通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 清理手势识别器
    [self cleanupGestureRecognizers];
    
    // 清理约束
    [self cleanupConstraints];
}

/// 清理手势识别器
- (void)cleanupGestureRecognizers {
    // 清理内容视图的手势
    for (UIGestureRecognizer *gesture in self.contentView.gestureRecognizers.copy) {
        [self.contentView removeGestureRecognizer:gesture];
    }
    
    // 清理背景视图的手势
    for (UIGestureRecognizer *gesture in self.backgroundView.gestureRecognizers.copy) {
        [self.backgroundView removeGestureRecognizer:gesture];
    }
    
    // 清理手势属性
    self.panGesture = nil;
    self.swipeUpGesture = nil;
    self.swipeDownGesture = nil;
    self.swipeLeftGesture = nil;
    self.swipeRightGesture = nil;
}

/// 清理约束
- (void)cleanupConstraints {
    // 清理容器约束
    [NSLayoutConstraint deactivateConstraints:self.containerConstraints];
    [self.containerConstraints removeAllObjects];
    
    // 清理键盘调整约束
    if (self.keyboardAdjustmentConstraint) {
        self.keyboardAdjustmentConstraint.active = NO;
        self.keyboardAdjustmentConstraint = nil;
    }
}

#pragma mark - Static Methods

+ (void)cleanupOldestPopup {
    dispatch_barrier_async([self popupQueue], ^{
        NSMutableArray<TFYPopupView *> *popups = [self currentPopupViews];
        if (popups.count > 0) {
            TFYPopupView *oldestPopup = popups.firstObject;
            [popups removeObjectAtIndex:0];
            
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

+ (void)showContentView:(UIView *)contentView
                  configuration:(TFYPopupViewConfiguration *)configuration
                       animator:(id<TFYPopupViewAnimator>)animator
                       animated:(BOOL)animated
                     completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    
    // 参数验证
    if (!contentView) {
        NSLog(@"TFYPopupView Error: contentView不能为空");
        if (completion) completion(nil);
        return;
    }
    
    if (!configuration) {
        NSLog(@"TFYPopupView Error: configuration不能为空");
        if (completion) completion(nil);
        return;
    }
    
    if (!animator) {
        NSLog(@"TFYPopupView Error: animator不能为空");
        if (completion) completion(nil);
        return;
    }
    
    // 如果配置启用了容器自动发现，使用新的容器选择模式
    if (configuration.enableContainerAutoDiscovery) {
        [self showContentViewWithContainerSelection:contentView
                                      configuration:configuration
                                           animator:animator
                                           animated:animated
                                         completion:completion];
        return; // 异步操作，返回nil
    }
    
    // 否则使用传统模式（向后兼容）
    // 验证配置
    if (![configuration validate]) {
        NSAssert(NO, @"TFYPopupView: 配置验证失败，请检查配置参数");
        return;
    }
    
    // 使用容器管理器选择最佳容器
    [[TFYPopupContainerManager sharedManager] selectBestContainerWithCompletion:^(TFYPopupContainerInfo * _Nullable selectedContainer, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"TFYPopupView: 容器选择失败 - %@", error.localizedDescription);
                if (completion) completion(nil);
                return;
            }
            
            if (!selectedContainer || !selectedContainer.containerView) {
                NSLog(@"TFYPopupView: 没有可用的容器");
                if (completion) completion(nil);
                return;
            }
            
            // 检查弹窗数量限制
            if ([self currentPopupViews].count >= configuration.maxPopupCount) {
                [self cleanupOldestPopup];
            }
            
            // 创建弹窗
            TFYPopupView *popupView = [[TFYPopupView alloc] initWithContainerView:selectedContainer.containerView
                                                                      contentView:contentView
                                                                         animator:animator
                                                                    configuration:configuration];
            
            if (!popupView) {
                NSLog(@"TFYPopupView: 弹窗创建失败");
                if (completion) completion(nil);
                return;
            }
            
            // 确保背景配置被正确应用
            [popupView configureBackgroundWithStyle:configuration.backgroundStyle
                                               color:configuration.backgroundColor
                                           blurStyle:configuration.blurStyle];
            
            // 设置frame和autoresizing
            popupView.frame = selectedContainer.containerView.bounds;
            popupView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            // 添加到容器
            [selectedContainer.containerView addSubview:popupView];
            
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
        });
    }];
}

+ (void)showContentViewWithDefaultConfig:(UIView *)contentView
                                        animated:(BOOL)animated
                                      completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    // 确保启用容器自动发现（默认已启用）
    config.enableContainerAutoDiscovery = NO;
    // 创建默认动画器
    TFYPopupFadeInOutAnimator *animator = [[TFYPopupFadeInOutAnimator alloc] init];
    
    [self showContentView:contentView
                   configuration:config
                        animator:animator
                        animated:animated
                      completion:completion];
}

+ (void)dismissAllAnimated:(BOOL)animated completion:(nullable TFYPopupViewCallback)completion {
    dispatch_barrier_async([self popupQueue], ^{
        NSMutableArray<TFYPopupView *> *popups = [self currentPopupViews];
        NSArray<TFYPopupView *> *popupsCopy = [popups copy];
        [popups removeAllObjects];
        
        if (popupsCopy.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion();
            });
            return;
        }
        
        // 清理优先级管理器
        [[TFYPopupPriorityManager sharedManager] clearAllQueues];
        
        dispatch_group_t group = dispatch_group_create();
        
        for (TFYPopupView *popup in popupsCopy) {
            dispatch_group_enter(group);
            // 设置清理标志，避免重复移除
          // popup.isBeingCleanedUp = YES;
            
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

+ (void)showBottomSheetWithContentView:(UIView *)contentView
                                      animated:(BOOL)animated
                                    completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    // 这里需要底部弹出框动画器，稍后会在动画器类中实现
    id animator = [[NSClassFromString(@"TFYPopupBottomSheetAnimator") alloc] init];
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    // 禁用容器自动发现，使用同步模式确保能返回弹窗实例
    config.enableContainerAutoDiscovery = NO;
    [self showContentView:contentView
                   configuration:config
                        animator:animator
                        animated:animated
                      completion:completion];
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
            // 调用拖拽消失代理方法
            if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidDragToDismiss:)]) {
                [self.delegate popupViewDidDragToDismiss:self];
            }
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

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)gesture {
    // 检查代理是否允许消失
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewShouldDismiss:)]) {
        if (![self.delegate popupViewShouldDismiss:self]) {
            return;
        }
    }
    
    // 调用滑动消失代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidSwipeToDismiss:)]) {
        [self.delegate popupViewDidSwipeToDismiss:self];
    }
    
    // 根据滑动方向执行不同的消失动画
    CGAffineTransform finalTransform;
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            finalTransform = CGAffineTransformMakeTranslation(0, -self.bounds.size.height);
            break;
        case UISwipeGestureRecognizerDirectionDown:
            finalTransform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            finalTransform = CGAffineTransformMakeTranslation(-self.bounds.size.width, 0);
            break;
        case UISwipeGestureRecognizerDirectionRight:
            finalTransform = CGAffineTransformMakeTranslation(self.bounds.size.width, 0);
            break;
        default:
            finalTransform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
            break;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.transform = finalTransform;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissAnimated:NO completion:nil];
    }];
}

#pragma mark - Event Handlers

- (void)backgroundViewClicked {
    if (!self.configuration.dismissOnBackgroundTap) return;
    if (!self.isDismissible) return;
    
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
    UIViewAnimationOptions options = (UIViewAnimationOptions)(curve << 16);
    
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
        
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
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
    UIViewAnimationOptions options = (UIViewAnimationOptions)(curve << 16);
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
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

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    if (self.configuration.dismissWhenAppGoesToBackground && self.isDismissible) {
        [self dismissAnimated:NO completion:nil];
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

#pragma mark - Priority Methods Implementation

+ (void)showContentViewWithPriority:(UIView *)contentView
                                   priority:(TFYPopupPriority)priority
                                   strategy:(TFYPopupPriorityStrategy)strategy
                                   animated:(BOOL)animated
                                 completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    // 创建启用优先级管理的配置和默认动画器
    TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
    // 确保优先级管理被启用（虽然默认就是YES，但显式设置确保一致性）
    config.enablePriorityManagement = YES;
    config.priority = priority;
    config.priorityStrategy = strategy;
    config.backgroundColor = UIColor.clearColor;
    // 确保启用容器自动发现
    config.enableContainerAutoDiscovery = NO;
    
    TFYPopupFadeInOutAnimator *animator = [[TFYPopupFadeInOutAnimator alloc] init];
    
    [self showPriorityContentView:contentView
                           configuration:config
                                animator:animator
                                priority:priority
                                strategy:strategy
                                animated:animated
                              completion:completion];
}

+ (void)showContentViewWithPriority:(UIView *)contentView
                           baseConfiguration:(nullable TFYPopupViewConfiguration *)baseConfiguration
                                    priority:(TFYPopupPriority)priority
                                    strategy:(TFYPopupPriorityStrategy)strategy
                                    animated:(BOOL)animated
                                  completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    // 使用用户提供的基础配置，但确保优先级设置正确
    TFYPopupViewConfiguration *config = baseConfiguration ? [baseConfiguration copy] : [[TFYPopupViewConfiguration alloc] init];
    
    // 设置优先级相关配置
    config.enablePriorityManagement = YES;
    config.priority = priority;
    config.priorityStrategy = strategy;
    config.backgroundColor = UIColor.clearColor;
    // 确保启用容器自动发现
    config.enableContainerAutoDiscovery = NO;
    
    // 使用默认动画器（这个方法是便捷方法，为完全自定义请使用带animator参数的方法）
    TFYPopupFadeInOutAnimator *animator = [[TFYPopupFadeInOutAnimator alloc] init];
    
    [self showPriorityContentView:contentView
                           configuration:config
                                animator:animator
                                priority:priority
                                strategy:strategy
                                animated:animated
                              completion:completion];
}

+ (void)showContentViewWithPriority:(UIView *)contentView
                           baseConfiguration:(nullable TFYPopupViewConfiguration *)baseConfiguration
                                    animator:(nullable id<TFYPopupViewAnimator>)animator
                                    priority:(TFYPopupPriority)priority
                                    strategy:(TFYPopupPriorityStrategy)strategy
                                    animated:(BOOL)animated
                                  completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    // 使用用户提供的基础配置，但确保优先级设置正确
    TFYPopupViewConfiguration *config = baseConfiguration ? [baseConfiguration copy] : [[TFYPopupViewConfiguration alloc] init];
    
    // 设置优先级相关配置
    config.enablePriorityManagement = YES;
    config.priority = priority;
    config.priorityStrategy = strategy;
    config.backgroundColor = UIColor.clearColor;
    // 确保启用容器自动发现
    config.enableContainerAutoDiscovery = NO;
    
    // 使用用户提供的动画器，如果为nil则使用默认动画器
    id<TFYPopupViewAnimator> finalAnimator = animator ?: [[TFYPopupFadeInOutAnimator alloc] init];
    
    [self showPriorityContentView:contentView
                           configuration:config
                                animator:finalAnimator
                                priority:priority
                                strategy:strategy
                                animated:animated
                              completion:completion];
}

+ (void)showPriorityContentView:(UIView *)contentView
                  configuration:(TFYPopupViewConfiguration *)configuration
                       animator:(id<TFYPopupViewAnimator>)animator
                       priority:(TFYPopupPriority)priority
                       strategy:(TFYPopupPriorityStrategy)strategy
                       animated:(BOOL)animated
                             completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    
    // 更新配置中的优先级设置
    TFYPopupViewConfiguration *configCopy = [configuration copy];
    configCopy.priority = priority;
    configCopy.priorityStrategy = strategy;
    
    // 如果启用了优先级管理，使用优先级管理器
    if (configCopy.enablePriorityManagement) {
       [self showContentViewWithPriorityManager:contentView
                                          configuration:configCopy
                                               animator:animator
                                               animated:animated
                                             completion:completion];
    } else {
        // 不使用优先级管理，直接显示
        [self showContentView:contentView
                       configuration:configCopy
                            animator:animator
                            animated:animated
                          completion:completion];
    }
}

+ (void)showContentViewWithPriorityManager:(UIView *)contentView
                                     configuration:(TFYPopupViewConfiguration *)configuration
                                          animator:(id<TFYPopupViewAnimator>)animator
                                          animated:(BOOL)animated
                                        completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    
    // 如果启用了容器自动发现，使用容器选择模式
    if (configuration.enableContainerAutoDiscovery) {
        // 使用容器管理器选择最佳容器
        [[TFYPopupContainerManager sharedManager] selectBestContainerWithCompletion:^(TFYPopupContainerInfo * _Nullable selectedContainer, NSError * _Nullable error) {
            if (error) {
                NSLog(@"TFYPopupView: 容器选择失败 - %@", error.localizedDescription);
                if (completion) completion(nil);
                return;
            }
            [self tfy_handlePriorityShowWithSelectedContainer:selectedContainer
                                                  contentView:contentView
                                                configuration:configuration
                                                     animator:animator
                                                     animated:animated
                                                   completion:completion];
        }];
        return; // 重要：防止继续执行传统分支导致重复选择
    }
    
    // 否则使用传统模式（向后兼容）
    // 使用容器管理器选择最佳容器
    [[TFYPopupContainerManager sharedManager] selectBestContainerWithCompletion:^(TFYPopupContainerInfo * _Nullable selectedContainer, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"TFYPopupView: 容器选择失败 - %@", error.localizedDescription);
                if (completion) completion(nil);
                return;
            }
            
            if (!selectedContainer || !selectedContainer.containerView) {
                NSLog(@"TFYPopupView: 没有可用的容器");
                if (completion) completion(nil);
                return;
            }
            
            BOOL success = [self tfy_handlePriorityShowWithSelectedContainer:selectedContainer
                                                                  contentView:contentView
                                                                configuration:configuration
                                                                     animator:animator
                                                                     animated:animated
                                                                   completion:completion];
            if (!success) {
                NSLog(@"TFYPopupView: 优先级管理器添加弹窗失败");
            }
        });
    }];
}

#pragma mark - Priority Query Methods Implementation

+ (TFYPopupPriority)currentHighestPriority {
    return [[TFYPopupPriorityManager sharedManager] currentHighestPriority];
}

+ (NSArray<TFYPopupView *> *)popupsWithPriority:(TFYPopupPriority)priority {
    return [[TFYPopupPriorityManager sharedManager] popupsWithPriority:priority];
}

+ (void)clearPopupsWithPriorityLowerThan:(TFYPopupPriority)priority {
    [[TFYPopupPriorityManager sharedManager] clearPopupsWithPriorityLowerThan:priority];
}

+ (void)pausePriorityQueue {
    [[TFYPopupPriorityManager sharedManager] pauseQueue];
}

+ (void)resumePriorityQueue {
    [[TFYPopupPriorityManager sharedManager] resumeQueue];
}

+ (NSInteger)waitingQueueCount {
    NSArray *waitingQueue = [[TFYPopupPriorityManager sharedManager] waitingQueue];
    return waitingQueue.count;
}

+ (void)logPriorityQueue {
    [[TFYPopupPriorityManager sharedManager] logPriorityQueue];
}

+ (void)showContentViewWithContainerSelection:(UIView *)contentView
                                        configuration:(TFYPopupViewConfiguration *)configuration
                                             animator:(id<TFYPopupViewAnimator>)animator
                                             animated:(BOOL)animated
                                           completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    // 验证配置
    if (![configuration validate]) {
        NSAssert(NO, @"TFYPopupView: 配置验证失败，请检查配置参数");
        if (completion) completion(nil);
        return;
    }
    [[TFYPopupContainerManager sharedManager] selectBestContainerWithCompletion:^(TFYPopupContainerInfo * _Nullable selectedContainer, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error || !selectedContainer || !selectedContainer.containerView) {
                if (completion) completion(nil);
                return;
            }
            [self showContentView:contentView
                     containerInfo:selectedContainer
                     configuration:configuration
                          animator:animator
                          animated:animated
                        completion:completion];
        });
    }];
}

+ (instancetype)showContentView:(UIView *)contentView
                  containerInfo:(TFYPopupContainerInfo *)containerInfo
                  configuration:(TFYPopupViewConfiguration *)configuration
                       animator:(id<TFYPopupViewAnimator>)animator
                       animated:(BOOL)animated
                     completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    
    if (!containerInfo || !containerInfo.containerView) {
        NSAssert(NO, @"TFYPopupView: 容器信息无效");
        return nil;
    }
    
    // 验证配置
    if (![configuration validate]) {
        NSAssert(NO, @"TFYPopupView: 配置验证失败，请检查配置参数");
        return nil;
    }
    
    // 检查弹窗数量限制
    if ([self currentPopupViews].count >= configuration.maxPopupCount) {
        [self cleanupOldestPopup];
    }
    
    // 创建弹窗
    TFYPopupView *popupView = [[TFYPopupView alloc] initWithContainerView:containerInfo.containerView
                                                              contentView:contentView
                                                                 animator:animator
                                                            configuration:configuration];
    
    if (!popupView) {
        return nil;
    }
    
    // 确保背景配置被正确应用
    [popupView configureBackgroundWithStyle:configuration.backgroundStyle
                                       color:configuration.backgroundColor
                                   blurStyle:configuration.blurStyle];
    
    // 设置frame和autoresizing
    popupView.frame = containerInfo.containerView.bounds;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // 添加到容器
    [containerInfo.containerView addSubview:popupView];
    // 确保位于最前，避免被其他视图遮挡
    [containerInfo.containerView bringSubviewToFront:popupView];
    
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

+ (void)showContentView:(UIView *)contentView
                  containerView:(UIView *)containerView
                  configuration:(TFYPopupViewConfiguration *)configuration
                       animator:(id<TFYPopupViewAnimator>)animator
                       animated:(BOOL)animated
                     completion:(void (^)(TFYPopupView * _Nullable pop))completion {
    
    if (!containerView) {
        NSAssert(NO, @"TFYPopupView: 容器视图不能为空");
        return;
    }
    
    // 创建容器信息
    NSString *name = [NSString stringWithFormat:@"View_%p_%@", containerView, NSStringFromClass([containerView class])];
    TFYPopupContainerInfo *containerInfo = [TFYPopupContainerInfo viewContainer:containerView name:name];
    
    [self showContentView:contentView
                    containerInfo:containerInfo
                    configuration:configuration
                         animator:animator
                         animated:animated
                       completion:completion];
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
