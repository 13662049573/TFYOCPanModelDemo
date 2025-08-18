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
    self.view.backgroundColor = [UIColor redColor];
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
    
    if (@available(iOS 13.0, *)) {
        // iOS13+, use system VisualEffect.
        backgroundConfig = [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorSystemVisualEffect];
    } else {
        backgroundConfig = [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorCustomBlurEffect];
        backgroundConfig.backgroundBlurRadius = 15;
    }
    
    return backgroundConfig;
}

@end
