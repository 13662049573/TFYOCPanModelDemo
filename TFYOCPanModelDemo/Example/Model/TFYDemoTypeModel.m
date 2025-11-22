//
//  TFYDemoTypeModel.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYDemoTypeModel.h"
#import "TFYBaseViewController.h"
#import "TFYGroupViewController.h"
#import "TFYAlertViewController.h"
#import "TFYTransientAlertViewController.h"
#import "TFYStackedGroupViewController.h"
#import "TFYNavViewController.h"
#import "TFYFullScreenNavController.h"
#import "TFYPickerViewController.h"
#import "TFYDynamicHeightViewController.h"
#import "TFYShareViewController.h"
#import "TFYAppListViewController.h"
#import "TFYShoppingCartViewController.h"
#import "TFYMyCustomAnimationViewController.h"
#import "TFYColorBlocksViewController.h"
#import "TFYTextInputViewController.h"
#import "TFYIndicatorViewController.h"
#import "TFYFetchDataViewController.h"
#import "TFYMapViewController.h"
#import "TFYTestViewPanModalController.h"
#import "TFYNestedScrollViewController.h"
#import "TFYTestWebViewController.h"
#import "TFYFrequentTapPreventionExampleViewController.h"
#import "TFYSimpleFrequentTapPreventionViewController.h"
#import "TFYPopupDemoViewController.h"

@implementation TFYDemoTypeModel

- (instancetype)initWithTitle:(NSString *)title targetClass:(Class)targetClass {
	self = [super init];
	if (self) {
		self.title = title;
		self.targetClass = targetClass;
	}

	return self;
}

+ (instancetype)modelWithTitle:(NSString *)title targetClass:(Class)targetClass {
	return [[self alloc] initWithTitle:title targetClass:targetClass];
}

+ (NSArray<TFYDemoTypeModel *> *)demoTypeList {
	NSMutableArray *array = [NSMutableArray array];

	TFYDemoTypeModel *baseDemo = [TFYDemoTypeModel modelWithTitle:@"Basic" targetClass:TFYBaseViewController.class];
    TFYDemoTypeModel *webDemo = [TFYDemoTypeModel modelWithTitle:@"Web" targetClass:TFYTestWebViewController.class];
	TFYDemoTypeModel *groupDemo = [TFYDemoTypeModel modelWithTitle:@"Group" targetClass:TFYGroupViewController.class];
	TFYDemoTypeModel *alertDemo = [TFYDemoTypeModel modelWithTitle:@"Alert" targetClass:TFYAlertViewController.class];
	TFYDemoTypeModel *autoAlertDemo = [TFYDemoTypeModel modelWithTitle:@"Transient Alert" targetClass:TFYTransientAlertViewController.class];
	TFYDemoTypeModel *stackGroupDemo = [TFYDemoTypeModel modelWithTitle:@"Group - Stacked" targetClass:TFYStackedGroupViewController.class];
	TFYDemoTypeModel *fullScreenDemo = [TFYDemoTypeModel modelWithTitle:@"Full Screen - Nav" targetClass:TFYFullScreenNavController.class];
	TFYDemoTypeModel *dynamicDemo = [TFYDemoTypeModel modelWithTitle:@"Dynamic Update UI" targetClass:TFYDynamicHeightViewController.class];
    TFYDemoTypeModel *customAnimationDemo = [TFYDemoTypeModel modelWithTitle:@"Custom Presenting Controller" targetClass:TFYMyCustomAnimationViewController.class];
    TFYDemoTypeModel *nestedDemo = [TFYDemoTypeModel modelWithTitle:@"Nested Scroll" targetClass:TFYNestedScrollViewController.class];

    TFYDemoTypeModel *textInputDemo = [TFYDemoTypeModel modelWithTitle:@"Handle Keyboard" targetClass:TFYTextInputViewController.class];
    TFYDemoTypeModel *testViewDemo = [TFYDemoTypeModel modelWithTitle:@"Use PanModal View" targetClass:TFYTestViewPanModalController.class];
    testViewDemo.action = TFYActionTypePush;
    
    TFYDemoTypeModel *frequentTapDemo = [TFYDemoTypeModel modelWithTitle:@"Frequent Tap Prevention" targetClass:TFYFrequentTapPreventionExampleViewController.class];
    frequentTapDemo.action = TFYActionTypePush;
    
    TFYDemoTypeModel *simpleFrequentTapDemo = [TFYDemoTypeModel modelWithTitle:@"Simple Frequent Tap Prevention" targetClass:TFYSimpleFrequentTapPreventionViewController.class];
    simpleFrequentTapDemo.action = TFYActionTypePush;
    
    TFYDemoTypeModel *appDemo = [TFYDemoTypeModel modelWithTitle:@"App Demo" targetClass:TFYAppListViewController.class];
    appDemo.action = TFYActionTypePush;
    TFYDemoTypeModel *blurDemo = [TFYDemoTypeModel modelWithTitle:@"Blur Background" targetClass:TFYColorBlocksViewController.class];
    blurDemo.action = TFYActionTypePush;
    TFYDemoTypeModel *indicatorDemo = [TFYDemoTypeModel modelWithTitle:@"Custom Indicator" targetClass:TFYIndicatorViewController.class];
    indicatorDemo.action = TFYActionTypePush;
    TFYDemoTypeModel *mapDemo = [TFYDemoTypeModel modelWithTitle:@"Events Passing Through TransitionView" targetClass:TFYMapViewController.class];
    mapDemo.action = TFYActionTypePush;
    
    TFYDemoTypeModel *popupDemo = [TFYDemoTypeModel modelWithTitle:@"🚀 TFYPopup 弹窗框架演示" targetClass:TFYPopupDemoViewController.class];
    popupDemo.action = TFYActionTypePush;

	[array addObjectsFromArray:@[popupDemo, appDemo, blurDemo, indicatorDemo, mapDemo, frequentTapDemo, simpleFrequentTapDemo, testViewDemo, textInputDemo, baseDemo, webDemo, alertDemo, autoAlertDemo, dynamicDemo, nestedDemo, groupDemo, stackGroupDemo, fullScreenDemo, customAnimationDemo]];

	return [array copy];
}

+ (NSArray<TFYDemoTypeModel *> *)appDemoTypeList {
    TFYDemoTypeModel *navDemo = [TFYDemoTypeModel modelWithTitle:@"Group - Nav - 知乎评论" targetClass:TFYNavViewController.class];
    TFYDemoTypeModel *pickerDemo = [TFYDemoTypeModel modelWithTitle:@"Picker" targetClass:TFYPickerViewController.class];
    TFYDemoTypeModel *shareDemo = [TFYDemoTypeModel modelWithTitle:@"Share - 网易云音乐" targetClass:TFYShareViewController.class];
    TFYDemoTypeModel *shoppingDemo = [TFYDemoTypeModel modelWithTitle:@"Shopping - JD" targetClass:TFYShoppingCartViewController.class];
    TFYDemoTypeModel *fetchDataDemo = [TFYDemoTypeModel modelWithTitle:@"Fetch Data & reload" targetClass:TFYFetchDataViewController.class];
    return @[navDemo, fetchDataDemo, pickerDemo, shareDemo, shoppingDemo];
}

@end
