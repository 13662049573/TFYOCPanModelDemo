//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanModalHeight.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 * PanModalHeightType
 * 弹窗高度类型
 */
typedef NS_ENUM(NSInteger, PanModalHeightType) {
    PanModalHeightTypeMax NS_SWIFT_NAME(max), ///< 顶部最大高度
    PanModalHeightTypeMaxTopInset NS_SWIFT_NAME(topInset), ///< 顶部偏移高度
    PanModalHeightTypeContent NS_SWIFT_NAME(content), ///< 内容高度（底部）
    PanModalHeightTypeContentIgnoringSafeArea NS_SWIFT_NAME(contentIgnoringSafeArea), ///< 内容高度（忽略安全区）
    PanModalHeightTypeIntrinsic NS_SWIFT_NAME(intrinsic), ///< 自适应高度（不推荐）
};

/**
 * PanModalHeight
 * 弹窗高度结构体
 * heightType为Max/Intrinsic时，height值无效
 */
struct PanModalHeight {
    PanModalHeightType heightType NS_SWIFT_NAME(type); ///< 高度类型
    CGFloat height; ///< 高度值
};

typedef struct PanModalHeight PanModalHeight;

/**
 * 创建PanModalHeight结构体
 * @param heightType 高度类型
 * @param height 高度值
 * @return PanModalHeight结构体
 */
CG_INLINE PanModalHeight PanModalHeightMake(PanModalHeightType heightType, CGFloat height) {
    PanModalHeight modalHeight;
    modalHeight.heightType = heightType;
    modalHeight.height = height;
    return modalHeight;
}

/**
 * 判断浮点数是否为0
 */
static inline BOOL TFY_FLOAT_IS_ZERO(CGFloat value) {
    return (value > -FLT_EPSILON) && (value < FLT_EPSILON);
}

/**
 * 判断两个浮点数是否近似相等
 */
static inline BOOL TFY_TWO_FLOAT_IS_EQUAL(CGFloat x, CGFloat y) {
    CGFloat minusValue = fabs(x - y);
    CGFloat criticalValue = 0.0001;
    if (minusValue < criticalValue || minusValue < FLT_MIN) {
        return YES;
    }
    return NO;
}

