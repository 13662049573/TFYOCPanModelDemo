//
//  TFYCardStylePanModalView.m
//  TFYPanModalDemo
//
//  Created by admin on 2025/1/16.
//

#import "TFYCardStylePanModalView.h"
#import <Masonry/Masonry.h>

@interface TFYCardStylePanModalView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray<UIView *> *cardViews;
@property (nonatomic, strong) NSArray<NSString *> *cardTitles;
@property (nonatomic, strong) NSArray<NSString *> *cardDescriptions;
@property (nonatomic, strong) NSArray<UIColor *> *cardColors;

@end

@implementation TFYCardStylePanModalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupUI];
    }
    return self;
}

- (void)setupData {
    self.cardTitles = @[@"功能一", @"功能二", @"功能三", @"功能四", @"功能五"];
    self.cardDescriptions = @[
        @"这是第一个功能的详细描述，展示了卡片式布局的效果",
        @"第二个功能提供了更多的交互选项和视觉反馈",
        @"第三个功能包含了丰富的UI元素和动画效果",
        @"第四个功能展示了不同的设计风格和布局方式",
        @"第五个功能整合了前面所有的设计元素"
    ];
    self.cardColors = @[
        [UIColor systemBlueColor],
        [UIColor systemGreenColor],
        [UIColor systemOrangeColor],
        [UIColor systemPurpleColor],
        [UIColor systemPinkColor]
    ];
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 创建卡片
    [self createCards];
    
    [self setupConstraints];
}

- (void)createCards {
    NSMutableArray *cards = [NSMutableArray array];
    
    for (int i = 0; i < self.cardTitles.count; i++) {
        UIView *cardView = [self createCardWithIndex:i];
        [self.contentView addSubview:cardView];
        [cards addObject:cardView];
    }
    
    self.cardViews = [cards copy];
}

- (UIView *)createCardWithIndex:(NSInteger)index {
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = self.cardColors[index];
    cardView.layer.cornerRadius = 16.0;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 4);
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowRadius = 8.0;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.cardTitles[index];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [cardView addSubview:titleLabel];
    
    // 描述
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = self.cardDescriptions[index];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textColor = [UIColor whiteColor];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.numberOfLines = 0;
    [cardView addSubview:descLabel];
    
    // 图标
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage systemImageNamed:[self iconNameForIndex:index]];
    iconView.tintColor = [UIColor whiteColor];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [cardView addSubview:iconView];
    
    // 设置约束
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(20);
        make.left.equalTo(cardView).offset(20);
        make.right.equalTo(iconView.mas_left).offset(-15);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.left.equalTo(cardView).offset(20);
        make.right.equalTo(iconView.mas_left).offset(-15);
        make.bottom.equalTo(cardView).offset(-20);
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(20);
        make.right.equalTo(cardView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)];
    [cardView addGestureRecognizer:tapGesture];
    cardView.tag = index;
    
    return cardView;
}

- (NSString *)iconNameForIndex:(NSInteger)index {
    NSArray *iconNames = @[@"star.fill", @"heart.fill", @"bolt.fill", @"leaf.fill", @"flame.fill"];
    return iconNames[index % iconNames.count];
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // 设置卡片约束
    UIView *previousCard = nil;
    for (int i = 0; i < self.cardViews.count; i++) {
        UIView *cardView = self.cardViews[i];
        
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView).inset(20);
            make.height.equalTo(@120);
            
            if (previousCard) {
                make.top.equalTo(previousCard.mas_bottom).offset(20);
            } else {
                make.top.equalTo(self.contentView).offset(20);
            }
            
            if (i == self.cardViews.count - 1) {
                make.bottom.equalTo(self.contentView).offset(-20);
            }
        }];
        
        previousCard = cardView;
    }
}

#pragma mark - Actions

- (void)cardTapped:(UITapGestureRecognizer *)gesture {
    NSInteger index = gesture.view.tag;
    NSLog(@"点击了卡片: %@", self.cardTitles[index]);
    
    // 添加点击动画
    UIView *cardView = gesture.view;
    [UIView animateWithDuration:0.1 animations:^{
        cardView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            cardView.transform = CGAffineTransformIdentity;
        }];
    }];
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 300);
}

- (PanModalHeight)mediumFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 500);
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 700);
}

- (CGFloat)topOffset {
    return self.safeAreaInsets.top + 21;
}

- (BOOL)shouldRoundTopCorners {
    return YES;
}

- (CGFloat)cornerRadius {
    return 20.0;
}

- (PresentationState)originPresentationState {
    return PresentationStateMedium;
}

- (CGFloat)springDamping {
    return 0.8;
}

- (UIScrollView *)panScrollable {
    return self.scrollView;
}

- (TFYBackgroundConfig *)backgroundConfig {
    return [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorSystemVisualEffect];
}

@end
