//
//  FirstViewController.m
//  iRefuel
//
//  Created by 刘亚杰Kamas on 15/4/16.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "FirstViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommonUtil.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "MBProgressHUD.h"
#import "CommonUtil.h"
#import "payRequsestHandler.h"

//微信相关数据
#define kWXAppID @"wx920a184018cc7654"
#define kWXAppSecret @"1ce56c3e71ff076f6f78ce5e845449e6"
#define kWXPartnerKey @"mycar2014sensestrong201194118435"

//微信公众平台商户模块生成的ID
#define kWXPartnerId  @"1237619902"


@interface FirstViewController ()<MBProgressHUDDelegate>
{
    //微信相关--------------
    NSString * payCode; //从服务器获取的支付编号
    
    NSString * WXaccessToken;//微信支付从服务器获取的Token
    NSString * WXprepayid; //第二次从微信服务器获取的id
    
    //微信支付的一些参数
    
    //时间戳,为 1970 年 1 月 1 日 00:00 到请求发起时间的秒 数
    NSString * WXtimeStamp;
    
    //32位内的随机串,防重发
    NSString *WXnonceStr;
    
    //商家对用户的唯一标识,如果用微信 SSO,此处建议填写 授权用户的 openid
    NSString *WXtraceId;
    NSString *WXpackage;
    
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)test:(id)sender {
    
    //[self OldWeiChatPay];
    [self newWeiChatPay];
}



#pragma mark NewWeiChatPay
-(void)newWeiChatPay
{
    
    //首先请求服务器 发送金额和商品描述
    //TUDO 接口还没更新
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parameters = @{@"type": @"recharge",
                                 @"amount":@"1",
                                 @"user_id":@"007"};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager POST:@"http://www.jiayoucar.com/api/order/create" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dataDic = responseObject;
        
        if ([[dataDic objectForKey:@"status"]longValue] == 200) {
            
            //服务器返回成功
            NSLog(@"ok!");
           
            [CommonUtil showHUD:@"服务器返回成功" delay:2.0 withDelegate:self];

            
            NSDictionary * content = [dataDic objectForKey:@"content"];
            
            //保存订单号 签名算法的时候要使用
            payCode = [content objectForKey:@"order_id"];
            
   
            //开始调用统一下单的微信接口
            [self WeiChatUnifiedorder:[content objectForKey:@"order_id"] andTotal:[content objectForKey:@"total"] andIp:[content objectForKey:@"user_ip"]];
            
        }else{
            //服务器返回失败
            
            [CommonUtil showHUD:@"服务器返回失败" delay:2.0 withDelegate:self];
        }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure = %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
-(void)WeiChatUnifiedorder:(NSString*)orderId andTotal:(NSString*)total andIp:(NSString*)ipStr
{
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    /*
//      金额
//      订单号
//      商品描述
//      回调地址
//      终端ip
//      32位随机码
//      签名算法
//     */
//    
////    [self genNonceStr]; //32位随机码
////    [self genPackage]; //签名算法
////    [self genSign:nil];
//    
//    
//    
//    NSDictionary * parame = @{@"total_fee":[NSNumber numberWithInt:[total intValue]],
//                              @"out_trade_no":orderId,
//                              @"body":@"我是商品描述",
//                              @"notify_url":@"http://www.jiayoucar.com/web/wepay/demo/notify_url.php",
//                              @"spbill_create_ip":ipStr,
//                              @"nonce_str":[self genNonceStr],
//                              @"sign":[self genPackage]};
//    
//    //[self getUnifiedorderXml:parame];
//    NSLog(@"%@",[self getUnifiedorderXml:parame]);
//    
//    
//    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:[self getUnifiedorderXml:parame] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@",responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//        
//    }];
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:@{@"orderId":orderId,
                                                    @"total":total,
                                                    @"ip":ipStr}];
    
    
    

}

