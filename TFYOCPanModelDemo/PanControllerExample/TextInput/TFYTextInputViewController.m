//
//  TFYTextInputViewController.m
//  TFYPanModal_Example
//
//  Created by heath wang on 2019/6/19.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYTextInputViewController.h"
#import <Masonry/View+MASAdditions.h>
#import "TFYInputTableViewCell.h"

@interface TFYTextInputViewController () <TFYPanModalPresentable, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TFYTextInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 400);
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 0);
}

- (UIScrollView *)panScrollable {
    return self.tableView;
}

- (CGFloat)keyboardOffsetFromInputView {
    return 10;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TFYInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TFYInputTableViewCell.class) forIndexPath:indexPath];
    cell.textField.keyboardType = (UIKeyboardType) indexPath.row;
    cell.textField.placeholder = [NSString stringWithFormat:@"please input something @%ld", (long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.rowHeight = 50;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:TFYInputTableViewCell.class forCellReuseIdentifier:NSStringFromClass(TFYInputTableViewCell.class)];

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
