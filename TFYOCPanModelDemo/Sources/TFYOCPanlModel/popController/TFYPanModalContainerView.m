//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalContainerView.m
//  TFYPanModal
//
//  Created by heath wang on 2019/10/17.
//

#import <TFYOCPanlModel/TFYPanModalContainerView.h>
#import <TFYOCPanlModel/TFYPanModalContentView.h>
#import <TFYOCPanlModel/TFYPanModalPresentableHandler.h>
#import <TFYOCPanlModel/TFYDimmedView.h>
#import <TFYOCPanlModel/TFYPanContainerView.h>
#import <TFYOCPanlModel/UIView+TFY_Frame.h>
#import <TFYOCPanlModel/TFYPanIndicatorView.h>
#import <TFYOCPanlModel/TFYPanModalAnimator.h>

@interface TFYPanModalContainerView () <TFYPanModalPresentableHandlerDelegate, TFYPanModalPresentableHandlerDataSource>

@property (nonatomic, strong) TFYPanModalContentView<TFYPanModalPresentable> *contentView;
@property (nonatomic, weak) UIView *presentingView;

@property (nonatomic, strong) TFYPanModalPresentableHandler *handler;

// 判断弹出的view是否在做动画
@property (nonatomic, assign) BOOL isPresentedViewAnimating;
@property (nonatomic, assign) PresentationState currentPresentationState;
@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, assign) BOOL isDismissing;

// view
@property (nonatomic, strong) TFYDimmedView *backgroundView;
@property (nonatomic, strong) TFYPanContainerView *panContainerView;
@property (nonatomic, strong) UIView<TFYPanModalIndicatorProtocol> *dragIndicatorView;

@property (nonatomic, copy) void(^animationBlock)(void);

@property (nullable, nonatomic, strong) UISelectionFeedbackGenerator *feedbackGenerator API_AVAILABLE(ios(10.0));

@end

@implementation TFYPanModalContainerView {
    UIView *_bottomCustomContainerView;
}

// =====================
// 详细中文注释与健壮性补充
// =====================
//
// 1. 构造方法、动画、布局、事件处理等关键方法补充中文注释
// 2. 重要属性、内部状态、回调点补充注释
// 3. 关键分支、易混淆逻辑增加注释说明
//
- (instancetype)initWithPresentingView:(UIView *)presentingView contentView:(TFYPanModalContentView<TFYPanModalPresentable> *)contentView {
    self = [super init];
    if (self) {
        _presentingView = presentingView;
        _contentView = contentView;
    }

    return self;
}

- (void)show {
    [self prepare];
    [self presentAnimationWillBegin];
    [self beginPresentAnimation];
}

- (void)dismissAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (flag) {
        self.animationBlock = ^{
            if (completion) completion();
        };
        [self dismiss:NO mode:PanModalInteractiveModeNone];
    } else {
        self.isDismissing = YES;
        [[self presentable] panModalWillDismiss];
        [self removeFromSuperview];
        [[self presentable] panModalDidDismissed];
        if (completion) completion();
        self.isDismissing = NO;
    }
}

