//
//  AppDelegate.m
//  iRefuel
//
//  Created by 刘亚杰Kamas on 15/4/16.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册微信
    BOOL isok = [WXApi registerApp:@"wx920a184018cc7654"];
    if (isok) {
        NSLog(@"注册微信成功");
    }else{
        NSLog(@"注册微信失败");
    }
    
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
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

@end
