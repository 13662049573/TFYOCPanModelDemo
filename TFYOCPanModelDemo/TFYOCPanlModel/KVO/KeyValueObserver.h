//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  KeyValueObserver.h
//  Lab Color Space Explorer
//
//  Created by Daniel Eggert on 01/12/2013.
//  Copyright (c) 2013 objc.io. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * @class KeyValueObserver
 * @brief KVO辅助工具类，简化KVO监听与回调，自动管理生命周期
 * @discussion 通过该类可便捷实现KVO监听，自动移除，避免内存泄漏和crash
 */
@interface KeyValueObserver : NSObject

/**
 * @brief KVO回调目标对象（弱引用）
 */
@property (nonatomic, weak, nullable) id target;
/**
 * @brief KVO回调方法
 */
@property (nonatomic) SEL _Nullable selector;

/**
 * @brief 创建KVO监听对象，自动管理移除
 * @param object 被监听对象
 * @param keyPath 监听的属性路径
 * @param target 回调目标
 * @param selector 回调方法，参数为NSDictionary *change
 * @return KVO监听token，需要持有
 */
+ (NSObject * _Nonnull)observeObject:(nonnull id)object keyPath:(nonnull NSString*)keyPath target:(nullable id)target selector:(nonnull SEL)selector __attribute__((warn_unused_result));

/**
 * @brief 创建KVO监听对象（可指定KVO选项）
 * @param object 被监听对象
 * @param keyPath 监听的属性路径
 * @param target 回调目标
 * @param selector 回调方法，参数为NSDictionary *change
 * @param options KVO选项
 * @return KVO监听token，需要持有
 */
+ (NSObject * _Nonnull)observeObject:(nonnull id)object keyPath:(nonnull NSString*)keyPath target:(nullable id)target selector:(nonnull SEL)selector options:(NSKeyValueObservingOptions)options __attribute__((warn_unused_result));

/**
 * @brief 取消KVO监听（调用后需重新监听才生效）
 */
- (void)unObserver;

@end
