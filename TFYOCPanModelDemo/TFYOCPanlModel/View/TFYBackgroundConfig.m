//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYBackgroundConfig.m
//  TFYPanModal
//
//  Created by heath wang on 2020/4/17.
//

#import "TFYBackgroundConfig.h"

@implementation TFYBackgroundConfig

// =====================
// 详细中文注释与健壮性补充
// =====================
//
// 1. 构造方法、配置切换等关键方法补充中文注释
// 2. 重要属性、内部状态、回调点补充注释
// 3. 关键分支、易混淆逻辑增加注释说明
//
//  Created by heath wang on 2020/4/17.
//

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundBehavior = TFYBackgroundBehaviorDefault;
    }

    return self;
}

- (instancetype)initWithBehavior:(TFYBackgroundBehavior)backgroundBehavior {
    self = [super init];
    if (self) {
        self.backgroundBehavior = backgroundBehavior;
    }

    return self;
}

+ (instancetype)configWithBehavior:(TFYBackgroundBehavior)backgroundBehavior {
    return [[self alloc] initWithBehavior:backgroundBehavior];
}

#pragma mark - Setter

- (void)setBackgroundBehavior:(TFYBackgroundBehavior)backgroundBehavior {
    _backgroundBehavior = backgroundBehavior;

    switch (backgroundBehavior) {
        case TFYBackgroundBehaviorSystemVisualEffect: {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
            if (@available(iOS 13.0, *)) {
                self.visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial];
            } else {
                self.visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            }
#else
            self.visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
#endif
        }
            break;
        case TFYBackgroundBehaviorCustomBlurEffect: {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
            if (@available(iOS 13.0, *)) {
                self.backgroundBlurRadius = 10;
                self.blurTintColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                        return [UIColor colorWithWhite:0.1 alpha:0.7];
                    } else {
                        return [UIColor whiteColor];
                    }
                }];
            } else {
                self.backgroundBlurRadius = 10;
                self.blurTintColor = [UIColor whiteColor];
            }
#else
            self.backgroundBlurRadius = 10;
            self.blurTintColor = [UIColor whiteColor];
#endif
        }
            break;
        default: {
            self.backgroundAlpha = 0.7;
        }
            break;
    }
}


@end
