//
//  TFYIndicatorViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/8/10.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYIndicatorViewController.h"
#import "TFYIndicatorPopViewController.h"

@interface TFYIndicatorModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) TFYIndicatorStyle style;

- (instancetype)initWithTitle:(NSString *)title style:(TFYIndicatorStyle)style;

+ (instancetype)modelWithTitle:(NSString *)title style:(TFYIndicatorStyle)style;

@end

@interface TFYIndicatorViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *styleList;

@end

@implementation TFYIndicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Custom Indicator";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.styleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    TFYIndicatorModel *indicatorModel = self.styleList[(NSUInteger) indexPath.row];
    cell.textLabel.text = indicatorModel.title;
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TFYIndicatorModel *indicatorModel = self.styleList[(NSUInteger) indexPath.row];
    TFYIndicatorPopViewController *popViewController = [TFYIndicatorPopViewController controllerWithIndicatorStyle:indicatorModel.style];
    [self presentPanModal:popViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        _tableView.rowHeight = 60;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)styleList {
    if (!_styleList) {
        TFYIndicatorModel *modelColor = [TFYIndicatorModel modelWithTitle:@"Custom Default Indicator Color" style:TFYIndicatorStyleChangeColor];
        TFYIndicatorModel *modelText = [TFYIndicatorModel modelWithTitle:@"A Text Indicator View" style:TFYIndicatorStyleText];
        TFYIndicatorModel *modelView = [TFYIndicatorModel modelWithTitle:@"Immobile Indicator View" style:TFYIndicatorStyleImmobile];
        _styleList = @[modelColor, modelText, modelView];
    }
    return _styleList;
}


@end

@implementation TFYIndicatorModel

- (instancetype)initWithTitle:(NSString *)title style:(TFYIndicatorStyle)style {
    self = [super init];
    if (self) {
        _title = [title copy];
        _style = style;
    }

    return self;
}

+ (instancetype)modelWithTitle:(NSString *)title style:(TFYIndicatorStyle)style {
    return [[self alloc] initWithTitle:title style:style];
}


@end
