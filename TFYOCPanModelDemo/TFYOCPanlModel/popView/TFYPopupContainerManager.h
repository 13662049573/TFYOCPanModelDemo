//
//  TFYPopupContainerManager.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗容器管理器，负责发现和管理各种容器
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <TFYOCPanlModel/TFYPopupContainerType.h>

NS_ASSUME_NONNULL_BEGIN

@class TFYPopupView;

/// 容器发现回调
typedef void (^TFYPopupContainerDiscoveryCallback)(NSArray<TFYPopupContainerInfo *> *containers, NSError * _Nullable error) NS_SWIFT_NAME(PopupContainerDiscoveryCallback);

/// 容器变化通知
FOUNDATION_EXPORT NSNotificationName const _Nonnull TFYPopupContainerDidChangeNotification NS_SWIFT_NAME(Popup.containerDidChangeNotification);
FOUNDATION_EXPORT NSNotificationName const _Nonnull TFYPopupContainerDidBecomeAvailableNotification NS_SWIFT_NAME(Popup.containerDidBecomeAvailableNotification);
FOUNDATION_EXPORT NSNotificationName const _Nonnull TFYPopupContainerDidBecomeUnavailableNotification NS_SWIFT_NAME(Popup.containerDidBecomeUnavailableNotification);

/// 弹窗容器管理器
NS_SWIFT_NAME(PopupContainerManager)
@interface TFYPopupContainerManager : NSObject

#pragma mark - Singleton

/// 单例管理器
+ (instancetype)sharedManager NS_SWIFT_NAME(shared());

#pragma mark - Container Discovery

/// 发现所有可用容器
/// @param completion 发现完成回调
- (void)discoverAvailableContainersWithCompletion:(TFYPopupContainerDiscoveryCallback)completion NS_SWIFT_NAME(discoverAvailableContainers(completion:));

/// 发现指定类型的容器
/// @param type 容器类型
/// @param completion 发现完成回调
- (void)discoverContainersOfType:(TFYPopupContainerType)type
                      completion:(TFYPopupContainerDiscoveryCallback)completion NS_SWIFT_NAME(discoverContainers(ofType:completion:));

/// 获取当前可用的容器列表（同步）
- (NSArray<TFYPopupContainerInfo *> *)currentAvailableContainers NS_SWIFT_NAME(currentAvailableContainers());

/// 获取指定类型的当前可用容器（同步）
/// @param type 容器类型
- (NSArray<TFYPopupContainerInfo *> *)currentAvailableContainersOfType:(TFYPopupContainerType)type NS_SWIFT_NAME(currentAvailableContainers(ofType:));

#pragma mark - Container Management

/// 注册自定义容器
/// @param containerInfo 容器信息
- (void)registerCustomContainer:(TFYPopupContainerInfo *)containerInfo NS_SWIFT_NAME(registerCustomContainer(_:));

/// 注销自定义容器
/// @param containerInfo 容器信息
- (void)unregisterCustomContainer:(TFYPopupContainerInfo *)containerInfo NS_SWIFT_NAME(unregisterCustomContainer(_:));

/// 检查容器是否可用
/// @param containerInfo 容器信息
/// @return 是否可用
- (BOOL)isContainerAvailable:(TFYPopupContainerInfo *)containerInfo NS_SWIFT_NAME(isContainerAvailable(_:));

/// 刷新容器状态
- (void)refreshContainerStates NS_SWIFT_NAME(refreshContainerStates());

#pragma mark - Container Selection

/// 设置默认容器选择器
/// @param selector 选择器
- (void)setDefaultContainerSelector:(id<TFYPopupContainerSelector>)selector NS_SWIFT_NAME(setDefaultContainerSelector(_:));

/// 获取默认容器选择器
- (id<TFYPopupContainerSelector>)defaultContainerSelector NS_SWIFT_NAME(defaultContainerSelector());

/// 选择最佳容器
/// @param completion 选择完成回调
- (void)selectBestContainerWithCompletion:(TFYPopupContainerSelectionCallback)completion NS_SWIFT_NAME(selectBestContainer(completion:));

/// 选择最佳容器（使用指定选择器）
/// @param selector 选择器
/// @param completion 选择完成回调
- (void)selectBestContainerWithSelector:(id<TFYPopupContainerSelector>)selector
                             completion:(TFYPopupContainerSelectionCallback)completion NS_SWIFT_NAME(selectBestContainer(selector:completion:));

#pragma mark - Configuration

/// 是否启用自动容器发现
@property (nonatomic, assign) BOOL enableAutoDiscovery;

/// 容器发现间隔（秒），默认5秒
@property (nonatomic, assign) NSTimeInterval discoveryInterval;

/// 是否启用容器变化通知
@property (nonatomic, assign) BOOL enableContainerChangeNotifications;

/// 是否启用调试模式
@property (nonatomic, assign) BOOL enableDebugMode;

#pragma mark - Utility Methods

/// 获取容器类型描述
/// @param type 容器类型
/// @return 类型描述
+ (NSString *)descriptionForContainerType:(TFYPopupContainerType)type NS_SWIFT_NAME(description(forContainerType:));

/// 获取容器选择策略描述
/// @param strategy 选择策略
/// @return 策略描述
+ (NSString *)descriptionForSelectionStrategy:(TFYPopupContainerSelectionStrategy)strategy NS_SWIFT_NAME(description(forSelectionStrategy:));

/// 打印当前容器状态
- (void)logCurrentContainerStates NS_SWIFT_NAME(logCurrentContainerStates());

@end

#pragma mark - Convenience Methods

/// 快速获取当前窗口容器
FOUNDATION_EXPORT TFYPopupContainerInfo * _Nullable TFYPopupGetCurrentWindowContainer(void) NS_SWIFT_NAME(Popup.getCurrentWindowContainer());

/// 快速获取当前视图控制器容器
FOUNDATION_EXPORT TFYPopupContainerInfo * _Nullable TFYPopupGetCurrentViewControllerContainer(void) NS_SWIFT_NAME(Popup.getCurrentViewControllerContainer());

/// 快速获取指定视图的容器
FOUNDATION_EXPORT TFYPopupContainerInfo * _Nullable TFYPopupGetContainerForView(UIView *view) NS_SWIFT_NAME(Popup.getContainer(forView:));

/// 快速获取指定视图控制器的容器
FOUNDATION_EXPORT TFYPopupContainerInfo * _Nullable TFYPopupGetContainerForViewController(UIViewController *viewController) NS_SWIFT_NAME(Popup.getContainer(forViewController:));

NS_ASSUME_NONNULL_END
