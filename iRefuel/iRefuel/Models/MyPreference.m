//
//  MyPreference.m
//  iRefuel
//
//  Created by wangdi on 15/5/25.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "MyPreference.h"
#import "CommonUtil.h"

@implementation MyPreference

//loginInfo
+(NSMutableDictionary*)getLoginInfo
{
    NSUserDefaults *userDefaults = USERDEFAULTS;
    NSDictionary *loginInfo = [userDefaults objectForKey:LOGIN_INFO];
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]initWithDictionary:loginInfo];
    
    if (mDic) {
        return mDic;
    }else{
        return nil;
    }
}
+(void)commitLoginInfo:(NSDictionary*)info{

    //因为服务器返回的数据中可能存在null类型保存会出错误，在这里把所有内容都过滤一下
    NSDictionary * saveDic;
    if (info) {
        saveDic = [CommonUtil changeDicSubType:info];
    }else{
        saveDic = nil;
    }
       
    
    NSUserDefaults *userDefaults = USERDEFAULTS;
    [userDefaults setObject:saveDic forKey:LOGIN_INFO];
    [userDefaults synchronize];
}

//缓存油站列表
+(NSArray*)getYouzhanList
{
    NSUserDefaults *userDefaults = USERDEFAULTS;
    NSArray *list = [userDefaults objectForKey:YOUZHAN_LIST];
    
    if (list) {
        return list;
    }else{
        return nil;
    }
}
+(void)commitYouzhanList:(NSArray*)list
{
    NSUserDefaults *userDefaults = USERDEFAULTS;
    [userDefaults setObject:list forKey:YOUZHAN_LIST];
    [userDefaults synchronize];
}

//品牌列表
+(NSArray*)getBrandList
{
    NSUserDefaults *userDefaults = USERDEFAULTS;
    NSArray *list = [userDefaults objectForKey:BRAND_LIST];
    
    if (list) {
        return list;
    }else{
        return nil;
    }
}
+(void)commitBrandList:(NSArray*)list
{
    
    //因为服务器返回的数据中可能存在null类型保存会出错误，在这里把所有内容都过滤一下
    NSMutableArray * saveAry = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in saveAry) {
        NSDictionary * saveDic = [CommonUtil changeDicSubType:dic];
        [saveAry addObject:saveDic];
    }
    
    
    NSUserDefaults *userDefaults = USERDEFAULTS;
    [userDefaults setObject:saveAry forKey:BRAND_LIST];
    [userDefaults synchronize];

}

@end