-(void)NewWeiChatPayGo
{
    //调用微信支付接口开始支付
    PayReq * req = [[PayReq alloc]init];
    
    req.openID = kWXAppID;
    req.partnerId = kWXPartnerId;
    //req.prepayId = WXprepayid;
    req.package = @"Sign=WXPay";
    req.nonceStr = WXnonceStr;
    req.timeStamp = [WXtimeStamp intValue];
    //req.sign = nil;
    
    [WXApi sendReq:req];
    
}
#pragma mark OldWeiChatPay
//获取订单号
-(void)OldWeiChatPay
{
    NSString * urlStr = @"http://www.jiayoucar.com/api/order/create";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // type=[consume/recharge]
    NSDictionary *parameters = @{@"type": @"recharge"};
    
    
    //TODO 等待菊花
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[(NSDictionary*)responseObject objectForKey:@"status"]longValue] == 200) {
            NSLog(@"ok!");
            NSLog(@"order: %@",[[(NSDictionary*)responseObject objectForKey:@"content"]objectForKey:
                                @"order_id"]);
            
            payCode = [[(NSDictionary*)responseObject objectForKey:@"content"]objectForKey:
                       @"order_id"];
            NSLog(@"payCodeOk!");
            
            [self WXPay];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSLog(@"- %@",error);
    }];
}


-(void)WXPay
{
    //微信支付第一步
    NSString *strUrl = @"https://api.weixin.qq.com/cgi-bin/token";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"appid": kWXAppID,
                                 @"secret":kWXAppSecret,
                                 @"grant_type":@"client_credential"};
    
    [manager POST:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * WXdic = responseObject;
        if (WXdic) {
            WXaccessToken = [WXdic objectForKey:@"access_token"];
            [self WXPrepay];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure!");
        
    }];
}
-(void)WXPrepay
{
    //微信支付第二步
    NSLog(@"WXPrepay");
    NSMutableData *postData = [self getProductArgs];
    
    
    NSString *strUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?&access_token=%@",WXaccessToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    
    
    [manager POST:strUrl parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"ok!!");
        NSDictionary * sectionDic = responseObject;
        if (sectionDic) {
            
            WXprepayid = [sectionDic objectForKey:@"prepayid"];
            
            if (WXprepayid) {
                [self WXRealPay];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure!!");
        NSLog(@"%@",error);
    }];
    
    
    

}

-(void)WXRealPay
{
    //微信支付第三步
    
    //构造支付请求
    PayReq *request = [[PayReq alloc]init];
    request.partnerId = kWXPartnerId;
    request.prepayId = WXprepayid;
    request.package = @"Sign=WXPay";
    request.nonceStr = WXnonceStr;
    request.timeStamp = [WXtimeStamp intValue];
    
    //构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kWXAppID forKey:@"appid"];
    [params setObject:@"" forKey:@"appkey"];
    [params setObject:request.nonceStr forKey:@"noncestr"];
    [params setObject:request.package forKey:@"package"];
    [params setObject:request.partnerId forKey:@"partnerid"];
    [params setObject:request.prepayId forKey:@"prepayid"];
    [params setObject:WXtimeStamp forKey:@"timestamp"];
    request.sign = [self genSign:params];
    
    [WXApi sendReq:request];

}

#pragma mark - 微信用到的一些方法
/*
 app_signature 生成方法:  [self genSign:params]
 A)参与签名的字段包括:appid、appkey、noncer、package、timestamp 以及 traceid
 B)对所有待签名参数按照字段名的 ASCII 码从小到大排序(字典序)后,使用 URL 键值对的 格式(即 key1=value1&key2=value2...)拼接成字符串 string1。 注意:所有参数名均为小写字符
 C)对 string1 作签名算法,字段名和字段值都采用原始值,不进行 URL 转义。具体签名算法 为 SHA1
 */
- (NSMutableData *)getProductArgs
{
    WXtimeStamp = [self genTimeStamp];
    WXnonceStr =  [self genNonceStr]; //32位随机码
    // traceId 由开发者自定义，可用于订单的查询与跟踪，建议根据支付用户信息生成此id
    WXtraceId = [self genTraceId];
    WXpackage = [self genPackage];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kWXAppID forKey:@"appid"];
    [params setObject:@"" forKey:@"appkey"];
    [params setObject:WXnonceStr forKey:@"noncestr"];
    [params setObject:WXtimeStamp forKey:@"timestamp"];
    [params setObject:WXtraceId forKey:@"traceid"];
    [params setObject:WXpackage forKey:@"package"];
    [params setObject:[self genSign:params] forKey:@"app_signature"];
    [params setObject:@"sha1" forKey:@"sign_method"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    //NSLog(@"--- ProductArgs: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    return [NSMutableData dataWithData:jsonData];
    
}

