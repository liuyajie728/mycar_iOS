//
//  CommonUtil.h
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface CommonUtil : NSObject

+ (NSString *)md5:(NSString *)input;

+ (NSString *)sha1:(NSString *)input;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;

//获取n天后的日期
+ (NSString*)getAssignDate:(int)n;


//获取月份时间
+(NSString*)getAssignMonthDate:(int)month;

+ (void)showHUD:(NSString*)text delay:(NSTimeInterval)interval withDelegate:(id<MBProgressHUDDelegate>)delegate;

//算出text的高度
//+(CGFloat)getCellHeight:(NSString*)text andWidth:(int)width;
@end
