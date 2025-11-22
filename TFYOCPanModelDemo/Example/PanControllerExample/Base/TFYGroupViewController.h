//
//  TFYGroupViewController.h
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/4/30.
//  Copyright © 2019 HeathWang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFYGroupViewController : UITableViewController

@property (nonatomic, strong) NSArray<UIColor *> *colors;

- (UIColor *)colorWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
