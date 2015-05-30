//
//  MyPreference.h
//  iRefuel
//
//  Created by wangdi on 15/5/25.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERDEFAULTS (NSUserDefaults*)[NSUserDefaults standardUserDefaults]

#define LOGIN_INFO            @"loginInfo"
#define YOUZHAN_LIST          @"youzhanList"
#define BRAND_LIST            @"brandList"

@interface MyPreference : NSObject

//loginInfo
+(NSMutableDictionary*)getLoginInfo;
+(void)commitLoginInfo:(NSDictionary*)info;

//所有加油站列表
+(NSArray*)getYouzhanList;
+(void)commitYouzhanList:(NSArray*)list;

//品牌对应id信息
+(NSArray*)getBrandList;
+(void)commitBrandList:(NSArray*)list;


@end
