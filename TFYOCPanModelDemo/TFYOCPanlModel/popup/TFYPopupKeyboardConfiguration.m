//
//  TFYPopupKeyboardConfiguration.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗键盘配置类实现
//

#import "TFYPopupKeyboardConfiguration.h"

@implementation TFYPopupKeyboardConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _isEnabled = NO;
        _avoidingMode = TFYKeyboardAvoidingModeTransform;
        _additionalOffset = 10.0;
        _animationDuration = 0.25;
        _respectSafeArea = YES;
    }
    return self;
}

- (BOOL)validate {
    return self.additionalOffset >= 0 && self.animationDuration >= 0;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TFYPopupKeyboardConfiguration *copy = [[TFYPopupKeyboardConfiguration alloc] init];
    copy.isEnabled = self.isEnabled;
    copy.avoidingMode = self.avoidingMode;
    copy.additionalOffset = self.additionalOffset;
    copy.animationDuration = self.animationDuration;
    copy.respectSafeArea = self.respectSafeArea;
    return copy;
}

@end
