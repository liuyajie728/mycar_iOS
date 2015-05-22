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

//过滤纯数字
+ (BOOL)validateNumber:(NSString *) textString;

//6位颜色码转换uiColor
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//获取一个TitleView
+(UIView*)getTitleViewWithTitle:(NSString*)title andFount:(CGFloat)fount andTitleColour:(UIColor*)color;

//算出text的高度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

//获取一个post请求用的Dic 里面有个通用的token值
+(NSMutableDictionary*)getPostDic;

//根据评分获取图片
+(NSArray*)getStartImages:(float)number;



@end
