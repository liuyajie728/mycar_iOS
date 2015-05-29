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
#import "DealAppraiseViewController.h"


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

@implementation commentCell

@end


@interface DealDetailViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    NSArray * s2;
    NSArray * s3;
    
    NSDictionary * content; //油站信息保存字典
    
    NSArray * data1;
    NSArray * data2;
    
    NSDictionary * comments; //放评论信息的字典
    UIButton * footViewBtn; //底部评论按钮
    
    BOOL isFirst;
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
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.myTableView.tableFooterView = [self getTableViewFootView];
    
    //请求订单详细信息
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
    if (!isFirst) {
        isFirst = YES;
    }else{
        [self requestCommentWithOrderId:[self.transactionInfo objectForKey:@"order_id"]];
    }

}
-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark request
-(void)requstDealInfo
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * postDic = [CommonUtil getPostDic];
    
    [postDic setObject:[self.transactionInfo objectForKey:@"user_id"] forKey:@"user_id"];
    [postDic setObject:[self.transactionInfo objectForKey:@"order_id"] forKey:@"order_id"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
            
            
            //请求评论信息
            [self requestCommentWithOrderId:[content objectForKey:@"order_id"]];
            

            [self.myTableView reloadData];
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CommonUtil showHUD:@"获取数据失败，请检查网络后重试" delay:2.0f withDelegate:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)requestCommentWithOrderId:(NSString*)orderId
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * postDic = [CommonUtil getPostDic];
    [postDic setObject:orderId forKey:@"order_id"];
    
    [manager POST:[NSString stringWithFormat:@"%@/comment",MyHTTP] parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSDictionary * dataDic = responseObject;
        
        if ([[dataDic objectForKey:@"status"]longValue] == 200){
            
            comments = [dataDic objectForKey:@"content"];
            [self.myTableView reloadData];
            
        }else{
//            comments = @[@"/n 123 /n 456 /n ", @"77777777/n 8888888/n 9999999999999999999999999/n 10101010/n",@"fwenfuwenfiwenifnwefinewifnewifnewiufnweiufneiuwfniuwefniewfniweufnuiwenfiewnfiewnfewifnewuifnueiwfnuwifnuverivnerinijrnefuin bbbbbbbbbbbbbbvvvvvvvvvvmiowdmioemdiowemdiowmdpqpoweiqoweuiorqpuiriuewhruiepwhruiepruihewuirhpqenjfipnpijrwncipenrpcijfwefwefwef"];
//            [self.myTableView reloadData];
            [CommonUtil showHUD:[dataDic objectForKey:@"content"] delay:2.0f withDelegate:self];
        }
       
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [CommonUtil showHUD:@"获取数据失败，请检查网络后重试" delay:2.0f withDelegate:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

#pragma mark tableViewFootView
-(UIView*)getTableViewFootView
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 40)];
    footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    footViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footViewBtn.frame = CGRectMake(20, 0, LCDW - 40, 30);
    footViewBtn.backgroundColor = BgBlueColor;
    [footViewBtn setTitle:@"添加评论" forState:UIControlStateNormal];
    footViewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [footViewBtn addTarget:self action:@selector(clickFootViewBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:footViewBtn];
    
    
    return footView;
}

#pragma mark clickTableViewFoot
-(void)clickFootViewBtn
{
    [self performSegueWithIdentifier:@"appraise" sender:nil];
}

#pragma mark TableViewDelegate
//自定义section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 3) {
        UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 20, LCDW, 40)];
        v.backgroundColor = [UIColor whiteColor];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 150, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = cellTxtColor;
        label.text = @"评价内容";
        [v addSubview:label];
        
        return v;
    }else{
        return nil;
    }
}

