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
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (assign, nonatomic) BOOL isInPageView;
//@property (assign, nonatomic) BOOL isTransverse;


@end

