//
//  TFYIndicatorPopViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/8/10.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYIndicatorPopViewController.h"
#import "TFYTextIndicatorView.h"
#import "TFYImmobileIndicatorView.h"

@interface TFYIndicatorPopViewController () <TFYPanModalPresentable>

@end

@implementation TFYIndicatorPopViewController

- (instancetype)initWithIndicatorStyle:(TFYIndicatorStyle)indicatorStyle {
    self = [super init];
    if (self) {
        _indicatorStyle = indicatorStyle;
    }

    return self;
}

+ (instancetype)controllerWithIndicatorStyle:(TFYIndicatorStyle)indicatorStyle {
    return [[self alloc] initWithIndicatorStyle:indicatorStyle];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.800 alpha:1.00];
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 44);
}

- (PanModalHeight)shortFormHeight {
    return [self longFormHeight];
}

- (nullable UIView <TFYPanModalIndicatorProtocol> *)customIndicatorView {
    switch (self.indicatorStyle) {
        case TFYIndicatorStyleChangeColor: {
            TFYPanIndicatorView *indicatorView = [TFYPanIndicatorView new];
            indicatorView.indicatorColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.800 alpha:1.00];
            return indicatorView;
        }
        case TFYIndicatorStyleText: {
            TFYTextIndicatorView *textIndicatorView = [TFYTextIndicatorView new];
            return textIndicatorView;
        }
        case TFYIndicatorStyleImmobile: {
            TFYImmobileIndicatorView *immobileIndicatorView = [TFYImmobileIndicatorView new];
            return immobileIndicatorView;
        }
    }
    return nil;
}


@end
