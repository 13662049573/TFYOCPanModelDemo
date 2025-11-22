//
//  UIColor+TFY.m
//  TFYPanModalDemo
//
//  Created by heath wang on 2020/1/15.
//  Copyright © 2020 wangcongling. All rights reserved.
//

#import "UIColor+TFY.h"

@implementation UIColor (TFY)

+ (instancetype)tfy_randomColor {
    UIColor *color = [UIColor colorWithRed:(arc4random() % 255 + 1) / 255.0f green:(arc4random() % 255 + 1) / 255.0f blue:(arc4random() % 255 + 1) / 255.0f alpha:1];
    return color;
}

@end
