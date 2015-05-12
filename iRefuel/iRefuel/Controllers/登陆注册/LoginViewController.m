//
//  LoginViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/7.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "CommonUtil.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "TreatyViewController.h"


@interface LoginViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    //保存发送完验证码返回的信息
    NSDictionary * verifyDic;
    
    
    NSTimer * timer;
    int timerNum; //验证码90秒倒计时计数器
    BOOL numberIsPhone; //电话号码位数是否足够11位来获取验证码
    BOOL numberIsVerify;//验证码tf是否够4位数
    BOOL isRefister; //是否可以注册
    
    
}

@property (weak, nonatomic) IBOutlet UITextField *phone_tf;
@property (weak, nonatomic) IBOutlet UITextField *verify_tf;
@property (weak, nonatomic) IBOutlet UIButton *verify_btn;
@property (weak, nonatomic) IBOutlet UIButton *confirm_btn;
@property (weak, nonatomic) IBOutlet UIView *textFieldView;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    //self.navigationItem.title = @"哎油";
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"哎油" andFount:18 andTitleColour:[UIColor whiteColor]];

//    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.view.backgroundColor = [CommonUtil colorWithHexString:@"00a1d8" alpha:1];
    
    
    //初始化倒计时60秒
    timerNum = 60;
    
    //设置圆弧
    self.textFieldView.layer.cornerRadius = 6;
    self.confirm_btn.layer.cornerRadius = 6;
    
    //设置子视图不超出父视图显示
    self.textFieldView.clipsToBounds = YES;
    
    
    //监听textField
    [self.phone_tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verify_tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    //自定义nav
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//    //[back setTitle:@"Back" forState:UIControlStateNormal];
//    [back setFrame:CGRectMake(5, 2, 52, 30)];
//    //[back setBackgroundImage:[UIImage imageNamed:@"bar_return"] forState:UIControlStateNormal];
//    //[back addTarget:self action:@selector(popDiyView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:back];
//    barButton.style = UIBarButtonSystemItemUndo;
//    self.navigationItem.leftBarButtonItem = barButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark clickBtn
- (IBAction)clickVerifyCode:(id)sender {
    //获取验证码
    
    //如果是正在倒计时则不做任何处理
    if (timerNum != 60) {
        return;
    }
    
    if (!numberIsPhone) {
        NSLog(@"numberIsVerify");
        return;
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:@"http://www.jiayoucar.com/api/sms/send" parameters:@{@"mobile":self.phone_tf.text,@"token":@"bbE0cMOoCmRJDnun8y9uqyR8C"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        verifyDic = responseObject;
        
        if ([[verifyDic objectForKey:@"status"]longValue] == 200) {
            
            [CommonUtil showHUD:@"获取验证码成功！" delay:2.0 withDelegate:self];
            [self.verify_tf becomeFirstResponder];
            
            //倒计时
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerCountDown:) userInfo:nil repeats:YES];
            
        }else{
        
            [CommonUtil showHUD:@"您提供的手机号码有误，请检查" delay:2.0 withDelegate:self];
        }
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure = %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CommonUtil showHUD:@"请您检查网络是否通畅" delay:2.0 withDelegate:self];
        
    }];
}
- (IBAction)clickRegister:(id)sender {
    //确定注册
    
    if (!isRefister) {
        return;
    }
    
    if (!verifyDic) {
        [CommonUtil showHUD:@"请先获取验证码" delay:2.0 withDelegate:self];
        return;
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];

    NSString * smsId = [NSString stringWithFormat:@"%ld",[[[verifyDic objectForKey:@"content"]objectForKey:@"sms_id"]longValue]];
    
    NSDictionary * paramet = @{@"mobile":self.phone_tf.text,
                               @"captcha":self.verify_tf.text,
                               @"sms_id":smsId,
                               @"token":@"bbE0cMOoCmRJDnun8y9uqyR8C"};
    
    

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:@"http://www.jiayoucar.com/api/user/login" parameters:paramet success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dic = responseObject;
        if ([[dic objectForKey:@"status"]longValue] == 200){
        
            [CommonUtil showHUD:@"恭喜您 注册成功" delay:2.0 withDelegate:self];
            //TODO退回到登陆界面
            
            
        }else if ([[dic objectForKey:@"status"]longValue] == 400){
            [CommonUtil showHUD:@"验证码输入错误" delay:2.0 withDelegate:self];
            
        }else{
            [CommonUtil showHUD:@"很遗憾！注册失败" delay:2.0 withDelegate:self];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CommonUtil showHUD:@"请您检查网络是否通畅" delay:2.0 withDelegate:self];
        
    }];
    
}
- (IBAction)clickBgTapGesture:(id)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    //判断必须是数字
    if(![CommonUtil validateNumber:string] && ![string isEqualToString:@""]){
        return NO;
    }
    

    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 0) {
        if (textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
            
            if (textField.text.length == 11) {
                self.verify_btn.backgroundColor = [UIColor colorWithRed:71/255.0 green:218/255.0 blue:192/255.0 alpha:1];
                numberIsPhone = YES;
            }else{
                self.verify_btn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
                numberIsPhone = NO;
            }
            
            
        }else{
            self.verify_btn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
            numberIsPhone = NO;
        }
        
    }else if (textField.tag == 1){
        //验证码TF
        
        if (textField.text.length >= 4) {
            textField.text = [textField.text substringToIndex:4];
            
            if (textField.text.length == 4) {
                
                numberIsVerify = YES;
            }else{
               
                numberIsVerify = NO;
            }

        }else{

            numberIsVerify = NO;
        }
    }
    [self settingGoBtn];
    
}

//根据手机号和验证码来设置注册btn是否高亮
-(void)settingGoBtn
{
    if (numberIsVerify && numberIsPhone) {
        isRefister = YES;
        
        self.confirm_btn.backgroundColor = [UIColor colorWithRed:71/255.0 green:218/255.0 blue:192/255.0 alpha:1];
        
    }else{
        isRefister = NO;
        self.confirm_btn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    }
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField.tag == 0) {
        [self.verify_tf becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - 倒计时
-(void) timerCountDown:(NSTimer*)sender
{
    timerNum--;
    
    [self.verify_btn setTitle:[NSString stringWithFormat:@"%d秒后重发",timerNum] forState:UIControlStateNormal];
    
    
    if (timerNum == 0) {
        [sender invalidate];
        timerNum = 60;
        [self.verify_btn setTitle:@"重新发送" forState:UIControlStateNormal];
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
