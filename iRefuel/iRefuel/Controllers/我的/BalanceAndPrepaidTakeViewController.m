//
//  BalanceAndPrepaidTakeViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/13.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "BalanceAndPrepaidTakeViewController.h"
#import "CommonUtil.h"

@implementation balanceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


@interface BalanceAndPrepaidTakeViewController ()<UIGestureRecognizerDelegate>
{

}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation BalanceAndPrepaidTakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    
}
-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 40)];
    v.backgroundColor = [UIColor orangeColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 150, 19)];
    label.backgroundColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"本月";
    [v addSubview:label];
    
    return v;
}

#pragma mark tableViewDelegate
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44;
//}

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
    
    static NSString *CellIdentifier = @"Cell";
    balanceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[balanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //cell.textLabel.text = @"222";
    int money = arc4random()%(100000*(indexPath.row+1));
    
    NSString * s = [NSString stringWithFormat:@"充值 %d",money];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(114,21);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelsize =  [s boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    NSLog(@" - %@",NSStringFromCGSize(labelsize));
    
    cell.leftTopLabel_lb.text = s;
    cell.leftTopLabel_lb.backgroundColor = [UIColor redColor];
    
    CGRect frame = cell.leftTopLabel_lb.frame;
    frame.size = labelsize;
    cell.leftTopLabel_lb.frame = frame;
    NSLog(@" + %@",NSStringFromCGRect(cell.leftTopLabel_lb.frame));
    


    
    
    
    return cell;
}


@end
