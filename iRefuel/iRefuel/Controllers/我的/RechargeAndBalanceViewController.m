//
//  RechargeAndBalanceViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/14.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "RechargeAndBalanceViewController.h"
#import "CommonUtil.h"
#import "RechargeAndBalanceCell.h"




@interface RechargeAndBalanceViewController ()<UIGestureRecognizerDelegate>
{
    NSArray * moneySource;
    
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation RechargeAndBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //此viewController因为cell排版的特殊性 没有使用autolayout 所以要自己手动适应下
    //当前类用了xib
    CGRect frame = self.myTableView.frame;
    frame.size.width = LCDW;
    frame.size.height = LCDH - 64;
    frame.origin.y = 64;
    self.myTableView.frame = frame;
    
    NSLog(@" = %f",LCDH);
    
    //设置nav右边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"clockicon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //设置title
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"余额 充值记录" andFount:18 andTitleColour:TitleColor];
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.myTableView.tableHeaderView = [self getTableViewHeadView];
    
    
    [self settingDataSource];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingDataSource
{
    
    int money1 = arc4random()%99000+1000;
    int money2 = arc4random()%9+1000;
    int money3 = arc4random()%99+1000;
    
    moneySource = @[[NSString stringWithFormat:@"%d",money1],[NSString stringWithFormat:@"%d",money2],[NSString stringWithFormat:@"%d",money3]];
    [self.myTableView reloadData];
    
    
}
-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView*)getTableViewHeadView
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 72)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIView * topSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 20)];
    topSectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headView addSubview:topSectionView];
    
    
    //所有东西都加在contenView上就行
    UIView * downContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, LCDW, 52)];
    downContentView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel * headViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, 200, 20)];
    headViewLabel.text = @"余额: 100,100,100.00";
    headViewLabel.backgroundColor = [UIColor clearColor];
    [downContentView addSubview:headViewLabel];
    
    
    [headView addSubview:downContentView];
    
    return headView;
    
}




#pragma mark tableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 40)];
    v.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 150, 19)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"本月";
    [v addSubview:label];
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 20;
    //    }
    return 19;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    static NSString *CellIdentifier = @"RechargeAndBalanceCell";
//    RechargeAndBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[RechargeAndBalanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    
    
    RechargeAndBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RechargeAndBalanceCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RechargeAndBalanceCell" owner:self options:nil] lastObject];
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //左边 充值
    NSString * rechargeStr = [NSString stringWithFormat:@"充值 %@",moneySource[indexPath.row]];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(114,21);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelsize =  [rechargeStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    //NSLog(@" - %@",NSStringFromCGSize(labelsize));
    
    cell.leftTopLabel_lb.text = rechargeStr;
    CGRect frame = cell.leftTopLabel_lb.frame;
    frame.size = labelsize;
    cell.leftTopLabel_lb.frame = frame;
    
    //充值后面赠费按钮
    //TODO 判断是否有赠费
    
    if (indexPath.row != 0) {
        cell.zeng.hidden = NO;
        cell.zengNum.hidden = NO;
        
        //赠字的位置
        frame = cell.zeng.frame;
        frame.origin.x = cell.leftTopLabel_lb.frame.origin.x + cell.leftTopLabel_lb.frame.size.width + 6;
        cell.zeng.frame = frame;
        
        //赠钱数
        frame = cell.zengNum.frame;
        frame.origin.x = cell.zeng.frame.origin.x + cell.zeng.frame.size.width + 3;
        cell.zengNum.frame = frame;
        
        
        
    }else{
        cell.zeng.hidden = YES;
        cell.zengNum.hidden = YES;
    }
    
    return cell;
}


@end
