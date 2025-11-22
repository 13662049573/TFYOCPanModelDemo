//
//  TFYPopupBottomSheetAnimator.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：底部弹出框动画器，支持手势交互
//

#import <UIKit/UIKit.h>
#import <TFYOCPanlModel/TFYPopupViewAnimator.h>

NS_ASSUME_NONNULL_BEGIN

@class TFYPopupView, TFYPopupBackgroundView;

/// 底部弹出框配置
NS_SWIFT_NAME(PopupBottomSheetConfiguration)
@interface TFYPopupBottomSheetConfiguration : NSObject <NSCopying>

/// 默认高度，默认 300
@property (nonatomic, assign) CGFloat defaultHeight;

/// 最小高度，默认 100
@property (nonatomic, assign) CGFloat minimumHeight;

/// 最大高度，默认屏幕高度
@property (nonatomic, assign) CGFloat maximumHeight;

/// 是否允许全屏展开，默认 YES
@property (nonatomic, assign) BOOL allowsFullScreen;

/// 回弹到默认高度的阈值，默认 80
@property (nonatomic, assign) CGFloat snapToDefaultThreshold;

/// 弹簧阻尼系数，默认 0.8
@property (nonatomic, assign) CGFloat springDamping;

/// 弹簧初始速度，默认 0.4
@property (nonatomic, assign) CGFloat springVelocity;

/// 动画持续时间，默认 0.35
@property (nonatomic, assign) NSTimeInterval animationDuration;

/// 上部左右原价默认10
@property (nonatomic, assign) CGFloat cornerRadius;

/// 是否启用手势，默认 NO
@property (nonatomic, assign) BOOL enableGestures;

/// 默认初始化
- (instancetype)init;

@end

/// 底部弹出框动画器
NS_SWIFT_NAME(PopupBottomSheetAnimator)
@interface TFYPopupBottomSheetAnimator : NSObject <TFYPopupViewAnimator, UIGestureRecognizerDelegate>

/// 配置对象
@property (nonatomic, strong, readonly) TFYPopupBottomSheetConfiguration *configuration;

/// 检查手势是否已启用
@property (nonatomic, assign, readonly) BOOL isGesturesEnabled;

/// 指定初始化方法
- (instancetype)initWithConfiguration:(TFYPopupBottomSheetConfiguration *)configuration NS_SWIFT_NAME(init(configuration:));

/// 便利初始化方法（使用默认配置）
- (instancetype)init;

/// 启用手势功能
- (void)enableGestures NS_SWIFT_NAME(enableGestures());

/// 禁用手势功能
- (void)disableGestures NS_SWIFT_NAME(disableGestures());

@end

NS_ASSUME_NONNULL_END
