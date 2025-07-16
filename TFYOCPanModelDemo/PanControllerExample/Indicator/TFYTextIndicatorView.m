//
//  TFYTextIndicatorView.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/8/10.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYTextIndicatorView.h"

@interface TFYTextIndicatorView ()

@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation TFYTextIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _stateLabel = [UILabel new];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.font = [UIFont systemFontOfSize:14];
        _stateLabel.textColor = [UIColor darkTextColor];

        [self addSubview:_stateLabel];
    }

    return self;
}


- (void)didChangeToState:(TFYIndicatorState)state {
    switch (state) {
        case TFYIndicatorStateNormal: {
            self.stateLabel.text = @"Please pull down to dismiss";
            self.stateLabel.textColor = [UIColor whiteColor];
        }
            break;
        case TFYIndicatorStatePullDown: {
            self.stateLabel.text = @"Keep pull down to dismiss";
            self.stateLabel.textColor = [UIColor colorWithRed:1.000 green:0.200 blue:0.000 alpha:1.00];
        }
            break;
    }
}

- (CGSize)indicatorSize {
    return CGSizeMake(200, 18);
}

- (void)setupSubviews {
    self.stateLabel.frame = self.bounds;
}


@end
