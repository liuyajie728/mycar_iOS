//
//  DealDetailViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/18.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "DealDetailViewController.h"
#import "CommonUtil.h"


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
    
    
    s2 = @[@"订单号",@"创建时间",@"支付时间"];
    s3 = @[@"付款方式",@"付款金额"];
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
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 30)];
    footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    UIButton * footViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footViewBtn.frame = CGRectMake(LCDW - (75+16), 0, 80, 26);
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
        
    }else{
        
        static NSString *CellIdentifier = @"ContentCell";
        DealDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DealDetailContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 1) {
            cell.leftLabel.text = s2[indexPath.row];
            
        }else if (indexPath.section == 2){
            cell.leftLabel.text = s3[indexPath.row];
            
            
            if ([s3[indexPath.row] isEqualToString:@"付款金额"]) {
                //针对付款金额调大字体
                cell.leftLabel.textColor = cellTxtColor;
                cell.leftLabel.font = [UIFont systemFontOfSize:16];
                
                //TODO 右边的字体
                
            }
        }
        return cell;
    }
    return nil;
}

@end
