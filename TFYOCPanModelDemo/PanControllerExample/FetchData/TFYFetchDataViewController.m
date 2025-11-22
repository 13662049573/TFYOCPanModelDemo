//
//  TFYFetchDataViewController.m
//  TFYPanModalDemo
//
//  Created by heath wang on 2019/9/9.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

#import "TFYFetchDataViewController.h"
#import "TFYPanModalNavView.h"
#import "UIDevice+TFY.h"

@interface TFYFetchDataDetailViewController : UIViewController <TFYPanModalPresentable, TFYPanModalNavViewDelegate>

@property (nonatomic, copy) NSString *textString;
@property (nonatomic, strong) TFYPanModalNavView *navView;

- (instancetype)initWithTextString:(NSString *)textString;

@end

@interface TFYFetchDataViewController () <UITableViewDelegate, UITableViewDataSource, TFYPanModalPresentable, TFYPanModalNavViewDelegate>

@property (nonatomic, strong) TFYPanModalNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) MJRefreshHeader *refreshHeader;

@end

@implementation TFYFetchDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.navView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.indicatorView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.left.right.bottom.equalTo(@0);
    }];

    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];

    [self.indicatorView startAnimating];
    [self fetchData];
    
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchData)];
    self.tableView.mj_header = self.refreshHeader;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pan_panModalTransitionTo:PresentationStateLong animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self pan_panModalSetNeedsLayoutUpdate];
}

- (void)fetchData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *list = [NSMutableArray array];
        NSString *text = @"Downstairs, the doctor left three different medicines in different colored capsules2 with instructions for giving them. One was to bring down the fever, another purgative3, the third to overcome an acid condition. The germs of influenza4 can only exist in an acid condition, he explained. He seemed to know all about influenza and said there was nothing to worry about if the fever did not go above one hundred and four degree. This was a light epidemic5 of flu and there was no danger if you avoided pneumonia6.\n"
                         "Back in the room I wrote the boy's temperature down and made a note of the time to give the various capsules.";
        for (int i = 0; i < 20; ++i) {
            NSString *subText = [text substringToIndex:arc4random() % text.length];
            [list addObject:subText];
        }
        self.dataSource = list;
        [self.tableView reloadData];
        [self.indicatorView stopAnimating];
        [self pan_panModalSetNeedsLayoutUpdate];
        
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
    });
}


#pragma mark - TFYPanModalPresentable

- (nullable UIScrollView *)panScrollable {
    return self.tableView;
}

- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 如果拖拽的点在navigation bar上，则返回yes，可以拖拽，否则只能滑动tableView
    CGPoint loc = [panGestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(self.navView.frame, loc)) {
        return YES;
    }
    return NO;
}

- (PanModalHeight)longFormHeight {
    CGFloat statusBarHeight = 0;
    if (@available(iOS 15.0, *)) {
        UIWindow *keyWindow = nil;
        for (UIWindow *window in [UIApplication sharedApplication].connectedScenes) {
            if ([window isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)window;
                for (UIWindow *w in windowScene.windows) {
                    if (w.isKeyWindow) {
                        keyWindow = w;
                        break;
                    }
                }
                if (keyWindow) break;
            }
        }
        if (keyWindow && keyWindow.windowScene.statusBarManager) {
            statusBarHeight = keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;
        }
    }
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, statusBarHeight);
}

- (CGFloat)topOffset {
    return 0;
}

- (BOOL)showDragIndicator {
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont italicSystemFontOfSize:16];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.dataSource[indexPath.row];
    TFYFetchDataDetailViewController *detailViewController = [[TFYFetchDataDetailViewController alloc] initWithTextString:text];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - TFYPanModalNavViewDelegate

- (void)didTapRightButton {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        _tableView.estimatedRowHeight = 60;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIActivityIndicatorView new];
        _indicatorView.color = [UIColor blackColor];
    }
    return _indicatorView;
}

- (TFYPanModalNavView *)navView {
    if (!_navView) {
        _navView = [[TFYPanModalNavView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        _navView.title = @"Comments";
        _navView.backButtonTitle = nil;
        _navView.delegate = self;
    }
    return _navView;
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end

@implementation TFYFetchDataDetailViewController

- (instancetype)initWithTextString:(NSString *)textString {
    self = [super init];
    if (self) {
        self.textString = textString;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1.00];
    [self.view addSubview:self.navView];

    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
    label.text = self.textString;
    label.numberOfLines = 0;

    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pan_panModalTransitionTo:PresentationStateLong animated:NO];
}

#pragma mark - TFYPanModalNavViewDelegate

- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didTapRightButton {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 0);
}

- (TFYPanModalNavView *)navView {
    if (!_navView) {
        _navView = [[TFYPanModalNavView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIDevice statusBarAndNaviBarHeight])];
        _navView.title = @"Detail";
        _navView.backButtonTitle = @"Back";
        _navView.delegate = self;
        _navView.statusBarHeight = [UIDevice statusBarHeight];
    }
    return _navView;
}


@end
