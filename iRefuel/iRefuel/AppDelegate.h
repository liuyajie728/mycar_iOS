//
//  AppDelegate.h
//  iRefuel
//
//  Created by 刘亚杰Kamas on 15/4/16.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"



#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication]delegate]

//获取屏幕信息（尺寸，宽，高）
#define LCDSIZE [[UIScreen mainScreen] bounds]
#define LCDW LCDSIZE.size.width
#define LCDH LCDSIZE.size.height
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (assign, nonatomic) BOOL isInPageView;
//@property (assign, nonatomic) BOOL isTransverse;


@end

