//
//  GasStationDetailViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/19.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "GasStationDetailViewController.h"
#import "CommonUtil.h"

@implementation GasStationCell



@end



@interface GasStationDetailViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray * dataAry;

}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation GasStationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"油站详情" andFount:18 andTitleColour:TitleColor];
    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"clockicon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    self.myTableView.estimatedRowHeight = 80;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    
    dataAry = @[@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",@"bbbbbbbbbbbbbb",@"cccccccccccccccccccccccccccccccccc",@"dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",@"eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",@"fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",@"ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@" = %@",self.codeSrt);
}

-(void)backBtn:(UIButton*)send
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark tableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //内容的高度
//    //算出label的高度
//    
//    NSString * rechargeStr = dataAry[indexPath.row];
//    
//    CGSize labelSize = CGSizeZero;
//    UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
//
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    NSDictionary *attributes = @{NSFontAttributeName:labelFont, NSParagraphStyleAttributeName:paragraphStyle.copy};
//    labelSize =  [rechargeStr boundingRectWithSize:CGSizeMake(232, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    
//    return 50;
//}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GasStationCell";
    GasStationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GasStationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.myCellContentLabel.text = dataAry[indexPath.row];
    

    
    return cell;
}

//通过内容算出Cell留言的高度
-(CGFloat)getContentTextLabel:(NSString*)contentText
{
    

    return 70;
}

@end
