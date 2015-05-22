//
//  AppDelegate.m
//  iRefuel
//
//  Created by 刘亚杰Kamas on 15/4/16.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CommonUtil.h"
#import <BaiduMapAPI/BMKMapManager.h>


@interface AppDelegate ()<BMKGeneralDelegate>

@end

BMKMapManager* _mapManager;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDictionary *dic =[[NSBundle mainBundle] infoDictionary];//获取info－plist
    NSString *appId  =  [dic objectForKey:@"CFBundleIdentifier"];//获取Bundle identifier
    NSLog(@"bundId: %@",appId);
    
    _mapManager = [[BMKMapManager alloc]init];
    NSLog(@"%@",_mapManager);
    
    BOOL ret = [_mapManager start:@"gfRVPQWP6mhZxKNqed6t1Rvf" generalDelegate:self];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
        NSLog(@"ok!");
    }
    
    
    //注册微信
    BOOL isok = [WXApi registerApp:@"wx920a184018cc7654"];
    if (isok) {
        //NSLog(@"注册微信成功");
    }else{
        NSLog(@"注册微信失败");
    }
    

    

    
    
    //设置网络请求的时候顶部有请求转菊花状态
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    //设置nav的颜色
    [[UINavigationBar appearance] setBarTintColor:[CommonUtil colorWithHexString:@"00a1d8" alpha:1]];
    //self.navigationController.navigationBar.translucent = YES
    [UINavigationBar appearance].translucent = YES;
    
    
    //设置barItem高亮的颜色
    [[UITabBar appearance] setTintColor:[UIColor orangeColor]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark 支付相关需要重写的两个方法
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WXApi handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
//    if ([sourceApplication isEqualToString:@"com.alipay.iphoneclient"]) {
//        
//        [[AlipaySDK defaultService]processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayResp" object:resultDic];
//            
//        }];
//        
//    }else{
//        return [WXApi handleOpenURL:url delegate:self];
//    }
    
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark baiduMapDelegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeLocation" object:nil];
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeLocation" object:nil];
}
@end
