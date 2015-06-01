//
//  SelectedGenderViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/30.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "SelectedGenderViewController.h"
#import "CommonUtil.h"
#import "AFHTTPRequestOperationManager.h"
#import "MyPreference.h"

@interface SelectedGenderViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    NSArray * datas;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation SelectedGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"性别" andFount:18 andTitleColour:TitleColor];
    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //设置tableView没有弹性
    self.myTableView.bounces = NO;
    
    datas = @[@"女",@"男"];
    
    self.myTableView.tableFooterView = [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"genderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = datas[indexPath.row];
    if ([datas[indexPath.row] isEqualToString:self.gender]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary * mUserDic = [MyPreference getLoginInfo];
    NSString * gender;
    if (indexPath.row == 0) {
        gender = @"0";
    }else if (indexPath.row == 1){
        gender = @"1";
    }
    
    //发送请求
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * postDic = [CommonUtil getPostDic];
//    [postDic setObject:gender forKey:@"gender"];
    [postDic setObject:[mUserDic objectForKey:@"user_id"] forKey:@"user_id"];
    [postDic setObject:@"gender" forKey:@"column"];
    [postDic setObject:gender forKey:@"value"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:[NSString stringWithFormat:@"%@/user/update",MyHTTP] parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"%@",responseObject);
        NSDictionary * dataDic = responseObject;
        
        if ([[dataDic objectForKey:@"status"]longValue] == 200){
            
            //保存下来新的信息
            [mUserDic setObject:gender forKey:@"gender"];
            [MyPreference commitLoginInfo:mUserDic];
            
            //back
            [self.navigationController popViewControllerAnimated:YES];
        
        }else if ([[dataDic objectForKey:@"status"]longValue] == 400){
            [CommonUtil showHUD:[dataDic objectForKey:@"content"] delay:2.0f withDelegate:self];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CommonUtil showHUD:@"服务器出错,修改性别失败" delay:2.0f withDelegate:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
