//
//  MyPreference.h
//  iRefuel
//
//  Created by wangdi on 15/5/25.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERDEFAULTS (NSUserDefaults*)[NSUserDefaults standardUserDefaults]

#define LOGIN_INFO  @"loginInfo"
@interface MyPreference : NSObject

//loginInfo
+(NSDictionary*)getLoginInfo;
+(void)commitLoginInfo:(NSDictionary*)info;

@end
