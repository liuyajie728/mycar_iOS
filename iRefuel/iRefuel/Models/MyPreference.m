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

+(NSDictionary*)getLoginInfo
{
    NSUserDefaults *userDefaults = USERDEFAULTS;
    NSDictionary *loginInfo = [userDefaults objectForKey:LOGIN_INFO];
    
    if (loginInfo) {
        return loginInfo;
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

@end
