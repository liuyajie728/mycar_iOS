//
//  RevampViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/20.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "RevampViewController.h"
#import "CommonUtil.h"
#import "AFHTTPRequestOperationManager.h"
#import "MyPreference.h"

@interface RevampViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation RevampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"0 %d",self.myType);
    
    NSString * titleStr;
    if (self.myType == 1) {
        //昵称
        titleStr = @"修改昵称";
    }else if (self.myType == 2){
        //电子邮箱
        titleStr = @"电子邮箱";
    }
    
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:titleStr andFount:18 andTitleColour:TitleColor];
    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //nav右边按钮
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithRed:71/255.0 green:218/255.0 blue:192/255.0 alpha:1] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.frame = CGRectMake(0, 0, 50, 30);
    UIBarButtonItem * saveItem = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //添加输入框监听事件
    [self.myTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.deleteBtn.layer.cornerRadius = 7;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveInfo
{
    //根据不同的type做不同的提示
    NSString * tishiStr;
    if (self.myType == 1) {
        tishiStr = @"昵称不能为空";
    }else if (self.myType == 2){
        tishiStr = @"邮箱地址不能为空";
    }
    
    
    if ([self.myTextField.text isEqualToString:@""]) {
        [CommonUtil showHUD:tishiStr delay:2.0f withDelegate:self];
        return;
    }
    
    
    //登陆返回的用户信息
    NSDictionary * userInfo = [MyPreference getLoginInfo];
    
    
    //初始化af
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * postDic = [CommonUtil getPostDic];
    [postDic setObject:[userInfo objectForKey:@"user_id"] forKey:@"user_id"];
    
    //根据不同的type做不同的修改
    if (self.myType == 1) {
        //修改昵称
        [postDic setObject:@"nickname" forKey:@"column"];
        [postDic setObject:self.myTextField.text forKey:@"value"];
    }else if (self.myType == 2){
        //电子邮箱
        [postDic setObject:@"email" forKey:@"column"];
        [postDic setObject:self.myTextField.text forKey:@"value"];
    }
    
    
    //发送网络请求
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:[NSString stringWithFormat:@"%@/user/update",MyHTTP] parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSDictionary * dataDic = responseObject;
        if ([[dataDic objectForKey:@"status"]longValue] == 200)
        {
            //修改成功后更新信息
            NSMutableDictionary * mUserDic = [MyPreference getLoginInfo];
            [mUserDic setObject:self.myTextField.text forKey:@"nickname"];
            [MyPreference commitLoginInfo:mUserDic];
            
        }else{
        
            [CommonUtil showHUD:[dataDic objectForKey:@"content"] delay:2.0f withDelegate:self];
        }
        
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CommonUtil showHUD:@"服务器出错" delay:2.0f withDelegate:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    
    

}
- (IBAction)clickDelete:(id)sender {
    self.myTextField.text = @"";
}

#pragma textFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    int xianzhi = 0;
    if (self.myType == 1) {
        xianzhi = 15;
    }else if (self.myType == 2){
        xianzhi = 30;
    }
    
    if (textField == self.myTextField) {
        if (textField.text.length > xianzhi) {
            textField.text = [textField.text substringToIndex:xianzhi];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
