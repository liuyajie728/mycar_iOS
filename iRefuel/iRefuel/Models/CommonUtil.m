//
//  CommonUtil.m
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "CommonUtil.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "MyPreference.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

#define myDotNumbers     @"0123456789.\n"
#define myNumbers        @"0123456789\n"

@implementation CommonUtil

+ (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)sha1:(NSString *)input
{
    const char *ptr = [input UTF8String];
    
    int i =0;
    int len = (int)strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    // The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
    return [addresses count] ? addresses : nil;
}

+ (NSString*)getAssignDate:(int)n
{
    NSDate *  senddate =[NSDate date];
    NSTimeInterval interval = 24*60*60*n;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *titleString = [dateFormatter stringFromDate:[senddate initWithTimeInterval:interval sinceDate:senddate]];

    return [titleString substringToIndex:10];
}

//+(CGFloat)getCellHeight:(NSString*)text andWidth:(int)width;
//{
//    NSString * caption = text;
//    
//    Size labelSize = CGSizeZero;
//    UIFont *labelFont = [UIFont boldSystemFontOfSize:13.0];
//    labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//    
//    
//    CGFloat fHeight = labelSize.height *1.03;
//    return fHeight;
//
//}

+(NSString*)getAssignMonthDate:(int)month
{

    NSDate *  senddate =[NSDate date];
    NSTimeInterval interval = 24*60*60*30*month;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *titleString = [dateFormatter stringFromDate:[senddate initWithTimeInterval:interval sinceDate:senddate]];
    
    return [titleString substringToIndex:10];

}

+ (void)showHUD:(NSString*)text delay:(NSTimeInterval)interval withDelegate:(id<MBProgressHUDDelegate>) delegate{
    NSArray* windowArray = [[UIApplication sharedApplication] windows];
    UIWindow *tempKeyboardWindow = [windowArray objectAtIndex: [windowArray count] - 1];
    
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:tempKeyboardWindow];
    [tempKeyboardWindow addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.delegate = delegate;
    HUD.detailsLabelText = text;
    HUD.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
    [HUD show:YES];
    [HUD hide:YES afterDelay:interval];
    
}