- (void)prepare {
    [self.presentingView addSubview:self];
    self.frame = self.presentingView.bounds;

    if (_handler) {
        _handler.delegate = nil;
        _handler.dataSource = nil;
        _handler = nil;
    }
    _handler = [[TFYPanModalPresentableHandler alloc] initWithPresentable:self.contentView];
    _handler.delegate = self;
    _handler.dataSource = self;

    if (@available(iOS 10.0, *)) {
        _feedbackGenerator = [UISelectionFeedbackGenerator new];
        [_feedbackGenerator prepare];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		@try {
			[self.superview removeObserver:self forKeyPath:@"frame"];
		} @catch (__unused NSException *exception) {}
		[newSuperview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (object == self.presentingView && [keyPath isEqualToString:@"frame"]) {
		self.frame = self.presentingView.bounds;
		[self setNeedsLayoutUpdate];
		[self updateDragIndicatorViewFrame];
		[self.contentView pan_panModalTransitionTo:self.contentView.pan_presentationState animated:NO];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)presentAnimationWillBegin {
    [[self presentable] panModalTransitionWillBegin];
    [self layoutBackgroundView];

    if ([[self presentable] originPresentationState] == PresentationStateLong) {
        self.currentPresentationState = PresentationStateLong;
    } else if ([[self presentable] originPresentationState] == PresentationStateMedium) {
        self.currentPresentationState = PresentationStateMedium;
    }
    
    [self addSubview:self.panContainerView];
    [self layoutPresentedView];
    
    [self.handler configureScrollViewInsets];
    [[self presentable] presentedViewDidMoveToSuperView];
}

- (void)beginPresentAnimation {
    self.isPresenting = YES;
    CGFloat yPos = self.contentView.shortFormYPos;
    if ([[self presentable] originPresentationState] == PresentationStateLong) {
        yPos = self.contentView.longFormYPos;
    } else if ([[self presentable] originPresentationState] == PresentationStateMedium) {
        yPos = self.contentView.mediumFormYPos;
    }
    
    // refresh layout
    [self configureViewLayout];
    [self adjustPresentedViewFrame];

    self.panContainerView.pan_top = self.pan_height;
    
    if ([[self presentable] isHapticFeedbackEnabled]) {
        if (@available(iOS 10.0, *)) {
            [self.feedbackGenerator selectionChanged];
        }
    }
    
    [TFYPanModalAnimator animate:^{
        self.panContainerView.pan_top = yPos;
        self.backgroundView.dimState = DimStateMax;
    } config:[self presentable] completion:^(BOOL completion) {
        self.isPresenting = NO;
        [[self presentable] panModalTransitionDidFinish];
        
        if (@available(iOS 10.0, *)) {
            self.feedbackGenerator = nil;
        }
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureViewLayout];
}

#pragma mark - public method

- (void)setNeedsLayoutUpdate {

    [self configureViewLayout];
    [self updateBackgroundColor];
    [self.handler observeScrollable];
    [self adjustPresentedViewFrame];
    [self.handler configureScrollViewInsets];

    [self updateContainerViewShadow];
    [self updateDragIndicatorView];
    [self updateRoundedCorners];
}

- (void)updateUserHitBehavior {
    [self checkBackgroundViewEventPass];
    [self checkPanGestureRecognizer];
}

- (void)transitionToState:(PresentationState)state animated:(BOOL)animated {

    if (![self.presentable shouldTransitionToState:state]) return;

    [self.dragIndicatorView didChangeToState:TFYIndicatorStateNormal];
    [self.presentable willTransitionToState:state];

    switch (state) {
        case PresentationStateLong: {
            [self snapToYPos:self.handler.longFormYPosition animated:animated];
        }
            break;
        case PresentationStateMedium: {
            [self snapToYPos:self.handler.mediumFormYPosition animated:animated];
        }
            break;
        case PresentationStateShort: {
            [self snapToYPos:self.handler.shortFormYPosition animated:animated];
        }
            break;
        default:
            break;
    }
    self.currentPresentationState = state;
    [[self presentable] didChangeTransitionToState:state];
}

- (void)setScrollableContentOffset:(CGPoint)offset animated:(BOOL)animated {
    [self.handler setScrollableContentOffset:offset animated:animated];
}

#pragma mark - layout

- (void)adjustPresentedViewFrame {
    CGRect frame = self.frame;
    CGSize size = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame) - self.handler.anchoredYPosition);
    
    self.panContainerView.pan_size = frame.size;
    self.panContainerView.contentView.frame = CGRectMake(0, 0, size.width, size.height);
    self.contentView.frame = self.panContainerView.contentView.bounds;
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)configureViewLayout {

    [self.handler configureViewLayout];
    self.userInteractionEnabled = [[self presentable] isUserInteractionEnabled];
}

- (void)layoutBackgroundView {
    [self addSubview:self.backgroundView];
    [self updateBackgroundColor];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;

    NSArray *hCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:@{@"backgroundView": self.backgroundView}];
    NSArray *vCons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:@{@"backgroundView": self.backgroundView}];
    [NSLayoutConstraint activateConstraints:hCons];
    [NSLayoutConstraint activateConstraints:vCons];
}

