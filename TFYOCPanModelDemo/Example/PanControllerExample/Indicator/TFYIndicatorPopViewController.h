//
//  TFYIndicatorPopViewController.h
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/8/10.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TFYIndicatorStyle) {
    TFYIndicatorStyleChangeColor,
    TFYIndicatorStyleText,
    TFYIndicatorStyleImmobile,
};

NS_ASSUME_NONNULL_BEGIN

@interface TFYIndicatorPopViewController : UIViewController

@property (nonatomic, assign) TFYIndicatorStyle indicatorStyle;

- (instancetype)initWithIndicatorStyle:(TFYIndicatorStyle)indicatorStyle;

+ (instancetype)controllerWithIndicatorStyle:(TFYIndicatorStyle)indicatorStyle;


@end

NS_ASSUME_NONNULL_END
