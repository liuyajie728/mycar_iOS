//
//  MyViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/11.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "MyViewController.h"
#import "CommonUtil.h"
#import "AppDelegate.h"
#import "RechargeAndBalanceViewController.h"
#import "MyPreference.h"

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * s1;
    NSArray * s2;
    NSArray * s3;
    
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"我的" andFount:18 andTitleColour:TitleColor];
    
    
    //初始化数据数组
    s1 = @[@"余额 充值记录",@"交易记录"];
    s2 = @[@"待点评",@"最新活动"];
    s3 = @[@"设置"];
    
    
    //nav右边按钮 TODO 要用自定义的or改个颜色
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(RightBarAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:102/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    
    //设置tableView没有弹性
    self.myTableView.bounces = NO;
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)RightBarAction
{
    NSLog(@"+++");
}


#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1 ){
        return s1.count;
    }else if (section == 2){
        return s3.count;
    }else if(section == 3){
        //return s3.count;
    }
    
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 84;
    }else{
        return 44;
    }
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 40;
//    }
//    return 20;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        //头像
        UIImageView * headView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 8, 68, 68)];
        headView.backgroundColor = [UIColor redColor];
        headView.tag = 102;
        [cell.contentView addSubview:headView];
        
        //设置用户信息
        NSDictionary * userInfo = [MyPreference getLoginInfo];
        
        
        UILabel * nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(headView.frame.origin.x + headView.frame.size.width + 10, 20, 140, 22)];
        nameLabe.backgroundColor = [UIColor clearColor];
        nameLabe.text = [userInfo objectForKey:@"nickname"];
        nameLabe.textColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1];
        nameLabe.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:nameLabe];
        
        UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(headView.frame.origin.x + headView.frame.size.width + 10, 20+22, 140, 22)];
        phoneLabel.backgroundColor = [UIColor clearColor];
        phoneLabel.text = [userInfo objectForKey:@"mobile"];
        phoneLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        phoneLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:phoneLabel];
        
        
    }else if(indexPath.section == 1){
    
        cell.textLabel.text = s1[indexPath.row];
        cell.textLabel.textColor = cellTxtColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.imageView.image = [UIImage imageNamed:@"clockicon.png"];
    }else if (indexPath.section == 2){
        cell.textLabel.text = s3[indexPath.row];
        cell.textLabel.textColor = cellTxtColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.imageView.image = [UIImage imageNamed:@"clockicon.png"];
    }else if (indexPath.section == 3){
//        cell.textLabel.text = s3[indexPath.row];
//        cell.textLabel.textColor = cellTxtColor;
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.imageView.image = [UIImage imageNamed:@"clockicon.png"];
    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //self.hidesBottomBarWhenPushed = YES;
    if (indexPath.section == 0) {
        //头像
        
        [self performSegueWithIdentifier:@"myInfo" sender:self];
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            //余额 充值记录
             //[self performSegueWithIdentifier:@"Balance" sender:self];
            //self.hidesBottomBarWhenPushed = YES;
            RechargeAndBalanceViewController * rechargeVc = [[RechargeAndBalanceViewController alloc]init];
            rechargeVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rechargeVc animated:YES];
            
        }else if (indexPath.row == 1){
            //交易记录
            [self performSegueWithIdentifier:@"TransactionRecord" sender:self];
        }
        
    
    }else if (indexPath.section == 2){
        //设置
        [self performSegueWithIdentifier:@"Setting" sender:self];
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
