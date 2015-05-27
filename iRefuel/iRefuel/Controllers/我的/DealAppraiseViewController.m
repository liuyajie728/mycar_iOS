//
//  DealAppraiseViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/18.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "DealAppraiseViewController.h"
#import "CommonUtil.h"
#import "AFHTTPRequestOperationManager.h"

@interface DealAppraiseViewController ()<UIGestureRecognizerDelegate,UITextViewDelegate,MBProgressHUDDelegate>
{
    NSArray * starts1;
    NSArray * starts2;
    
    NSInteger start1Num;
    NSInteger start2Num;
    
    UILabel * txtNumLabel;
    UITextView * footTextView;
    
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation DealAppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"交易评价" andFount:18 andTitleColour:TitleColor];
    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"clockicon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    //初始化的都是5星好评
    start1Num = 5;
    start2Num = 5;
    
    self.myTableView.tableFooterView = [self getTableViewFootView];
    
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tapBg:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(UIView*)getTableViewFootView
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 215)];
    footView.backgroundColor = [UIColor clearColor];
    
    
    footTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, LCDW, 145)];
    footTextView.backgroundColor = [UIColor whiteColor];
    footTextView.delegate = self;
    footTextView.font = [UIFont systemFontOfSize:14];
    [footView addSubview:footTextView];
    
    txtNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(LCDW - (120+16), footTextView.frame.size.height - 20, 120, 20)];
    txtNumLabel.font = [UIFont systemFontOfSize:12];
    txtNumLabel.backgroundColor = [UIColor clearColor];
    txtNumLabel.text = @"还可以输入140个字";
    txtNumLabel.textColor = cellTxtColor;
    txtNumLabel.textAlignment = NSTextAlignmentRight;
    [footView addSubview:txtNumLabel];
    
    
    UIButton * commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = BgBlueColor;
    commitBtn.frame = CGRectMake(20, txtNumLabel.frame.origin.y + txtNumLabel.frame.size.height + 8, LCDW - 40, 44);
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:commitBtn];
    
    
    return footView;

}
-(void)clickOk
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * postDic = [CommonUtil getPostDic];
    
    //服务和质量评分
    start1Num *= 20;
    start2Num *= 20;
    
    [postDic setObject:[NSNumber numberWithInteger:start1Num] forKey:@"rate_service"];
    [postDic setObject:[NSNumber numberWithInteger:start2Num] forKey:@"rate_oil"];
    
    //文字评价
    [postDic setObject:footTextView.text forKey:@"content"];
    
    //订单ID
    [self.transactionInfo objectForKey:@"order_id"];
    [postDic setObject:[self.transactionInfo objectForKey:@"order_id"] forKey:@"order_id"];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:[NSString stringWithFormat:@"%@/comment/create",MyHTTP] parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSDictionary * dataDic = responseObject;
        
        if ([[dataDic objectForKey:@"status"]longValue] == 200)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
          [CommonUtil showHUD:[dataDic objectForKey:@"content"] delay:2.0f withDelegate:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [CommonUtil showHUD:@"获取数据失败，请检查网络后重试" delay:2.0f withDelegate:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

}

#pragma mark clickCell
- (IBAction)clickCellFuwu:(UIButton*)sender {

    //改变评星状态
    for (int i =0; i<5; i++) {
        
        UIButton * startBtn = starts1[i];
        
        if (i<sender.tag) {
            startBtn.selected = YES;
            
        }else{
            startBtn.selected = NO;
        }
    }
    start1Num = sender.tag;
    //NSLog(@"服务评价 %ld星好评",start1Num);
}

- (IBAction)clickCellYoupin:(UIButton*)sender {
    
    //改变评星状态
    for (int i =0; i<5; i++) {
        
        UIButton * startBtn = starts2[i];
        
        if (i<sender.tag) {
            startBtn.selected = YES;
            
        }else{
            startBtn.selected = NO;
        }
    }
    start2Num = sender.tag;
    //NSLog(@"油品评价 %ld星好评",start2Num);
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"appraiseCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        starts1 = @[[cell.contentView viewWithTag:1],[cell.contentView viewWithTag:2],[cell.contentView viewWithTag:3],[cell.contentView viewWithTag:4],[cell.contentView viewWithTag:5]];
        
        
        
        return cell;
    }else if (indexPath.row == 1){
    
        static NSString *CellIdentifier = @"appraiseCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        starts2 = @[[cell.contentView viewWithTag:1],[cell.contentView viewWithTag:2],[cell.contentView viewWithTag:3],[cell.contentView viewWithTag:4],[cell.contentView viewWithTag:5]];
        
        
        return cell;
    
    }
    
    return nil;
}

#pragma mark keyboard
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    //动画
    [UIView animateWithDuration:.3 animations:^{
        
        //调整scrollView
        CGRect frame = self.myTableView.frame;
        frame.size.height = LCDH - (height+64);
        self.myTableView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //动画
    [UIView animateWithDuration:.3 animations:^{
        
        //调整scrollView
        self.myTableView.frame = CGRectMake(0, 49, LCDW, LCDH-49);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.myTableView setContentOffset:CGPointMake(0, 100) animated:YES];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //点击确定收键盘
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 140) {

        textView.text = [textView.text substringToIndex:140];
        number = 140;
        
    }
    
    txtNumLabel.text = [NSString stringWithFormat:@"还可以输入%ld个字",140-number];
}


@end
