//
//  TFYSimplePanModalView.m
//  TFYPanModalDemo
//
//  Created by heath wang on 2019/10/18.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

#import "TFYSimplePanModalView.h"
#import "TFYColorCell.h"


@interface TFYSimplePanModalView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<UIColor *> *colors;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TFYSimplePanModalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.tableView registerClass:TFYColorCell.class forCellReuseIdentifier:NSStringFromClass(TFYColorCell.class)];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        [self addSubview:self.tableView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.colors.count * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TFYColorCell *colorCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TFYColorCell.class) forIndexPath:indexPath];
    colorCell.contentView.backgroundColor = [self colorWithIndex:indexPath.row];
    return colorCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 100);
}

- (PanModalHeight)mediumFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 500);
}



- (CGFloat)topOffset {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    // 只支持iOS 15+，直接用safeAreaInsets.top
    return self.safeAreaInsets.top + 21;
#else
    return 21;
#endif
}

- (BOOL)shouldRoundTopCorners {
    return YES;
}

//- (UIViewAnimationOptions)transitionAnimationOptions {
//    return UIViewAnimationOptionCurveLinear;
//}

- (PresentationState)originPresentationState {
    return PresentationStateMedium;
}

- (CGFloat)springDamping {
    return 0.618;
}

- (UIScrollView *)panScrollable {
    return self.tableView;
}

- (TFYPanModalShadow *)contentShadow {
    return [[TFYPanModalShadow alloc] initWithColor:[UIColor systemPinkColor] shadowRadius:10 shadowOffset:CGSizeMake(1, 1) shadowOpacity:1];
}

//- (BOOL)allowsTouchEventsPassingThroughTransitionView {
//    return YES;
//}

- (TFYBackgroundConfig *)backgroundConfig {
    return [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorSystemVisualEffect];
}

#pragma mark - Getter

- (NSArray<UIColor *> *)colors {
    if (!_colors) {
        _colors = @[[UIColor colorWithRed:0.000 green:0.992 blue:0.102 alpha:1.00],
                    [UIColor colorWithRed:0.816 green:0.980 blue:0.000 alpha:1.00],
                    [UIColor colorWithRed:0.000 green:0.992 blue:0.888 alpha:1.00],
                    [UIColor colorWithRed:0.000 green:0.670 blue:1.000 alpha:1.00],
                    [UIColor colorWithRed:0.612 green:0.291 blue:1.000 alpha:1.00],
                    [UIColor colorWithRed:1.000 green:0.485 blue:0.828 alpha:1.00],
                    [UIColor colorWithRed:1.000 green:0.544 blue:0.350 alpha:1.00],
                    [UIColor colorWithRed:0.749 green:0.982 blue:0.800 alpha:1.00]];
    }
    return _colors;
}

- (UIColor *)colorWithIndex:(NSInteger)index {
    return self.colors[index % self.colors.count];
}

@end
