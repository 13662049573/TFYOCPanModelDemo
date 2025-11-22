//  本文件由TFY自动迁移工具生成，遵循现代Objective-C风格，全部中文注释。
//
//  TFYPanContainerView.h
//  TFYPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(PanContainerView)
@interface TFYPanContainerView : UIView

/// the presented view should add to the content view.
@property (nonatomic, strong, readonly, nonnull) UIView *contentView;

- (instancetype)initWithPresentedView:(nonnull UIView *)presentedView frame:(CGRect)frame NS_SWIFT_NAME(init(presentedView:frame:));

- (void)updateShadow:(nonnull UIColor *)shadowColor
        shadowRadius:(CGFloat)shadowRadius
        shadowOffset:(CGSize)shadowOffset
       shadowOpacity:(float)shadowOpacity NS_SWIFT_NAME(updateShadow(color:radius:offset:opacity:));

- (void)clearShadow NS_SWIFT_NAME(clearShadow());

@end

@interface UIView (PanContainer)

@property (nullable, nonatomic, strong, readonly) TFYPanContainerView *panContainerView;

@end

NS_ASSUME_NONNULL_END