//MARK: 时间戳
- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

/**
 * 注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

- (NSString *)genOutTradNo
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

//MARK: 建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪

- (NSString *)genTraceId
{
    return [NSString stringWithFormat:@"crestxu_%@", [self genTimeStamp]];
}

//MARK: 注意:不能hardcode在客户端,建议genPackage这个过程都由服务器端完成
- (NSString *)genPackage{
    // 构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"WX" forKey:@"bank_type"];
    [params setObject:@"我是商品描述" forKey:@"body"];
    [params setObject:@"1" forKey:@"fee_type"];
    [params setObject:@"UTF-8" forKey:@"input_charset"];
    [params setObject:@"http://www.jiayoucar.com/web/wepay/demo/notify_url.php" forKey:@"notify_url"];
    [params setObject:payCode forKey:@"out_trade_no"]; //订单号
    [params setObject:kWXPartnerId forKey:@"partner"];
    [params setObject:[CommonUtil getIPAddress:YES] forKey:@"spbill_create_ip"];
    
    //金额 单位是分
    //float WXmoeny = [self.money_tf.text floatValue] * 100;
    float WXmoeny = 1;
    [params setObject:[NSString stringWithFormat:@"%g",WXmoeny] forKey:@"total_fee"];
    
    
    NSArray *allKeys =nil;
    allKeys = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        NSComparisonResult comRes = [str1 compare:str2 ];
        return comRes;
    }];
    
    
    // 生成 packageSign
    NSMutableString *package = [NSMutableString string];
    for (NSString *key in allKeys) {
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[params objectForKey:key]];
        [package appendString:@"&"];
    }
    [package appendString:@"key="];
    
    [package appendString:kWXPartnerKey];
    
    // 进行md5摘要前,params内容为原始内容,未经过url encode处理
    NSString *packageSign = [[CommonUtil md5:[package copy]] uppercaseString];
    package = nil;
    
    
    // 生成 packageParamsString
    NSString *value = nil;
    package = [NSMutableString string];
    for (NSString *key in allKeys) {
        [package appendString:key];
        [package appendString:@"="];
        value = [params objectForKey:key];
        
        // 对所有键值对中的 value 进行 urlencode 转码
        value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
        
        [package appendString:value];
        [package appendString:@"&"];
    }
    
    NSString *packageParamsString = [package substringWithRange:NSMakeRange(0, package.length - 1)];
    
    NSString *result = [NSString stringWithFormat:@"%@&sign=%@", packageParamsString, packageSign];
    //
    //    NSLog(@"--- Package: %@", result);
    return result;
    
}

//MARK: sign
- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    NSString *result = [CommonUtil sha1:signString];
    //NSLog(@"--- Gen sign: %@", result);
    return result;
}

#pragma mark WXDelegate
-(void)WXDelegate:(NSNotification *)notification
{
    BaseResp * resp = notification.object;
    
    
    NSDictionary * infoDic;
    //-2未支付
    //-0 支付成功
    if (resp.errCode == 0) {
        //支付成功
        
        infoDic = @{@"dingdanNum":payCode,
                    @"payName":@"微信",
                    @"name":@"ThisIsName",
                    @"payState":@"101",
                    @"moneyNum":@"0.01"};
        
        
    }else if (resp.errCode == -2){
        //未支付
        
        infoDic = @{@"dingdanNum":payCode,
                    @"payName":@"微信",
                    @"name":@"ThisIsName",
                    @"payState":@"102",
                    @"moneyNum":@"0.01"};
        
    }else{
        //支付失败
        
        //[myErrorView addMainTitle:@"提示" content:@"支付失败" button1Title:@"" button1Taget:nil button1Sel:nil button2Title:@"" button2Taget:nil button2Sel:nil delayTime:2.0];
        NSLog(@"支付失败");
        return ;
        
    }
    

    
    
}

-(NSString*)getUnifiedorderXml:(NSDictionary*)parame
{
    
    NSString * xmlStr = @"<xml>";
    for (NSString * key in parame.allKeys) {
        
        xmlStr = [NSString stringWithFormat:@"%@ <%@>%@</%@>",xmlStr,key,[parame objectForKey:key],key];
    }
    xmlStr = [NSString stringWithFormat:@"%@ </xml>",xmlStr];
    
    return xmlStr;
}

@end
