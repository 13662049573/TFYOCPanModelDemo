//
//  TFYAppListViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/5/28.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYAppListViewController.h"
#import "TFYDemoTypeModel.h"

@interface TFYAppListViewController ()

@end

@implementation TFYAppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.demoList = [TFYDemoTypeModel appDemoTypeList];
    self.navigationItem.title = @"App UI";
}

@end
