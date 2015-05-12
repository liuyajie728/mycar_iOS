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

@interface MyViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"我的" andFount:18 andTitleColour:[UIColor colorWithRed:102/255.0 green:204/255.0 blue:255/255.0 alpha:1]];
    
    //self.myTableView.tableHeaderView = [self getTableViewHead];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)getTableViewHead
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 50)];
    headView.backgroundColor = [UIColor redColor];

    
    return headView;
}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1 || section == 2){
        return 2;
    }else if(section == 3){
        return 1;
    }
    
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
    
    
    if (indexPath.section == 0) {
        //头像
        UIImageView * headView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 8, 68, 68)];
        headView.backgroundColor = [UIColor redColor];
        headView.tag = 102;
        [cell.contentView addSubview:headView];
        
        UILabel * nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(headView.frame.origin.x + headView.frame.size.width + 10, 20, 140, 22)];
        nameLabe.backgroundColor = [UIColor clearColor];
        nameLabe.text = @"嘻嘻呼呼哈哈";
        nameLabe.textColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1];
        nameLabe.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:nameLabe];
        
        UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(headView.frame.origin.x + headView.frame.size.width + 10, 20+22, 140, 22)];
        phoneLabel.backgroundColor = [UIColor clearColor];
        phoneLabel.text = @"电话: 13000000000";
        phoneLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        phoneLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:phoneLabel];
        
        
    }else{
        
         cell.textLabel.text = @"123";
    }
    
   
    
    return cell;
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
