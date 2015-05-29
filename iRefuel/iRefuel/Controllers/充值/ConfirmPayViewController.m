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

@implementation confirmPayCell
@end


@interface ConfirmPayViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    //记录section的数量
    int sectionNum;
    
    //section中显示文字的内容
    NSString * sectionText;
    
    //记录选中cell是哪一个
    int selecteedNum;
    
    //是否选用余额支付
    BOOL isYue;
    
    //图标
    NSArray * logos;
    
    //userBalance
    NSString * userBalance;
    
    
}

@end

@implementation ConfirmPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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

-(UIView*)getTableViewFootView
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 50)];
    footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(20, 10, LCDW - 40, 30);
    [okBtn addTarget:self action:@selector(clickOKBtn) forControlEvents:UIControlEventTouchUpInside];
    okBtn.backgroundColor = BgBlueColor;
    [okBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    
    [footView addSubview:okBtn];
    return footView;
}

-(void)clickOKBtn
{


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
        
        if (indexPath.section == 0) {
            
            cell.textLabel.text = @"您可以使用余额支付";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            
            //判断余额
            
            float userBalanceFloat = [userBalance floatValue];
            float payNumFloat = [self.payNum floatValue];
            
            float cellYuE = userBalanceFloat - payNumFloat;
            
            if (cellYuE >=0) {
                cell.money_label.text = [NSString stringWithFormat:@"¥%.2f",cellYuE];
            }else{
                cell.money_label.text = [NSString stringWithFormat:@"¥%.2f",userBalanceFloat];
            }
 
            cell.money_label.text = [NSString stringWithFormat:@"¥%@",userBalance];
            if (!isYue) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }else if (indexPath.section == 1){
        
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
    [tableView reloadData];
    
    if (sectionNum == 2) {
        if (indexPath.section == 0) {
            isYue = !isYue;
        }
    }
}
@end
