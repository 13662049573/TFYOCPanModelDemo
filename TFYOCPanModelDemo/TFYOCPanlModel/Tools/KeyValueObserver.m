//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  KeyValueObserver.m
//  Lab Color Space Explorer
//
//  Created by Daniel Eggert on 01/12/2013.
//  Copyright (c) 2013 objc.io. All rights reserved.
//

#import <TFYOCPanlModel/KeyValueObserver.h>

//
// Created by chris on 7/24/13.
//

#import <TFYOCPanlModel/KeyValueObserver.h>

@interface KeyValueObserver ()
@property (nonatomic, weak) id observedObject;
@property (nonatomic, copy) NSString* keyPath;
@property (nonatomic, assign) BOOL shouldObserver;
@end

/**
 * @brief KVO辅助工具类实现，简化KVO监听与回调，自动管理生命周期。
 * @discussion 通过该类可便捷实现KVO监听，自动移除，避免内存泄漏和crash。
 */

@implementation KeyValueObserver

/**
 * @brief 初始化并注册KVO监听
 * @param object 被监听对象
 * @param keyPath 监听的属性路径
 * @param target 回调目标
 * @param selector 回调方法
 * @param options KVO选项
 * @return KVO监听对象
 */
- (id)initWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    if (object == nil) {
        return nil;
    }
    NSParameterAssert(target != nil);
    NSParameterAssert([target respondsToSelector:selector]);
    self = [super init];
    if (self) {
        _shouldObserver = YES;
        self.target = target;
        self.selector = selector;
        self.observedObject = object;
        self.keyPath = keyPath;
        // 注册KVO监听
        [object addObserver:self forKeyPath:keyPath options:options context:(__bridge void *)(self)];
    }
    return self;
}

/**
 * @brief 便捷创建KVO监听（默认options=0）
 */
+ (NSObject *)observeObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector {
    return [self observeObject:object keyPath:keyPath target:target selector:selector options:0];
}

/**
 * @brief 便捷创建KVO监听（可指定options）
 */
+ (NSObject *)observeObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    return [[self alloc] initWithObject:object keyPath:keyPath target:target selector:selector options:options];
}

/**
 * @brief KVO回调，分发到didChange:方法
 */
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if (context == (__bridge void *)(self)) {
        [self didChange:change];
    }
}

/**
 * @brief KVO属性变更回调，调用目标的selector
 * @param change KVO变更字典
 */
- (void)didChange:(NSDictionary *)change {
    if (!self.shouldObserver) {
        return;
    }
    id strongTarget = self.target;
    if ([strongTarget respondsToSelector:self.selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [strongTarget performSelector:self.selector withObject:change];
        #pragma clang diagnostic pop
    }
}

/**
 * @brief 析构时自动移除KVO监听，增加try-catch保护，避免提前释放导致crash
 */
- (void)dealloc {
    @try {
        [self.observedObject removeObserver:self forKeyPath:self.keyPath];
    } @catch (NSException *exception) {
        NSLog(@"Error removing observer: %@", exception);
    }
}

/**
 * @brief 取消KVO监听（调用后需重新监听才生效）
 */
- (void)unObserver {
    self.shouldObserver = NO;
}

@end
