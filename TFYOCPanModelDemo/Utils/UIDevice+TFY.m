//
//  UIDevice+TFY.m
//  TFYPanModalDemo
//
//  Created by heath wang on 2019/12/16.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "UIDevice+TFY.h"


@implementation UIDevice (TFY)

+ (BOOL)isPhoneX {
    if ([UIScreen mainScreen].bounds.size.height >= 812) {
        return YES;
    }
    return NO;
}

+ (CGFloat)statusBarHeight {
    return  [UIDevice safeAreaInsetsTopHeight] > 0 ? [UIDevice safeAreaInsetsTopHeight] : 20;
}

+ (CGFloat)statusBarAndNaviBarHeight {
    return 44.f + [UIDevice statusBarHeight];
}

+ (CGFloat)tabBarHeight {
    return 49 + [UIDevice safeAreaInsetsBottomHeight];
}

+ (UIWindow *)tfy_activeKeyWindow {
    UIWindow *keyWindow = nil;
    if (@available(iOS 15.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
                if (keyWindow) break;
            }
        }
    }
    return keyWindow;
}

+ (CGFloat)safeAreaInsetsBottomHeight {
    CGFloat gap = 0.f;
    if (@available(iOS 11, *)) {
        UIWindow *keyWindow = [self tfy_activeKeyWindow];
        if (keyWindow.safeAreaLayoutGuide.layoutFrame.size.height > 0) {
            gap = (keyWindow.frame.size.height - keyWindow.safeAreaLayoutGuide.layoutFrame.origin.y - keyWindow.safeAreaLayoutGuide.layoutFrame.size.height);
        } else {
            gap = 0;
        }
    } else {
        gap = 0;
    }
    return gap;
}

+ (CGFloat)safeAreaInsetsTopHeight {
    CGFloat gap = 0.f;
    if (@available(iOS 11, *)) {
        UIWindow *keyWindow = [self tfy_activeKeyWindow];
        gap = keyWindow.safeAreaLayoutGuide.layoutFrame.origin.y;
    } else {
        gap = 0;
    }
    return gap;
}

@end