//貌似是 section是分上下两部分 而且设置成0还不行
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio{
    if (sectio == 3) {
        return 40;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectio{
    
    if (sectio == 2) {
        return 20;
    }else{
        return 0;
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return s2.count;
    }else if (section == 2){
        return s3.count;
    }else if(section == 3){
        
        //评论返回的是一个数组
        //评论永远只有一条 所以这里判断如果有返回值 就显示1条数据就行
        if (comments) {
            return 1;
        }else{
            return 0;
        }
     
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 86;
    }if (indexPath.section == 3) {
        //TODO 设置评论的高度
        
        

        
        NSString * contentStr = [comments objectForKey:@"content"];
        NSString * append = [comments objectForKey:@"append"];
        
        NSString * labelText;
        if (![append isKindOfClass:[NSNull class]]) {
            
            labelText = [NSString stringWithFormat:@"%@\n追加评论：%@",contentStr,append];
            
        }else{
            labelText = contentStr;
        }
        
        
        CGSize size = CGSizeMake(299.f, 100000);
        UIFont * font = [UIFont systemFontOfSize:14];
        
        CGSize labelSize = [CommonUtil sizeWithText:labelText font:font maxSize:size];
        
        if (labelSize.height <= 37) {
            return 78;
        }else{
            return labelSize.height + 41;
        }
        
        
    }else{
        return 44;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        //顶部信息
        
        static NSString *CellIdentifier = @"TopCell";
        DealDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DealDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //设置数据
        if (content) {
            
            //通过油站品牌id找到油站名字
            NSString * brand = @"";
            if (![[content objectForKey:@"station_brand_id"] isKindOfClass:[NSNull class]]) {
               brand = [CommonUtil getBrandWithBrandId:[[content objectForKey:@"station_brand_id"]intValue]];
            }
            
            //油站名字
            NSString * youzhanName = [content objectForKey:@"station_name"];
            cell.titleName.text = [NSString stringWithFormat:@"%@ - %@",brand,youzhanName];
            
            //油站地址 TODO
            cell.deputyTitle1.text = @"油站地址";
            
            //油站电话
            cell.deputyTitle2.text = [content objectForKey:@"station_tel"];
            
            //图片
            [cell.tupian_image setImageWithURL:[NSURL URLWithString:[content objectForKey:@"station_image_url"]] placeholderImage:nil];
            
        }
        
        
        return cell;
        
    }else if (indexPath.section == 3){
        //评论内容
       
        static NSString *CellIdentifier = @"commentCell";
        commentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[commentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        //判断是否有追加评论 如果有就合并起来
        NSString * contentStr = [comments objectForKey:@"content"];
        NSString * append = [comments objectForKey:@"append"];
        
        NSString * labelText;
        if (![append isKindOfClass:[NSNull class]] && append) {
            //有追加评论
            labelText = [NSString stringWithFormat:@"%@\n追加评论：%@",contentStr,append];
            
            //隐藏底部评价的btn
            footViewBtn.hidden = YES;
            
        }else{
            labelText = contentStr;
            [footViewBtn setTitle:@"追加评论" forState:UIControlStateNormal];
        }
        cell.titleLabel.text = labelText;
        
        
        //设置评分图片
        //油品质量
        NSArray * startImages =  [CommonUtil getStartImages: [[comments objectForKey:@"rate_oil"]floatValue]];
        cell.zhiliangStart_image1.image = [UIImage imageNamed:startImages[0]];
        cell.zhiliangStart_image2.image = [UIImage imageNamed:startImages[1]];
        cell.zhiliangStart_image3.image = [UIImage imageNamed:startImages[2]];
        cell.zhiliangStart_image4.image = [UIImage imageNamed:startImages[3]];
        cell.zhiliangStart_image5.image = [UIImage imageNamed:startImages[4]];
        
        //服务质量
         NSArray * fuwuStartImages =  [CommonUtil getStartImages: [[comments objectForKey:@"rate_service"]floatValue]];
        cell.fuwuStart_image1.image = [UIImage imageNamed:fuwuStartImages[0]];
        cell.fuwuStart_image2.image = [UIImage imageNamed:fuwuStartImages[1]];
        cell.fuwuStart_image3.image = [UIImage imageNamed:fuwuStartImages[2]];
        cell.fuwuStart_image4.image = [UIImage imageNamed:fuwuStartImages[3]];
        cell.fuwuStart_image5.image = [UIImage imageNamed:fuwuStartImages[4]];
        
        
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
#pragma mark storybord
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"appraise"])
    {
        DealAppraiseViewController * send = segue.destinationViewController;
        send.transactionInfo = self.transactionInfo;
        
    }

}
@end
