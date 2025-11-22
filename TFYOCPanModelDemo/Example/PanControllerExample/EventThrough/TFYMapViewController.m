//
//  TFYMapViewController.m
//  TFYPanModalDemo
//
//  Created by heath wang on 2019/9/27.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "TFYMapViewController.h"
#import "TFYEventPassThroughViewController.h"

@interface TFYMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation TFYMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"SHOW ME" style:UIBarButtonItemStylePlain target:self action:@selector(showPanModal)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate, 1000, 1000);
    [self.mapView setRegion:region animated:YES];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

#pragma mark - show panModal

- (void)showPanModal {
    if (self.presentedViewController)
        return;
    TFYEventPassThroughViewController *eventPassThroughViewController = [TFYEventPassThroughViewController new];
    self.delegate = eventPassThroughViewController;
    [self presentPanModal:eventPassThroughViewController completion:^{
        
    }];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    id <TFYMapViewControllerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(userMoveMapView:)]) {
        [delegate userMoveMapView:self];
    }
}


#pragma mark - Getter

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
    }
    return _mapView;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}

- (void)dealloc {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRelease:)]) {
        [self.delegate didRelease:self];
    }
}

@end
