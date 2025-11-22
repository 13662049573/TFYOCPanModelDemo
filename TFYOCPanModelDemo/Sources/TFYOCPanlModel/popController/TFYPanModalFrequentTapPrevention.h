//

#ifndef TFYPANMODALFREQUENTTAPPREVENTION_H
#define TFYPANMODALFREQUENTTAPPREVENTION_H

//  TFYPanModalFrequentTapPrevention.h
//  TFYOCPanModelDemo
//
//  Created by admin on 2025/7/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * TFYPanModalFrequentTapPreventionDelegate
 * 防频繁点击管理器的代理协议
 */
@protocol TFYPanModalFrequentTapPreventionDelegate <NSObject>

/**
 * 防频繁点击状态变更回调
 * @param isPrevented 是否被阻止
 * @param remainingTime 剩余等待时间
 */
- (void)frequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime;

@optional

/**
 * 显示防频繁点击提示
 * @param hintText 提示文本
 */
- (void)showFrequentTapPreventionHint:(NSString *)hintText;

/**
 * 隐藏防频繁点击提示
 */
- (void)hideFrequentTapPreventionHint;

@end

/**
 * TFYPanModalFrequentTapPrevention
 * 防频繁点击管理器，用于防止用户频繁点击触发多次弹窗
 */
@interface TFYPanModalFrequentTapPrevention : NSObject

/**
 * 代理对象
 */
@property (nonatomic, weak, nullable) id<TFYPanModalFrequentTapPreventionDelegate> delegate;

/**
 * 是否启用防频繁点击功能
 */
@property (nonatomic, assign) BOOL enabled;

/**
 * 防频繁点击的时间间隔（秒）
 */
@property (nonatomic, assign) NSTimeInterval preventionInterval;

/**
 * 是否允许显示提示
 */
@property (nonatomic, assign) BOOL shouldShowHint;

/**
 * 提示文本
 */
@property (nonatomic, copy, nullable) NSString *hintText;

/**
 * 当前是否被阻止
 */
@property (nonatomic, assign, readonly) BOOL isPrevented;

/**
 * 剩余等待时间
 */
@property (nonatomic, assign, readonly) NSTimeInterval remainingTime;

/**
 * 初始化方法
 * @param interval 防频繁点击时间间隔
 */
- (instancetype)initWithPreventionInterval:(NSTimeInterval)interval;

/**
 * 工厂方法
 * @param interval 防频繁点击时间间隔
 */
+ (instancetype)preventionWithInterval:(NSTimeInterval)interval;

/**
 * 检查是否可以执行操作
 * @return 是否可以执行
 */
- (BOOL)canExecute;

/**
 * 执行操作（如果允许）
 * @param block 要执行的操作块
 * @return 是否执行了操作
 */
- (BOOL)executeIfAllowed:(void (^)(void))block;

/**
 * 手动触发防频繁点击
 */
- (void)triggerPrevention;

/**
 * 重置防频繁点击状态
 */
- (void)reset;

/**
 * 获取剩余等待时间
 * @return 剩余时间（秒）
 */
- (NSTimeInterval)getRemainingTime;

@end

NS_ASSUME_NONNULL_END

#endif /* TFYPANMODALFREQUENTTAPPREVENTION_H */
