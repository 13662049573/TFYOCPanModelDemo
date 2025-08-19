//
//  TFYPanModalFrequentTapPrevention.m
//  TFYOCPanModelDemo
//
//  Created by admin on 2025/7/16.
//

#import "TFYPanModalFrequentTapPrevention.h"

@interface TFYPanModalFrequentTapPrevention ()

@property (nonatomic, strong) NSTimer *preventionTimer;
@property (nonatomic, assign) NSTimeInterval lastExecuteTime;
@property (nonatomic, assign) BOOL isPrevented;
@property (nonatomic, assign) NSTimeInterval remainingTime;

@end

@implementation TFYPanModalFrequentTapPrevention

#pragma mark - 初始化方法

- (instancetype)initWithPreventionInterval:(NSTimeInterval)interval {
    self = [super init];
    if (self) {
        _enabled = YES;
        _preventionInterval = interval;
        _shouldShowHint = NO;
        _hintText = @"请稍后再试";
        _isPrevented = NO;
        _remainingTime = 0.0;
        _lastExecuteTime = 0.0;
    }
    return self;
}

+ (instancetype)preventionWithInterval:(NSTimeInterval)interval {
    return [[self alloc] initWithPreventionInterval:interval];
}

#pragma mark - 公共方法

- (BOOL)canExecute {
    if (!self.enabled) {
        return YES;
    }
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeSinceLastExecute = currentTime - self.lastExecuteTime;
    
    return timeSinceLastExecute >= self.preventionInterval;
}

- (BOOL)executeIfAllowed:(void (^)(void))block {
    if (!self.enabled) {
        if (block) {
            block();
        }
        return YES;
    }
    
    if ([self canExecute]) {
        self.lastExecuteTime = [[NSDate date] timeIntervalSince1970];
        self.isPrevented = NO;
        self.remainingTime = 0.0;
        
        if (block) {
            block();
        }
        
        // 通知代理状态变更
        if ([self.delegate respondsToSelector:@selector(frequentTapPreventionStateChanged:remainingTime:)]) {
            [self.delegate frequentTapPreventionStateChanged:NO remainingTime:0.0];
        }
        
        return YES;
    } else {
        // 计算剩余时间
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval timeSinceLastExecute = currentTime - self.lastExecuteTime;
        self.remainingTime = self.preventionInterval - timeSinceLastExecute;
        
        // 显示提示
        if (self.shouldShowHint && self.hintText) {
            if ([self.delegate respondsToSelector:@selector(showFrequentTapPreventionHint:)]) {
                [self.delegate showFrequentTapPreventionHint:self.hintText];
            }
        }
        
        // 通知代理状态变更
        if ([self.delegate respondsToSelector:@selector(frequentTapPreventionStateChanged:remainingTime:)]) {
            [self.delegate frequentTapPreventionStateChanged:YES remainingTime:self.remainingTime];
        }
        
        return NO;
    }
}

- (void)triggerPrevention {
    if (!self.enabled) {
        return;
    }
    
    self.lastExecuteTime = [[NSDate date] timeIntervalSince1970];
    self.isPrevented = YES;
    self.remainingTime = self.preventionInterval;
    
    // 启动定时器更新剩余时间
    [self startPreventionTimer];
    
    // 通知代理状态变更
    if ([self.delegate respondsToSelector:@selector(frequentTapPreventionStateChanged:remainingTime:)]) {
        [self.delegate frequentTapPreventionStateChanged:YES remainingTime:self.remainingTime];
    }
}

- (void)reset {
    [self stopPreventionTimer];
    self.lastExecuteTime = 0.0;
    self.isPrevented = NO;
    self.remainingTime = 0.0;
    
    // 通知代理状态变更
    if ([self.delegate respondsToSelector:@selector(frequentTapPreventionStateChanged:remainingTime:)]) {
        [self.delegate frequentTapPreventionStateChanged:NO remainingTime:0.0];
    }
}

- (NSTimeInterval)getRemainingTime {
    if (!self.enabled || !self.isPrevented) {
        return 0.0;
    }
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeSinceLastExecute = currentTime - self.lastExecuteTime;
    NSTimeInterval remaining = self.preventionInterval - timeSinceLastExecute;
    
    return MAX(0.0, remaining);
}

#pragma mark - 私有方法

- (void)startPreventionTimer {
    [self stopPreventionTimer];
    
    self.preventionTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                           target:self
                                                         selector:@selector(updateRemainingTime)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)stopPreventionTimer {
    if (self.preventionTimer) {
        [self.preventionTimer invalidate];
        self.preventionTimer = nil;
    }
}

- (void)updateRemainingTime {
    NSTimeInterval remaining = [self getRemainingTime];
    
    if (remaining <= 0.0) {
        // 防频繁点击时间结束
        [self stopPreventionTimer];
        self.isPrevented = NO;
        self.remainingTime = 0.0;
        
        // 隐藏提示
        if ([self.delegate respondsToSelector:@selector(hideFrequentTapPreventionHint)]) {
            [self.delegate hideFrequentTapPreventionHint];
        }
        
        // 通知代理状态变更
        if ([self.delegate respondsToSelector:@selector(frequentTapPreventionStateChanged:remainingTime:)]) {
            [self.delegate frequentTapPreventionStateChanged:NO remainingTime:0.0];
        }
    } else {
        // 更新剩余时间
        self.remainingTime = remaining;
        
        // 通知代理状态变更
        if ([self.delegate respondsToSelector:@selector(frequentTapPreventionStateChanged:remainingTime:)]) {
            [self.delegate frequentTapPreventionStateChanged:YES remainingTime:remaining];
        }
    }
}

#pragma mark - 内存管理

- (void)dealloc {
    [self stopPreventionTimer];
}

@end
