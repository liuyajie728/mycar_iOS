//
//  BaiduMapViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/23.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "BaiduMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface BaiduMapViewController () <BMKMapViewDelegate>
{
    BMKPointAnnotation* pointAnnotation;
}

@property (weak, nonatomic) IBOutlet BMKMapView *myMapView;
@end

@implementation BaiduMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置地图缩放级别
    [_myMapView setZoomLevel:14];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        _myMapView.delegate = nil;
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [_myMapView viewWillAppear];
    _myMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [self addPointAnnotation];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_myMapView viewWillDisappear];
    _myMapView.delegate = nil; // 不用时，置nil
}

- (void)addPointAnnotation
{
    [_myMapView removeOverlays:_myMapView.overlays];
    
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = self.targetLatitude;
    coor.longitude = self.targetLongitude;

    //地图的中心点
    _myMapView.centerCoordinate = coor;

    pointAnnotation.coordinate = coor;
    pointAnnotation.title = @"目的地";
    pointAnnotation.subtitle = @"此Annotation可拖拽!";
    [_myMapView addAnnotation:pointAnnotation];
    
}
#pragma mark baiduDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{


}

@end