- (void)updateBackgroundColor {
    self.backgroundView.blurTintColor = [self.presentable backgroundConfig].blurTintColor;
}

- (void)layoutPresentedView {
    if (!self.presentable)
        return;

    self.handler.presentedView = self.panContainerView;
    
    if ([[self presentable] allowsTouchEventsPassingThroughTransitionView]) {
        [self.panContainerView addGestureRecognizer:self.handler.panGestureRecognizer];
    } else {
        [self addGestureRecognizer:self.handler.panGestureRecognizer];
    }

    [self setNeedsLayoutUpdate];
    [self adjustPanContainerBackgroundColor];
}

- (void)adjustPanContainerBackgroundColor {
    self.panContainerView.contentView.backgroundColor = self.contentView.backgroundColor ? : [self.presentable panScrollable].backgroundColor;
}

- (void)updateDragIndicatorView {
    if ([self.presentable showDragIndicator]) {
        [self addDragIndicatorView];
    } else {
        self.dragIndicatorView.hidden = YES;
    }
}

- (void)addDragIndicatorView {
    // if has been add, won't update it.
    self.dragIndicatorView.hidden = NO;

    if (self.dragIndicatorView.superview == self.panContainerView) {
		[self updateDragIndicatorViewFrame];
        [self.dragIndicatorView didChangeToState:TFYIndicatorStateNormal];
        return;
    }

    self.handler.dragIndicatorView = self.dragIndicatorView;
    [self.panContainerView addSubview:self.dragIndicatorView];
	[self updateDragIndicatorViewFrame];

    [self.dragIndicatorView setupSubviews];
    [self.dragIndicatorView didChangeToState:TFYIndicatorStateNormal];
}

- (void)updateDragIndicatorViewFrame {
	CGSize indicatorSize = [self.dragIndicatorView indicatorSize];
	self.dragIndicatorView.frame = CGRectMake((self.panContainerView.pan_width - indicatorSize.width) / 2, -kIndicatorYOffset - indicatorSize.height, indicatorSize.width, indicatorSize.height);
}

- (void)updateContainerViewShadow {
    TFYPanModalShadow *shadow = [[self presentable] contentShadow];
    if (shadow.shadowColor) {
        [self.panContainerView updateShadow:shadow.shadowColor shadowRadius:shadow.shadowRadius shadowOffset:shadow.shadowOffset shadowOpacity:shadow.shadowOpacity];
    } else {
        [self.panContainerView clearShadow];
    }
}

- (void)updateRoundedCorners {
    if ([self.presentable shouldRoundTopCorners]) {
        [self addRoundedCornersToView:self.panContainerView.contentView];
    } else {
        [self resetRoundedCornersToView:self.panContainerView.contentView];
    }
}

- (void)addRoundedCornersToView:(UIView *)view {
    CGFloat radius = [self.presentable cornerRadius];

    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(radius, radius)];

    CAShapeLayer *mask = [CAShapeLayer new];
    mask.path = bezierPath.CGPath;
    view.layer.mask = mask;

    // 提高性能
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)resetRoundedCornersToView:(UIView *)view {
    view.layer.mask = nil;
    view.layer.shouldRasterize = NO;
}

- (void)snapToYPos:(CGFloat)yPos animated:(BOOL)animated {

    if (animated) {
        [TFYPanModalAnimator animate:^{
            self.isPresentedViewAnimating = YES;
            [self adjustToYPos:yPos];
        } config:self.presentable completion:^(BOOL completion) {
            self.isPresentedViewAnimating = NO;
        }];
    } else {
        [self adjustToYPos:yPos];
    }

}

