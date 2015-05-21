//
//  StationDetailViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/21.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "StationDetailViewController.h"
#import "CommonUtil.h"
#import "StationDetailTableViewCell.h"

@interface StationDetailViewController ()<UIGestureRecognizerDelegate>
{
    NSArray * dataAry;

}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *myTableHeadView;
@property (strong, nonatomic) IBOutlet UIView *myTableDownView;


@end

@implementation StationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //title
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"油站详情" andFount:18 andTitleColour:[UIColor whiteColor]];
    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"clockicon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.myTableView.tableHeaderView = self.myTableHeadView;
    self.myTableView.tableFooterView = self.myTableDownView;
    
    [self settingFrame];
    
    dataAry = @[
                @"我总是在最深的绝望里，遇见最美的风景”。 ——这句非常心灵老鸭汤的话是老婆大大大大大",
                @"首先你要有一张城市风景照片（其他类型的还没试过）。请勇敢地把原始分辨率拿出来，不然滤镜处理的时候过大的笔触大小会让你抓狂地回到这一步。",
                @"受了 这种动漫风格的照片是手绘的还是 Photoshop 就可以达到的？后期过程是怎样的？ - 摄影 几个高票回答的启示，昨晚特地学习研究了一下，目前已经能达到 3 – 5 分钟处理一张照片的速度。虽然还没有达到大师级的高度，不过已经挺有意思了，给诸位抛个砖吧。"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)settingFrame
{
    CGRect frame = self.myTableView.frame;
    frame.origin.y = 64;
    frame.size.width = LCDW;
    frame.size.height = LCDH - 64;
    self.myTableView.frame = frame;

}

-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //算高度
    NSString * text = dataAry[indexPath.row];
    CGSize size = CGSizeMake(252.f, 100000);
    UIFont * font = [UIFont systemFontOfSize:13];
    
    CGSize labelSize = [CommonUtil sizeWithText:text font:font maxSize:size];
    
    if (labelSize.height <= 35) {
        return 68;
    }else{
        return labelSize.height + 32;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    StationDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sDetail"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StationDetailTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.myLabel.text = dataAry[indexPath.row];
    
    //设置文本label的高度
    CGRect frame = cell.myLabel.frame;
    frame.size.height = [CommonUtil sizeWithText:dataAry[indexPath.row] font:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(252.f, 1000)].height;
    cell.myLabel.frame = frame;

    
    return cell;
    

}
@end
