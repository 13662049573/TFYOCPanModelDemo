//
//  TFYPopupKeyboardConfiguration.h
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗键盘配置类，处理键盘避让和适配
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 键盘避让模式
typedef NS_ENUM(NSUInteger, TFYKeyboardAvoidingMode) {
    TFYKeyboardAvoidingModeTransform = 0,   // 使用变换来避开键盘
    TFYKeyboardAvoidingModeConstraint,      // 使用约束来避开键盘
    TFYKeyboardAvoidingModeResize          // 调整大小来避开键盘
} NS_SWIFT_NAME(PopupKeyboardAvoidingMode);

/// 键盘配置类
NS_SWIFT_NAME(PopupKeyboardConfiguration)
@interface TFYPopupKeyboardConfiguration : NSObject <NSCopying>

/// 是否启用键盘适配，默认 NO
@property (nonatomic, assign) BOOL isEnabled;

/// 键盘避让模式，默认 TFYKeyboardAvoidingModeTransform
@property (nonatomic, assign) TFYKeyboardAvoidingMode avoidingMode;

/// 额外的偏移量，默认 0.0
@property (nonatomic, assign) CGFloat additionalOffset;

/// 动画持续时间，默认 0.25
@property (nonatomic, assign) NSTimeInterval animationDuration;

/// 是否尊重安全区域，默认 YES
@property (nonatomic, assign) BOOL respectSafeArea;

/// 默认初始化
- (instancetype)init;

/// 验证配置是否有效
- (BOOL)validate NS_SWIFT_NAME(validate());

@end

NS_ASSUME_NONNULL_END
