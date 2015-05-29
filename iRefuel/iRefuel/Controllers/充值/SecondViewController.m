//
//  SecondViewController.m
//  iRefuel
//
//  Created by 刘亚杰Kamas on 15/4/16.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "SecondViewController.h"
#import "CommonUtil.h"
#import "ConfirmPayViewController.h"


@interface SecondViewController ()<MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"充值" andFount:18 andTitleColour:TitleColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickBg:(id)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}

//提交订单
- (IBAction)clickOk:(id)sender {
    
    if ([self.myTextField.text isEqualToString:@""]) {
        [CommonUtil showHUD:@"请输入要充值的金额" delay:2.0f withDelegate:self];
        return;
    }
    
    if ([self.myTextField.text floatValue] < 100) {
        [CommonUtil showHUD:@"充值金额不能小于100元" delay:2.0f withDelegate:self];
        return;
    }

    [self performSegueWithIdentifier:@"confirmPay" sender:self];
}

#pragma mark Storyboard
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"confirmPay"]) {
        ConfirmPayViewController * confirmVc = segue.destinationViewController;
        confirmVc.payNum = self.myTextField.text;
        confirmVc.type = 1;
        
    }
}
@end
