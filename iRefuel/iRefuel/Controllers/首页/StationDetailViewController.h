//
//  StationDetailViewController.h
//  iRefuel
//
//  Created by wangdi on 15/5/21.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationDetailViewController : UIViewController


//这两个id是扫码进入详情页面所需要的值
@property (nonatomic,copy) NSString * stationId;
@property (nonatomic,copy) NSString * operatorId;

//这个是从首页进入详情页
@property (nonatomic,strong) NSDictionary * firstInfo;

//定位起始目的坐标值
@property (nonatomic,assign) double startLongitude;
@property (nonatomic,assign) double startLatitude;

@end