- (void)adjustToYPos:(CGFloat)yPos {
    self.panContainerView.pan_top = MAX(yPos, self.handler.anchoredYPosition);

    // change dim background starting from shortFormYPosition.
    if (self.panContainerView.frame.origin.y >= self.handler.shortFormYPosition) {

        CGFloat yDistanceFromShortForm = self.panContainerView.frame.origin.y - self.handler.shortFormYPosition;
        CGFloat bottomHeight = self.pan_height - self.handler.shortFormYPosition;
        CGFloat percent = yDistanceFromShortForm / bottomHeight;
        self.backgroundView.dimState = DimStatePercent;
        self.backgroundView.percent = 1 - percent;

        [self.presentable panModalGestureRecognizer:self.handler.panGestureRecognizer dismissPercent:MIN(percent, 1)];

    } else {
        self.backgroundView.dimState = DimStateMax;
    }
}

#pragma mark - TFYPanModalPresentableHandlerDelegate

- (void)adjustPresentableYPos:(CGFloat)yPos {
    [self adjustToYPos:yPos];
}

- (void)presentableTransitionToState:(PresentationState)state {
    [self transitionToState:state animated:YES];
}

- (PresentationState)getCurrentPresentationState {
    return self.currentPresentationState;
}

- (void)dismiss:(BOOL)isInteractive mode:(PanModalInteractiveMode)mode {
    self.handler.panGestureRecognizer.enabled = NO;
    self.isDismissing = YES;

    [[self presentable] panModalWillDismiss];

    [TFYPanModalAnimator animate:^{
        self.panContainerView.pan_top = CGRectGetHeight(self.bounds);
        self.backgroundView.dimState = DimStateOff;
        self.dragIndicatorView.alpha = 0;
    } config:[self presentable] completion:^(BOOL completion) {
        [self removeFromSuperview];
        [[self presentable] panModalDidDismissed];
        self.animationBlock ? self.animationBlock() : nil;
        self.isDismissing = NO;
    }];

}

#pragma mark - TFYPanModalPresentableHandlerDataSource

- (CGSize)containerSize {
    return self.presentingView.bounds.size;
}

- (BOOL)isBeingDismissed {
    return self.isDismissing;
}

- (BOOL)isBeingPresented {
    return self.isPresenting;
}
 
- (BOOL)isFormPositionAnimating {
    return self.isPresentedViewAnimating;
}

- (BOOL)isPresentedViewAnchored {
    
    if (![[self presentable] shouldRespondToPanModalGestureRecognizer:self.handler.panGestureRecognizer]) {
        return YES;
    }
    
    if (!self.isPresentedViewAnimating && self.handler.extendsPanScrolling && (CGRectGetMinY(self.panContainerView.frame) <= self.handler.anchoredYPosition || TFY_TWO_FLOAT_IS_EQUAL(CGRectGetMinY(self.panContainerView.frame), self.handler.anchoredYPosition))) {
        return YES;
    }
    return NO;
}

#pragma mark - event handle

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!self.userInteractionEnabled || self.hidden || self.alpha < 0.01) {
        return nil;
    }

    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    BOOL eventThrough = [[self presentable] allowsTouchEventsPassingThroughTransitionView];
    if (eventThrough) {
        CGPoint convertedPoint = [self.panContainerView convertPoint:point fromView:self];
        if (CGRectGetWidth(self.panContainerView.frame) >= convertedPoint.x &&
            convertedPoint.x > 0 &&
            CGRectGetHeight(self.panContainerView.frame) >= convertedPoint.y &&
            convertedPoint.y > 0) {
            return [super hitTest:point withEvent:event];
        } else {
            return nil;
        }
    } else {
        return [super hitTest:point withEvent:event];
    }
}

