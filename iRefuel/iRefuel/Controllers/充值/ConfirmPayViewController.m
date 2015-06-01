//
//  ConfirmPayViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/28.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "ConfirmPayViewController.h"
#import "CommonUtil.h"
#import "ConfirmView.h"
#import "MyPreference.h"
#import "AFHTTPRequestOperationManager.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"

@implementation confirmPayCell
@end


@interface ConfirmPayViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    //记录section的数量
    int sectionNum;
    
    //section中显示文字的内容
    NSString * sectionText;
    
    //记录选中cell是哪一个(没有余额支付的时候)
    int selecteedNum;
    
    //有余额的时候记录用哪个第三方来支付
    int thirdPrtyNum;
    
    //是否选用余额支付
    BOOL isYue;
    
    //图标
    NSArray * logos;
    
    //userBalance
    NSString * userBalance;
    
    //微信相关--------------
    NSString * payCode; //从服务器获取的支付编号
    
}

@end



@implementation ConfirmPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"消费订单确认" andFount:18 andTitleColour:TitleColor];
    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //首先获取一下用户最新余额
    [self requestUserInfo];
    
    thirdPrtyNum = -1;
    logos = @[@"weixinLogo"];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableViewHeadAndFootView
-(UIView*)getTableViewFootView
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 70)];
    footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(20, 10, LCDW - 40, 40);
    [okBtn addTarget:self action:@selector(clickOKBtn) forControlEvents:UIControlEventTouchUpInside];
    okBtn.backgroundColor = BgBlueColor;
    [okBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    
    [footView addSubview:okBtn];
    return footView;
}

-(void)clickOKBtn
{
    
    if (self.type == 1) {
        //充值
        //充值的话只使用第三方来完成
        
        //调用微信支付
        [self weixinPayWithMoney:self.payNum];
        
    }else if (self.type == 2){
        
    
    }
}
-(void)settingTableViewHeaderWithBalance:(NSString*)balance
{
//    NSLog(@"%@",balance);
    //userBalance = balance;
    userBalance = @"1000";
    NSString * text;
    //判断是从哪个界面进入
    if (self.type == 1) {
        
        text = [NSString stringWithFormat:@"您本次充值%@元，您希望采取哪种方式来支付?",self.payNum];
        
        //因为是充值 所以不用显示余额
        sectionNum = 1;
        
        //设置section的文字
        sectionText = @"请选择充值方式";
        
    }else if (self.type == 2){
    
        text = [NSString stringWithFormat:@"您的车辆正在%@进行加油，本次消费%@元，您希望如何进行支付",self.youzhanName,self.payNum];
        
        if (![balance isEqualToString:@"0.00"]) {
            //没有钱的情况下不显示余额
            
            //因为是充值 所以不用显示余额
            sectionNum = 1;
            
            //设置section的文字
            sectionText = @"请选择充值方式";

        }else{
            //有余额的情况下显示第三份充值
            
            //多一行显示余额
            sectionNum = 2;
            
            //设置section的文字
            sectionText = @"剩余金额选择方式";
        }
    }
    
    ConfirmView * headerView = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmView" owner:self options:nil] lastObject];
    headerView.myText_lb.text = text;
    headerView.moneyNum_lb.text = [NSString stringWithFormat:@"¥%@",self.payNum];
    self.myTableView.tableHeaderView = headerView;
    self.myTableView.tableFooterView = [self getTableViewFootView];
    
    [self.myTableView reloadData];
}

