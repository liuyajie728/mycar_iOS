//
//  DealDetailViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/18.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "DealDetailViewController.h"
#import "CommonUtil.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"


@implementation DealDetailTopCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end

@implementation DealDetailContentCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end


@interface DealDetailViewController ()<UIGestureRecognizerDelegate>
{
    NSArray * s2;
    NSArray * s3;
    
    NSDictionary * content;
    
    NSArray * data1;
    NSArray * data2;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation DealDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"交易详情" andFount:18 andTitleColour:TitleColor];
    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"clockicon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.myTableView.tableFooterView = [self getTableViewFootView];
    
//    NSLog(@"%@",self.transactionInfo);
    [self requstDealInfo];
    
    s2 = @[@"订单号",@"创建时间",@"支付时间"];
    s3 = @[@"付款方式",@"付款金额"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"%@",self.transactionInfo);

}
-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requstDealInfo
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * postDic = [CommonUtil getPostDic];
    
    [postDic setObject:[self.transactionInfo objectForKey:@"user_id"] forKey:@"user_id"];
    [postDic setObject:[self.transactionInfo objectForKey:@"order_id"] forKey:@"order_id"];

    
    [manager POST:[NSString stringWithFormat:@"%@/order/consume",MyHTTP] parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //TODO 应该合理的把这个保存起来
        NSDictionary * dataDic = responseObject;
        if ([[dataDic objectForKey:@"status"]longValue] == 200) {
            content =  [dataDic objectForKey:@"content"];
            
            
            //订单号
            NSString * dingdan = [content objectForKey:@"payment_id"];
            
            //创建时间
            NSString * chuanjianTime = [content objectForKey:@"time_create"];
            
            //支付时间
            NSString * zhifuTime = [content objectForKey:@"time_payed"];
            if ([zhifuTime isKindOfClass:[NSNull class]]) {
                zhifuTime = @"";
            }
            
            data1 = @[dingdan,chuanjianTime,zhifuTime];
            
            //付款方式 TODO
            NSString * fukuanType;
            if (![[content objectForKey:@"payment_type"] isKindOfClass:[NSNull class]]) {
                int payment_type = [[content objectForKey:@"payment_type"]intValue];
                if (payment_type == 0) {
                    fukuanType = @"全部使用余额";
                }else if (payment_type == 1){
                    fukuanType = @"全部使用微信";
                }else if (payment_type == 2){
                    fukuanType = @"部分余额 部分微信";
                }else if (payment_type == 3){
                    fukuanType = @"全部使用支付宝";
                }else if (payment_type == 4){
                    fukuanType = @"部分余额 部分支付宝";
                }
            }
           
            
            
            
            //付款金额
            NSString * payNum = [content objectForKey:@"amount"];
            
            data2 = @[fukuanType,payNum];
            
            [self.myTableView reloadData];
            
        }else{
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(UIView*)getTableViewFootView
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 30)];
    footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    UIButton * footViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footViewBtn.frame = CGRectMake(20, 0, LCDW - 40, 30);
    footViewBtn.backgroundColor = BgBlueColor;
    [footViewBtn setTitle:@"添加评论" forState:UIControlStateNormal];
    footViewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [footViewBtn addTarget:self action:@selector(clickFootViewBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:footViewBtn];
    
    
    return footView;
}
-(void)clickFootViewBtn
{
    [self performSegueWithIdentifier:@"appraise" sender:nil];
}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return s2.count;
    }else if (section == 2){
        return s3.count;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 86;
    }else{
        return 44;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        static NSString *CellIdentifier = @"TopCell";
        DealDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DealDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.section == 3){
        //评论内容
        
    
    }else{
        
        static NSString *CellIdentifier = @"ContentCell";
        DealDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DealDetailContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 1) {
            cell.leftLabel.text = s2[indexPath.row];
            
            if (data1) {
                cell.rightLabel.text = data1[indexPath.row];
            }
            
        }else if (indexPath.section == 2){
            cell.leftLabel.text = s3[indexPath.row];
            
            if (data2) {
                cell.rightLabel.text = data2[indexPath.row];
            }
            
            if ([s3[indexPath.row] isEqualToString:@"付款金额"]) {
                //针对付款金额调大字体
                cell.leftLabel.textColor = cellTxtColor;
                cell.leftLabel.font = [UIFont systemFontOfSize:16];
                
                // 右边的字体
                cell.rightLabel.textColor = cellTxtColor;
                cell.rightLabel.font = [UIFont systemFontOfSize:16];
            }else{
               //恢复字体大小
                
                cell.leftLabel.textColor = grayTxtColor;
                cell.leftLabel.font = [UIFont systemFontOfSize:14];
                
             
                cell.rightLabel.textColor = cellTxtColor;
                cell.rightLabel.font = [UIFont systemFontOfSize:16];
            }
        }
        return cell;
    }
    return nil;
}

@end
