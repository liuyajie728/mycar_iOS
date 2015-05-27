//
//  GasStationDetailViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/19.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "GasStationDetailViewController.h"
#import "CommonUtil.h"
#import "StationDetailTableViewCell.h"

@implementation GasStationCell


@end



@interface GasStationDetailViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray * dataAry;

}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) StationDetailTableViewCell * prototypeCell;

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
    
    //设置cell相关
    UINib *cellNib = [UINib nibWithNibName:@"StationDetailTableViewCell" bundle:nil];
    [self.myTableView registerNib:cellNib forCellReuseIdentifier:@"sDetail"];
    self.prototypeCell  = [self.myTableView dequeueReusableCellWithIdentifier:@"sDetail"];

    StationDetailTableViewCell *c = [[[NSBundle mainBundle] loadNibNamed:@"StationDetailTableViewCell" owner:self options:nil] objectAtIndex:0];
    
    CGSize size = [c.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"viewD h=%f", size.height);

    

    
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
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 66;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
//    CGSize textViewSize = [cell.cellTextView sizeThatFits:CGSizeMake(241, FLT_MAX)];
//    NSLog(@"s = %@",NSStringFromCGSize(textViewSize));
//    return textViewSize.height+25;
    
    
    StationDetailTableViewCell *cell = self.prototypeCell;
//    cell.translatesAutoresizingMaskIntoConstraints = NO;
//    cell.myLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    cell.myImage.translatesAutoresizingMaskIntoConstraints = NO;
    cell.myLabel.text = dataAry[indexPath.row];
    NSLog(@" + %@",dataAry[indexPath.row]);
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"h=%f", size.height + 1);
    return 200;
    
    
    //return 100;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationDetailTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"sDetail"];
    cell.myLabel.text = dataAry[indexPath.row];
    return cell;
}



@end