#pragma mark request
-(void)requestUserInfo{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * postDic = [CommonUtil getPostDic];
    
    NSDictionary * userInfo = [MyPreference getLoginInfo];
    [postDic setObject: [userInfo objectForKey:@"user_id"] forKey:@"user_id"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:[NSString stringWithFormat:@"%@/user",MyHTTP] parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"%@",responseObject);
        NSDictionary * dataDic = responseObject;
        
        if ([[dataDic objectForKey:@"status"]longValue] == 200)
        {
            [MyPreference commitLoginInfo:[dataDic objectForKey:@"content"]];
            
            
            //设置余额
//            headViewLabel.text = [NSString stringWithFormat:@"余额: %@",[[dataDic objectForKey:@"content"]objectForKey:@"balance"]];
            [self settingTableViewHeaderWithBalance:[[dataDic objectForKey:@"content"]objectForKey:@"balance"]];
            
        }else{
            [CommonUtil showHUD:@"服务器出错" delay:2.0f withDelegate:self];
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [CommonUtil showHUD:@"获取数据失败，请检查网络后重试" delay:2.0f withDelegate:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark tableViewDelegate

//自定义Section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (sectionNum == 1) {
        UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 40)];
        v.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(12, 20, 150, 19)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = sectionText;
        label.textColor = grayTxtColor;
        [v addSubview:label];
        
        return v;
        
    }else{
        
        if (section == 1) {
            UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 40)];
            v.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(12, 20, 150, 19)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:12];
            label.text = sectionText;
            label.textColor = grayTxtColor;
            [v addSubview:label];
            
            return v;
        }
    
    }
    
    
    return nil;
    
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio
{
    
    if (sectionNum == 1) {
        if (sectio == 0) {
            return 40;
        }
    }else if (sectionNum == 2){
        if (sectio == 1) {
            return 40;
        }
    }
    
    
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (sectionNum == 1) {
//        
//        return logos.count;
//        
//    }else if(sectionNum == 2){
//    
//        if (section == 0) {
//            return 1;
//        }else if (section == 1){
//            return 1;
//        }
//    }
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"confirmCell";
    confirmPayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[confirmPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (sectionNum == 2) {
        //有余额的情况
       
        
        
        if (indexPath.section == 0) {
            //余额
            
            cell.textLabel.text = @"您可以使用余额支付";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            
            //设置余额应该如何显示
            //判断余额
            float userBalanceFloat = [userBalance floatValue];
            float payNumFloat = [self.payNum floatValue];
            float cellYuE = userBalanceFloat - payNumFloat;
            
            if (cellYuE >=0) {
                //如果余额足够支付充值的钱数
                //这里就显示需要支付的钱数
                cell.money_label.text = [NSString stringWithFormat:@"¥%.2f",payNumFloat];
                
                //如果钱数足够 就不需要使用下面第三方的支付方式了
                if (!isYue) {
                   thirdPrtyNum = -1;
                }
              
            }else{
                //余额不够支付充值的钱数
                //这里就显示余额总共的钱数
                cell.money_label.text = [NSString stringWithFormat:@"¥%.2f",userBalanceFloat];
                
                //因为余额不够 第三方支付也要打钩
                thirdPrtyNum = 0;
            }
 
            //cell.money_label.text = [NSString stringWithFormat:@"¥%@",userBalance];
            if (!isYue) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }else if (indexPath.section == 1){
        
            //设置对勾效果
            if (indexPath.row == thirdPrtyNum) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            cell.imageView.image = [UIImage imageNamed:logos[indexPath.row]];
            cell.textLabel.text = @"微信支付";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            //设置钱数
            float money;
            if (isYue) {
                money = [self.payNum floatValue];
            }else{
                
               money = [self.payNum floatValue] - [userBalance floatValue];
                if (money <0) {
                    money = 0.00;
                }
            }
            cell.money_label.text = [NSString stringWithFormat:@"¥%2.f",money];
        }
    }else{
        
        //这是没有使用余额的情况
        
        //设置对勾效果
        if (indexPath.row == selecteedNum) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.imageView.image = [UIImage imageNamed:logos[indexPath.row]];
        cell.textLabel.text = @"微信支付";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        //设置钱数
        cell.money_label.text = [NSString stringWithFormat:@"¥%@",self.payNum];
    
    }
    
    

    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selecteedNum = (int)indexPath.row;
    
    
    if (sectionNum == 2) {
        if (indexPath.section == 0) {
            isYue = !isYue;
            
            thirdPrtyNum = 0;
        }
    }
    
    [tableView reloadData];
}


#pragma mark WeiXinPay
-(void)weixinPayWithMoney:(NSString*)payMoney
{
    
    NSDictionary * userDic = [MyPreference getLoginInfo];
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * postDic = [CommonUtil getPostDic];
    
    [postDic setObject:@"consume" forKey:@"type"];
    [postDic setObject:[userDic objectForKey:@"user_id"] forKey:@"user_id"];
    [postDic setObject:@"192.168.1.1" forKey:@"user_ip"];
    [postDic setObject:@"100" forKey:@"total"];
    

   [manager POST:[NSString stringWithFormat:@"%@/order/create",MyHTTP] parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
       NSLog(@"%@",responseObject);
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
       
   }];
    
    
    
    
    //TODO获取服务器订单号
//    payCode = @"001122334455";
//    [self WeiChatUnifiedorder:payCode andTotal:@"测试" andIp:@"192.168.1.1" andMoney:@"100"];
    
}

-(void)WeiChatUnifiedorder:(NSString*)orderId andTotal:(NSString*)total andIp:(NSString*)ipStr andMoney:(NSString*)money
{
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    
    //设置密钥
    [req setKey:PARTNER_ID];
    

    NSDictionary * payDic = @{@"payTitle":@"微信充值",
                              @"total":money,
                              @"orderId":orderId,
                              @"ip":ipStr};
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:payDic];

    if (dict) {
        
        //调用微信支付接口开始支付
        PayReq * req = [[PayReq alloc]init];
        
        
        req.openID =  [dict objectForKey:@"appid"];
        req.partnerId = [dict objectForKey:@"partnerid"];
        req.prepayId = [dict objectForKey:@"prepayid"];
        req.package = [dict objectForKey:@"package"];
        req.nonceStr = [dict objectForKey:@"noncestr"];
        req.timeStamp = [[dict objectForKey:@"timestamp"] intValue];
        req.sign = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }else{
        //错误提示
        NSString *debug = [req getDebugifo];
        NSLog(@"%@\n\n",debug);
    }
}

//MARK: 时间戳
- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
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

@end