+ (BOOL)validateNumber:(NSString *) textString;
{
    NSString* number=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+(UIView*)getTitleViewWithTitle:(NSString*)title andFount:(CGFloat)fount andTitleColour:(UIColor*)color
{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 215, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.textColor = color;
    titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:fount];
    //titleLabel.font = [UIFont systemFontOfSize:fount];
    [titleView addSubview:titleLabel];
    

    
    return titleView;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+(NSMutableDictionary*)getPostDic
{
    NSMutableDictionary * postDic = [[NSMutableDictionary alloc]init];
    [postDic setObject:@"bbE0cMOoCmRJDnun8y9uqyR8C" forKey:@"token"];
    
    return postDic;

}

+(NSArray*)getStartImages:(float)number
{

    NSArray * starts = [[NSArray alloc]init];
//    NSLog(@"%f %f星好评",number,number/20);
    
    
    NSString * startImageName = @"startImage";
    NSString * halfStartImageName = @"startImage_half";
    NSString * grayStartImageName = @"startImage_gray";
    
    
    float startNum = number/20;
    if (startNum >= 4.5) {
        //五星
        starts = @[startImageName,startImageName,startImageName,startImageName,startImageName];
        
    }else if (startNum >= 4){
        //四星半
        starts = @[startImageName,startImageName,startImageName,startImageName,halfStartImageName];
        
    }else if (startNum >= 3.5){
        //四星
        starts = @[startImageName,startImageName,startImageName,startImageName,grayStartImageName];
        
        
    }else if (startNum >= 3){
        //三星半
        starts = @[startImageName,startImageName,startImageName,halfStartImageName,grayStartImageName];
        
    }else if (startNum >= 2.5){
        //三星
        starts = @[startImageName,startImageName,startImageName,grayStartImageName,grayStartImageName];
        
        
    }else if (startNum >= 2){
        //二星半
        starts = @[startImageName,startImageName,halfStartImageName,grayStartImageName,grayStartImageName];
        
        
    }else if (startNum >= 1.5){
        //二星
        starts = @[startImageName,startImageName,grayStartImageName,grayStartImageName,grayStartImageName];
        
        
    }else if (startNum >= 1){
        //一星半
        starts = @[startImageName,halfStartImageName,grayStartImageName,grayStartImageName,grayStartImageName];
        
        
    }else if(startNum >= 0.5){
        //半星
        starts = @[halfStartImageName,grayStartImageName,grayStartImageName,grayStartImageName,grayStartImageName];
        
    }else{
        //没星
        starts = @[grayStartImageName,grayStartImageName,grayStartImageName,grayStartImageName,grayStartImageName];
    }
    return starts;
}

+(NSDictionary*)changeDicSubType:(NSDictionary*)dic
{
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    
    for (NSString* key in mDic.allKeys) {
        
        id halo = [mDic objectForKey:key];
        if ([halo isKindOfClass:[NSNull class]]) {
            [mDic setObject:@"" forKey:key];
        }
    }
    
    return mDic;
}

+(NSArray*)getFormatRechargeData:(NSArray*)ary
{
    //分出来月份
    //所有的数据 
  
    NSMutableArray * formatMary = [[NSMutableArray alloc]init];
    for (NSDictionary * d in ary) {
        
        //把日期提取出来 yyyy-mm
        NSString * status = [d objectForKey:@"time_create"];
        status = [status substringToIndex:7];
        
        if (formatMary.count >0) {
            //有数据 循环遍历
            
            //判断是否已经加进去的值
            BOOL isOk = false;
            for (NSMutableDictionary * dataMdic in formatMary) {
                
                NSString * justTime = [dataMdic objectForKey:@"time"];
                
                //如果有这个日期的数据 就把当前的这个数据加到此日期里面
                if ([status isEqualToString:justTime]) {
                    NSMutableArray * typeAry = [dataMdic objectForKey:@"datas"];
                    [typeAry addObject:d];
                    
                    [dataMdic setObject:typeAry forKey:@"datas"];
                    
                    isOk = YES;
                }
            }
            
            //如果没有一样的日期 就创建一个
            if (!isOk) {
                NSMutableDictionary * dataMdic = [[NSMutableDictionary alloc]init];
                NSMutableArray * typeAry = [[NSMutableArray alloc]init];
                
                [typeAry addObject:d];
                
                [dataMdic setObject:status forKey:@"time"];
                [dataMdic setObject:typeAry forKey:@"datas"];
                
                [formatMary addObject:dataMdic];
            }
            
        }else{
            //没有数据 创建一个
            NSMutableDictionary * dataMdic = [[NSMutableDictionary alloc]init];
            
            NSMutableArray * typeAry = [[NSMutableArray alloc]init];
            [typeAry addObject:d];
            
            [dataMdic setObject:status forKey:@"time"];
            [dataMdic setObject:typeAry forKey:@"datas"];
            
            [formatMary addObject:dataMdic];
        }
    }

        return formatMary;
}

+(NSString*)getBrandWithBrandId:(int)brandId
{
    NSString * brandName;
    
    
    NSArray * brands = [MyPreference getBrandList];

    return brandName;

}
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    
    // Get the new image from the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    // End the context
    
    UIGraphicsEndImageContext();
    
    
    // Return the new image.
    
    return newImage;

}

+(BOOL)isMoney:(NSString*)money
{
    
    NSCharacterSet *cs;
    NSInteger location =  money.length;
    NSUInteger nDotLoc = [money rangeOfString:@"."].location;
    
    if (NSNotFound == nDotLoc && 0 != location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
    }
    NSString *filtered = [[money componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [money isEqualToString:filtered];
    if (!basicTest) {
        
        //[self showMyMessage:@"只能输入数字和小数点"];
        NSLog(@"只能输入数字和小数点");
        return NO;
    }
    if (NSNotFound != nDotLoc && location > nDotLoc + 3) {
        //[self showMyMessage:@"小数点后最多三位"];
        NSLog(@"小数点后最多三位");
        return NO;
    }
    return YES;
}


+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
@end
