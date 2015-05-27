//
//  TransactionRecordViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/14.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "TransactionRecordViewController.h"
#import "CommonUtil.h"
#import "AFHTTPRequestOperationManager.h"
#import "MyPreference.h"
#import "UIImageView+WebCache.h"
#import "DealDetailViewController.h"

@implementation TransactionCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end



@interface TransactionRecordViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    NSArray * dataAry;
    NSDictionary * segueDic; //传值需要的Dic
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation TransactionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"交易记录" andFount:18 andTitleColour:TitleColor];
    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"clockicon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //请求api
    [self requestData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma maek request
-(void)requestData
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * postDic = [CommonUtil getPostDic];

    NSDictionary * userInfo = [MyPreference getLoginInfo];
    [postDic setObject: [userInfo objectForKey:@"user_id"] forKey:@"user_id"];
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:[NSString stringWithFormat:@"%@/order/consume",MyHTTP] parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"%@",responseObject);
        NSDictionary * dataDic = responseObject;
        
        if ([[dataDic objectForKey:@"status"]longValue] == 200){
            
            dataAry = [dataDic objectForKey:@"content"];
            [self.myTableView reloadData];
            
        }else if([[dataDic objectForKey:@"status"]longValue] == 400){
            
            [CommonUtil showHUD:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"content"]] delay:2.0f withDelegate:self];
            
        }else if ([[dataDic objectForKey:@"status"]longValue] == 401){
            
            [CommonUtil showHUD:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"content"]] delay:2.0f withDelegate:self];
        }
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CommonUtil showHUD:@"获取数据失败，请检查网络后重试" delay:2.0f withDelegate:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    

}
#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    transactionCell

    static NSString *CellIdentifier = @"transactionCell";
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TransactionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * dic = dataAry[indexPath.row];
    
    //TODO 还要显示品牌
    cell.nameLabel.text = [dic objectForKey:@"station_name"];
    cell.timeLabel.text = [dic objectForKey:@"time_create"];
    cell.zhifuLabel.text = [NSString stringWithFormat:@"支付额:￥%@",[dic objectForKey:@"amount"]];

    [cell.cellImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"station_image_url"]] placeholderImage:nil];
    

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    segueDic = dataAry[indexPath.row];
     [self performSegueWithIdentifier:@"transactionDeal" sender:self];
}
#pragma mark storybord
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"transactionDeal"]) {
       //详情
//        RevampViewController * send = segue.destinationViewController;
//        send.myType = revampType;
        
        DealDetailViewController * send = segue.destinationViewController;
        send.transactionInfo = segueDic;
        
    }
    
}


@end
