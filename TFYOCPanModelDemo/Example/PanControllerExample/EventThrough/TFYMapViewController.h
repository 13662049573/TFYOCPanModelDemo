//
//  TFYMapViewController.h
//  TFYPanModalDemo
//
//  Created by heath wang on 2019/9/27.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFYMapViewController;

@protocol TFYMapViewControllerDelegate <NSObject>

- (void)userMoveMapView:(TFYMapViewController *_Nonnull)mapViewController;

- (void)didRelease:(TFYMapViewController *_Nonnull)mapController;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TFYMapViewController : UIViewController

@property (nonatomic, weak) id <TFYMapViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
