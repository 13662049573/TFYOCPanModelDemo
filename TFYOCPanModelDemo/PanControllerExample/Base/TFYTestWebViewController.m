//
//  TFYTestWebViewController.m
//  TFYPanModalDemo
//
//  Created by heath wang on 2020/12/9.
//  Copyright © 2020 wangcongling. All rights reserved.
//

#import "TFYTestWebViewController.h"
#import <WebKit/WebKit.h>


@interface TFYTestWebViewController () <TFYPanModalPresentable, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation TFYTestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webview = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webview.navigationDelegate  = self;
    [self.view addSubview:self.webview];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webview.frame = self.view.bounds;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self pan_panModalSetNeedsLayoutUpdate];
}

#pragma mark - TFYPanModalPresentable

- (UIScrollView *)panScrollable {
    return self.webview.scrollView;
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 64);
}

@end
