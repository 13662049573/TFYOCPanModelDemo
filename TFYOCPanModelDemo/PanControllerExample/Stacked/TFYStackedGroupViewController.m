//
//  TFYStackedGroupViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYStackedGroupViewController.h"
#import "TFYColorDetailViewController.h"

@interface TFYStackedGroupViewController () <TFYPanModalPresentable>

@end

@implementation TFYStackedGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = [self colorWithIndex:indexPath.row];
    TFYColorDetailViewController *controller = [TFYColorDetailViewController new];
    controller.color = color;
    [self presentPanModal:controller];
}

#pragma mark - TFYPanModalPresentable


- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 0);
}

- (PanModalHeight)shortFormHeight {
    return [self longFormHeight];
}

@end
