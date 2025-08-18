//
//  TFYBaseViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/4/30.
//  Copyright © 2019 HeathWang. All rights reserved.
//

#import "TFYOCPanlModel.h"
#import "TFYBaseViewController.h"

@interface TFYBaseViewController () <TFYPanModalPresentable, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textfield;

@end

@implementation TFYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.000 green:0.989 blue:0.935 alpha:1.00];
    
    self.textfield = [UITextField new];
    self.textfield.borderStyle = UITextBorderStyleBezel;
    self.textfield.frame = CGRectMake(20, 64, 300, 38);
    self.textfield.placeholder = @"Please type something.";
    self.textfield.delegate = self;
    [self.view addSubview:self.textfield];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"Tap Me To Dismiss Directly" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    closeButton.frame = CGRectMake(20, 122, 300, 30);
    [closeButton addTarget:self action:@selector(didTapCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self shouldEnableAppearanceTransition]) {
        NSLog(@"viewDidAppear=========TFYBaseViewController");
    }
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([self shouldEnableAppearanceTransition]) {
        NSLog(@"viewDidDisappear=======TFYBaseViewController");
    }
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)didTapCloseButton {
    [self pan_dismissAnimated:YES completion:^{
        
    }];
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)shortFormHeight { // 弹出的高度
    return PanModalHeightMake(PanModalHeightTypeContent, self.view.bounds.size.height * 0.6);
}

- (PanModalHeight)mediumFormHeight {//
    return PanModalHeightMake(PanModalHeightTypeContent, self.view.bounds.size.height);
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 0);
}

- (CGFloat)topOffset {
    return 0;
}

- (BOOL)anchorModalToLongForm {
    return NO;
}

- (TFYPanModalShadow *)contentShadow {
    return [[TFYPanModalShadow alloc] initWithColor:[UIColor yellowColor] shadowRadius:20 shadowOffset:CGSizeMake(0, 2) shadowOpacity:1];
}

- (UIViewAnimationOptions)transitionAnimationOptions {
    return UIViewAnimationOptionCurveEaseOut;
}

- (BOOL)showDragIndicator {
    return NO;
}

- (BOOL)allowsDragToDismiss {
    return NO;
}

- (BOOL)shouldEnableAppearanceTransition {
    return NO;
}

- (NSTimeInterval)dismissalDuration {
    return 1.0;
}

- (void)didEndRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
//    CGPoint velocity = [panGestureRecognizer velocityInView:self.pan_contentView];
//    if (velocity.y > 100 && !self.isBeingDismissed) {
//        [self pan_dismissAnimated:YES completion:^{
//            // do something.
//        }];
//    }
}

@end
