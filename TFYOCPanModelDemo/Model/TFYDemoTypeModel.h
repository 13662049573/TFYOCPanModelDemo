//
//  TFYDemoTypeModel.h
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/5/6.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TFYActionType) {
    TFYActionTypePresent, // default present controller
    TFYActionTypePush,    // push into navigation
};

@interface TFYDemoTypeModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) Class targetClass;
@property (nonatomic, assign) TFYActionType action;

- (instancetype)initWithTitle:(NSString *)title targetClass:(Class)targetClass;

+ (instancetype)modelWithTitle:(NSString *)title targetClass:(Class)targetClass;


+ (NSArray<TFYDemoTypeModel *> *)demoTypeList;
+ (NSArray<TFYDemoTypeModel *> *)appDemoTypeList;

@end

NS_ASSUME_NONNULL_END
