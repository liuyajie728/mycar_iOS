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
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"

@interface StationDetailViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    NSArray * dataAry;

}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *myTableHeadView;
@property (strong, nonatomic) IBOutlet UIView *myTableDownView;


//headView
@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UILabel *youzhanName;
@property (weak, nonatomic) IBOutlet UILabel *youzhanAddress;

@property (weak, nonatomic) IBOutlet UIImageView *topLittleImage1;
@property (weak, nonatomic) IBOutlet UIImageView *topLittleImage2;
@property (weak, nonatomic) IBOutlet UIImageView *topLittleImage3;
@property (weak, nonatomic) IBOutlet UIImageView *topLittleImage4;
@property (weak, nonatomic) IBOutlet UIImageView *topLittleImage5;

@property (weak, nonatomic) IBOutlet UILabel *dianpingLabel;


@end

@implementation StationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
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
    //self.myTableView.tableFooterView = self.myTableDownView;
    
    self.myTableView.tableFooterView = [[UIView alloc]init];
    
    [self settingFrame];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //title
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"油站详情" andFount:18 andTitleColour:TitleColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    
    if (dataAry) {
        return;
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * postDic = [CommonUtil getPostDic];
    
    [postDic setObject:[self.firstInfo objectForKey:@"station_id"] forKey:@"station_id"];
    
    //comment    station_id
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:[NSString stringWithFormat:@"%@/comment/station",MyHTTP] parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"%@",responseObject);
        NSDictionary * dic = responseObject;
        
        if ([[dic objectForKey:@"status"]longValue] == 200) {
            //成功
            dataAry = [dic objectForKey:@"content"];
            [self.myTableView reloadData];
            
            self.dianpingLabel.text = [NSString stringWithFormat:@"车友点评(%ld)",dataAry.count];
            
        }else if ([[dic objectForKey:@"status"]longValue] == 400){
            //没有评论
            self.myTableView.tableFooterView = self.myTableDownView;
        
            self.dianpingLabel.text = @"暂时没有评论";
        }else{
            //失败
            [CommonUtil showHUD:@"获取数据失败，请检查网络后重试" delay:2.0f withDelegate:self];
        }
        
        
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CommonUtil showHUD:@"获取数据失败，请检查网络后重试" delay:2.0f withDelegate:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    //设置top内容
    
    //名称
    self.youzhanName.text = [self.firstInfo objectForKey:@"name"];
    
    //油站地址
    //NSString * city = [self.FirstInfo objectForKey:@"city"];
    NSString * district = [self.firstInfo objectForKey:@"district"];
    //NSString * province = [self.FirstInfo objectForKey:@"province"];
    NSString * address = [self.firstInfo objectForKey:@"address"];
    
    self.youzhanAddress.text = [NSString stringWithFormat:@"%@区%@",district,address];
    
    //图片
    [self.bigImage setImageWithURL:[NSURL URLWithString:[self.firstInfo objectForKey:@"image_url"]] placeholderImage:nil];
    
    //评星
    NSArray * startImages =  [CommonUtil getStartImages: [[self.firstInfo objectForKey:@"rate_oil"]floatValue]];
    self.topLittleImage1.image = [UIImage imageNamed:startImages[0]];
    self.topLittleImage2.image = [UIImage imageNamed:startImages[1]];
    self.topLittleImage3.image = [UIImage imageNamed:startImages[2]];
    self.topLittleImage4.image = [UIImage imageNamed:startImages[3]];
    self.topLittleImage5.image = [UIImage imageNamed:startImages[4]];

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

#pragma mark clickBtn
- (IBAction)clickPhone:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[self.firstInfo objectForKey:@"tel"]]]];
    
    
}
- (IBAction)clickMapNavigation:(id)sender
{
    
    
}
- (IBAction)goRefuel:(id)sender {
    
    
}



#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //算高度
    
    NSDictionary * dic = dataAry[indexPath.row];
    
    //评论主体
    NSString * content = [self getCellTextWithStr:[dic objectForKey:@"content"]];
    
    //追加评论
    NSString * append = [self getCellTextWithStr:[dic objectForKey:@"append"]];
    
    NSString * text;
   
    if ( [content isEqualToString:@""] && [append isEqualToString:@""]) {
         text = @"该用户只进行了评分，未写评价。";
        
    }else if ([content isEqualToString:@""]){
        text = append;
        
    }else if ([append isEqualToString:@""] && ![content isEqualToString:@""])
    {
        text = [NSString stringWithFormat:@"%@",content];
    }
    else{
        text = [NSString stringWithFormat:@"%@ \n追加评论:%@",content,append];
    }
    
    
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
    
    NSDictionary * dic = dataAry[indexPath.row];
    
    //名字
    NSString * userName = [dic objectForKey:@"user_nickname"];
    if([userName isKindOfClass:[NSNull class]]){
        //没名字
        cell.nameLabel.text = @"";
        
    }else{
        //有名字
        cell.nameLabel.text = userName;
    }
    
  
    
    //头像
    NSString * userHead = [dic objectForKey:@"user_logo_url"];
    if ([userHead isKindOfClass:[NSNull class]]) {
        //没头像
//cell.headImage.image = [UIImage imageNamed:@"holdHeadImage"];
         [cell.headImage setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"holdHeadImage"]];
    }else{
        //有头像
        [cell.headImage setImageWithURL:[NSURL URLWithString:userHead] placeholderImage:[UIImage imageNamed:@"holdHeadImage"]];
    }
    
    //评论主体
    NSString * content = [self getCellTextWithStr:[dic objectForKey:@"content"]];
    
    //追加评论
    NSString * append = [self getCellTextWithStr:[dic objectForKey:@"append"]];
    
    
    NSString * labelText;
    if ( [content isEqualToString:@""] && [append isEqualToString:@""]) {
        labelText = @"该用户只进行了评分，未写评价。";
        
    }else if ([content isEqualToString:@""]){
        labelText = append;
        
    }else if ([append isEqualToString:@""] && ![content isEqualToString:@""])
    {
        labelText = [NSString stringWithFormat:@"%@",content];
    }
    else{
        labelText = [NSString stringWithFormat:@"%@ \n追加评论:%@",content,append];
    }
    
    
    cell.myLabel.text = labelText;
    
    //设置文本label的高度
    CGRect frame = cell.myLabel.frame;
    frame.size.height = [CommonUtil sizeWithText:labelText font:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(252.f, 1000)].height;
    
    cell.myLabel.frame = frame;
    
    //评价打星
    UIImageView * start1 = (UIImageView*)[cell.contentView viewWithTag:100];
    UIImageView * start2 = (UIImageView*)[cell.contentView viewWithTag:101];
    UIImageView * start3 = (UIImageView*)[cell.contentView viewWithTag:102];
    UIImageView * start4 = (UIImageView*)[cell.contentView viewWithTag:103];
    UIImageView * start5 = (UIImageView*)[cell.contentView viewWithTag:104];
    
    NSArray * startImages =  [CommonUtil getStartImages: [[self.firstInfo objectForKey:@"rate_oil"]floatValue]];
    
    
    start1.image =  [UIImage imageNamed:startImages[0]];
    start2.image =  [UIImage imageNamed:startImages[1]];
    start3.image =  [UIImage imageNamed:startImages[2]];
    start4.image =  [UIImage imageNamed:startImages[3]];
    start5.image =  [UIImage imageNamed:startImages[4]];

    
    return cell;
}

-(NSString*)getCellTextWithStr:(NSString*)str
{
    if ([str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    

    if ([str isEqualToString:@"<null>"] || !str) {
        return @"";
    }else{
        return str;
    }
}
@end