- (void)checkBackgroundViewEventPass {
    if ([[self presentable] allowsTouchEventsPassingThroughTransitionView]) {
        self.backgroundView.userInteractionEnabled = NO;
        self.backgroundView.tapBlock = nil;
    } else {
        self.backgroundView.userInteractionEnabled = YES;
        __weak typeof(self) wkSelf = self;
        self.backgroundView.tapBlock = ^(UITapGestureRecognizer *recognizer) {
            if ([[wkSelf presentable] allowsTapBackgroundToDismiss]) {
                [wkSelf dismiss:NO mode:PanModalInteractiveModeNone];
            }
        };
    }
}

- (void)checkPanGestureRecognizer {
    if ([[self presentable] allowsTouchEventsPassingThroughTransitionView]) {
        [self removeGestureRecognizer:self.handler.panGestureRecognizer];
        [self.panContainerView addGestureRecognizer:self.handler.panGestureRecognizer];
    } else {
        [self.panContainerView removeGestureRecognizer:self.handler.panGestureRecognizer];
        [self addGestureRecognizer:self.handler.panGestureRecognizer];
    }
}

#pragma mark - getter

- (id<TFYPanModalPresentable>)presentable {
    if ([self.contentView conformsToProtocol:@protocol(TFYPanModalPresentable)]) {
        return self.contentView;
    }
    return nil;
}

- (TFYDimmedView *)backgroundView {
    if (!_backgroundView) {
        if (self.presentable) {
            _backgroundView = [[TFYDimmedView alloc] initWithBackgroundConfig:[self.presentable backgroundConfig]];
        } else {
            _backgroundView = [[TFYDimmedView alloc] init];
        }
        
        if ([[self presentable] allowsTouchEventsPassingThroughTransitionView]) {
            _backgroundView.userInteractionEnabled = NO;
        } else {
            __weak typeof(self) wkSelf = self;
            _backgroundView.tapBlock = ^(UITapGestureRecognizer *recognizer) {
                if ([[wkSelf presentable] allowsTapBackgroundToDismiss]) {
                    [wkSelf dismiss:NO mode:PanModalInteractiveModeNone];
                }
            };
        }

    }

    return _backgroundView;
}

- (TFYPanContainerView *)panContainerView {
    if (!_panContainerView) {
        _panContainerView = [[TFYPanContainerView alloc] initWithPresentedView:self.contentView frame:self.bounds];
    }

    return _panContainerView;
}

- (UIView<TFYPanModalIndicatorProtocol> *)dragIndicatorView {

    if (!_dragIndicatorView) {
        if ([self presentable] &&
                [[self presentable] respondsToSelector:@selector(customIndicatorView)] &&
                [[self presentable] customIndicatorView] != nil) {
            _dragIndicatorView = [[self presentable] customIndicatorView];
            // set the indicator size first in case `setupSubviews` can Not get the right size.
            _dragIndicatorView.pan_size = [[[self presentable] customIndicatorView] indicatorSize];
        } else {
            _dragIndicatorView = [TFYPanIndicatorView new];
        }
    }

    return _dragIndicatorView;
}

- (void)dealloc {
    // 彻底释放资源，移除所有子视图和手势，防止悬挂指针
    @try {
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad && self.presentingView) {
            @try {
                [self.presentingView removeObserver:self forKeyPath:@"frame"];
            } @catch (__unused NSException *exception) {}
        }
        [self.backgroundView removeFromSuperview];
        self.backgroundView.tapBlock = nil;
    } @catch (__unused NSException *exception) {}
    @try {
        [self.panContainerView removeFromSuperview];
    } @catch (__unused NSException *exception) {}
    @try {
        [self.dragIndicatorView removeFromSuperview];
    } @catch (__unused NSException *exception) {}
    if (_bottomCustomContainerView) {
        [_bottomCustomContainerView removeFromSuperview];
        _bottomCustomContainerView = nil;
    }
    self.handler.delegate = nil;
    self.handler.dataSource = nil;
    self.handler = nil;
}

@end
