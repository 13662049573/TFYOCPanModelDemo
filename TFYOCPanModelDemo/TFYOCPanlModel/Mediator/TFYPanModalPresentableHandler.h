//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalPresentableHandler.h
//  TFYPanModal
//
//  Created by heath wang on 2019/10/15.
//  Copyright © 2019 TFY Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFYPanModalPresentable.h"
#import "TFYPanModalPanGestureDelegate.h"
#import "TFYPanModalPresentationDelegate.h"

/**
 * TFYPanModalPresentableHandlerMode
 * Handler的工作模式，区分用于UIViewController还是View
 */
typedef NS_ENUM(NSUInteger, TFYPanModalPresentableHandlerMode) {
    TFYPanModalPresentableHandlerModeViewController, ///< 用于UIViewController
    TFYPanModalPresentableHandlerModeView,           ///< 用于普通View
};

NS_ASSUME_NONNULL_BEGIN

/**
 * TFYPanModalPresentableHandlerDelegate
 * Handler的事件代理，负责处理弹窗位置、状态变更、交互等回调
 */
@protocol TFYPanModalPresentableHandlerDelegate <NSObject>

/**
 * 通知代理：弹窗Y坐标即将变更
 * @param yPos 新的Y坐标
 */
- (void)adjustPresentableYPos:(CGFloat)yPos;

/**
 * 通知代理：弹窗状态即将变更（short/medium/long）
 * @param state 新的状态
 */
- (void)presentableTransitionToState:(PresentationState)state;

/**
 * 获取当前弹窗的状态
 * @return 当前状态
 */
- (PresentationState)getCurrentPresentationState;

/**
 * 通知代理：弹窗即将被关闭
 * @param isInteractive 是否为交互式关闭
 * @param mode 关闭模式
 */
- (void)dismiss:(BOOL)isInteractive mode:(PanModalInteractiveMode)mode;

@optional
/**
 * 取消交互式转场
 */
- (void)cancelInteractiveTransition;
/**
 * 完成交互式转场
 */
- (void)finishInteractiveTransition;

@end

/**
 * TFYPanModalPresentableHandlerDataSource
 * Handler的数据源协议，提供弹窗尺寸、状态等信息
 */
@protocol TFYPanModalPresentableHandlerDataSource <NSObject>

/**
 * 获取容器尺寸
 */
- (CGSize)containerSize;
/**
 * 是否正在被关闭
 */
- (BOOL)isBeingDismissed;
/**
 * 是否正在被展示
 */
- (BOOL)isBeingPresented;
/**
 * 弹窗位置是否正在动画中
 */
- (BOOL)isFormPositionAnimating;

@optional
/**
 * 弹窗是否锚定在某个位置
 */
- (BOOL)isPresentedViewAnchored;
/**
 * 控制器是否为交互式弹窗
 */
- (BOOL)isPresentedControllerInteractive;

@end

/**
 * TFYPanModalPresentableHandler
 * 弹窗核心手势与状态管理类，负责手势处理、状态切换、滚动联动等
 */
@interface TFYPanModalPresentableHandler : NSObject <UIGestureRecognizerDelegate>

/**
 * shortForm状态下的Y坐标
 */
@property (nonatomic, assign, readonly) CGFloat shortFormYPosition;
/**
 * mediumForm状态下的Y坐标
 */
@property (nonatomic, assign, readonly) CGFloat mediumFormYPosition;
/**
 * longForm状态下的Y坐标
 */
@property (nonatomic, assign, readonly) CGFloat longFormYPosition;
/**
 * 是否允许扩展滚动
 */
@property (nonatomic, assign, readonly) BOOL extendsPanScrolling;
/**
 * 是否锚定到longForm
 */
@property (nonatomic, assign, readonly) BOOL anchorModalToLongForm;
/**
 * 锚定Y坐标
 */
@property (nonatomic, assign, readonly) CGFloat anchoredYPosition;

/**
 * 主手势识别器
 */
@property (nonatomic, strong, readonly, nonnull) UIPanGestureRecognizer *panGestureRecognizer;
/**
 * 屏幕边缘手势识别器
 */
@property (nonatomic, strong, readonly, nonnull) UIPanGestureRecognizer *screenEdgeGestureRecognizer;

/**
 * Handler工作模式
 */
@property (nonatomic, assign) TFYPanModalPresentableHandlerMode mode;
/**
 * 拖拽指示器视图
 */
@property (nonatomic, weak, nullable) UIView<TFYPanModalIndicatorProtocol> *dragIndicatorView;
/**
 * 被展示的视图
 */
@property (nonatomic, weak, nullable) UIView *presentedView;

/**
 * 当前 presentable 对象，需同时遵循 TFYPanModalPresentable 和 TFYPanModalPanGestureDelegate 协议
 */
@property (nonatomic, weak, readonly) id<TFYPanModalPresentable, TFYPanModalPanGestureDelegate> presentable;

/**
 * 事件代理
 */
@property(nonatomic, weak, nullable) id <TFYPanModalPresentableHandlerDelegate> delegate;
/**
 * 数据源
 */
@property(nonatomic, weak, nullable) id <TFYPanModalPresentableHandlerDataSource> dataSource;

/**
 * 初始化方法
 * @param presentable 遵循TFYPanModalPresentable协议的对象
 */
- (instancetype)initWithPresentable:(nonnull id <TFYPanModalPresentable>)presentable;
/**
 * 工厂方法
 */
+ (instancetype)handlerWithPresentable:(nonnull id <TFYPanModalPresentable>)presentable;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 * 监听可滚动视图
 */
- (void)observeScrollable;

/**
 * 配置滚动视图inset
 */
- (void)configureScrollViewInsets;

/**
 * 设置滚动视图contentOffset
 */
- (void)setScrollableContentOffset:(CGPoint)offset animated:(BOOL)animated;

/**
 * 配置视图布局
 */
- (void)configureViewLayout;

@end

NS_ASSUME_NONNULL_END
