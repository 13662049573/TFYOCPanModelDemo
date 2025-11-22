//

#ifndef TFYPOPUPCONTAINERTYPE_H
#define TFYPOPUPCONTAINERTYPE_H

//  TFYPopupContainerType.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗容器类型定义和协议
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TFYPopupView;

/// 容器类型枚举
typedef NS_ENUM(NSUInteger, TFYPopupContainerType) {
    TFYPopupContainerTypeWindow = 0,        // UIWindow容器（默认）
    TFYPopupContainerTypeView,              // UIView容器
    TFYPopupContainerTypeViewController,    // UIViewController容器
    TFYPopupContainerTypeCustom             // 自定义容器
} NS_SWIFT_NAME(PopupContainerType);

/// 容器选择策略
typedef NS_ENUM(NSUInteger, TFYPopupContainerSelectionStrategy) {
    TFYPopupContainerSelectionStrategyAuto = 0,     // 自动选择（默认）
    TFYPopupContainerSelectionStrategyManual,       // 手动指定
    TFYPopupContainerSelectionStrategySmart,        // 智能选择
    TFYPopupContainerSelectionStrategyCustom        // 自定义选择
} NS_SWIFT_NAME(PopupContainerSelectionStrategy);

/// 容器信息类
NS_SWIFT_NAME(PopupContainerInfo)
@interface TFYPopupContainerInfo : NSObject

/// 容器类型
@property (nonatomic, assign, readonly) TFYPopupContainerType type;

/// 容器视图
@property (nonatomic, weak, readonly) UIView *containerView;

/// 容器名称（用于调试和日志）
@property (nonatomic, copy, readonly) NSString *name;

/// 容器描述
@property (nonatomic, copy, readonly) NSString *containerDescription;

/// 是否可用
@property (nonatomic, assign, readonly) BOOL isAvailable;

/// 优先级（用于智能选择）
@property (nonatomic, assign, readonly) NSInteger priority;

/// 初始化方法
- (instancetype)initWithType:(TFYPopupContainerType)type
                containerView:(UIView *)containerView
                         name:(NSString *)name
            containerDescription:(NSString *)containerDescription
                   isAvailable:(BOOL)isAvailable
                      priority:(NSInteger)priority NS_SWIFT_NAME(init(type:containerView:name:containerDescription:isAvailable:priority:));

/// 便利初始化方法
+ (instancetype)windowContainer:(UIWindow *)window NS_SWIFT_NAME(windowContainer(_:));
+ (instancetype)viewContainer:(UIView *)view name:(NSString *)name NS_SWIFT_NAME(viewContainer(_:name:));
+ (instancetype)viewControllerContainer:(UIViewController *)viewController NS_SWIFT_NAME(viewControllerContainer(_:));

@end

/// 容器选择回调
typedef void (^TFYPopupContainerSelectionCallback)(TFYPopupContainerInfo * _Nullable selectedContainer, NSError * _Nullable error) NS_SWIFT_NAME(PopupContainerSelectionCallback);

/// 容器选择器协议
NS_SWIFT_NAME(PopupContainerSelector)
@protocol TFYPopupContainerSelector <NSObject>

@required

/// 选择容器
/// @param availableContainers 可用容器列表
/// @param completion 选择完成回调
- (void)selectContainerFromAvailableContainers:(NSArray<TFYPopupContainerInfo *> *)availableContainers
                                    completion:(TFYPopupContainerSelectionCallback)completion NS_SWIFT_NAME(selectContainer(from:completion:));

@optional

/// 是否支持该容器类型
/// @param type 容器类型
/// @return 是否支持
- (BOOL)supportsContainerType:(TFYPopupContainerType)type NS_SWIFT_NAME(supportsContainerType(_:));

/// 获取容器优先级
/// @param containerInfo 容器信息
/// @return 优先级（数值越大优先级越高）
- (NSInteger)priorityForContainer:(TFYPopupContainerInfo *)containerInfo NS_SWIFT_NAME(priorityForContainer(_:));

@end

/// 默认容器选择器
NS_SWIFT_NAME(DefaultPopupContainerSelector)
@interface TFYPopupDefaultContainerSelector : NSObject <TFYPopupContainerSelector>

/// 选择策略
@property (nonatomic, assign) TFYPopupContainerSelectionStrategy strategy;

/// 是否优先选择UIWindow
@property (nonatomic, assign) BOOL preferWindowContainer;

/// 是否优先选择当前视图控制器
@property (nonatomic, assign) BOOL preferCurrentViewController;

/// 自定义优先级计算block
@property (nonatomic, copy, nullable) NSInteger (^customPriorityCalculator)(TFYPopupContainerInfo *containerInfo);

/// 初始化方法
- (instancetype)initWithStrategy:(TFYPopupContainerSelectionStrategy)strategy NS_SWIFT_NAME(init(strategy:));

@end

NS_ASSUME_NONNULL_END

#endif /* TFYPOPUPCONTAINERTYPE_H */
