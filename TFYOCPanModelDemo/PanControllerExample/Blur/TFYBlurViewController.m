//
//  TFYBlurViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/6/14.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYBlurViewController.h"
#import "TFYOCPanlModel.h"

@interface TFYBlurViewController () <TFYPanModalPresentable>

@end

@implementation TFYBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.200 green:0.400 blue:1.000 alpha:1.00];
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 150);
}

- (BOOL)showDragIndicator {
    return NO;
}

- (TFYBackgroundConfig *)backgroundConfig {
    TFYBackgroundConfig *backgroundConfig;
    
    if (@available(iOS 14.0, *)) {
        // iOS14+, the blur api has changed, use system VisualEffect.
        backgroundConfig = [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorSystemVisualEffect];
    } else {
        backgroundConfig = [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorCustomBlurEffect];
        backgroundConfig.backgroundBlurRadius = 15;
    }
    
    return backgroundConfig;
}

@end
