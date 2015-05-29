//
//  ConsumedViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/25.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "ConsumedViewController.h"
#import "CommonUtil.h"
#include "ConfirmPayViewController.h"

@interface ConsumedViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *chongzhi_Tf;
@property (weak, nonatomic) IBOutlet UITextField *qita_Tf;

@end

@implementation ConsumedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"加油" andFount:18 andTitleColour:TitleColor];
    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}


//提交订单
- (IBAction)commit:(id)sender {
    
    //TODO 判断是否填写金额
    [self performSegueWithIdentifier:@"ConsumePay" sender:self];
    
}

#pragma mark Storyboard
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ConsumePay"]) {
        ConfirmPayViewController * confirmVc = segue.destinationViewController;
        
        float allMoney = [self.myTopTextField.text floatValue] + [self.myDownTextField.text floatValue];
        confirmVc.payNum = [NSString stringWithFormat:@"%.2f",allMoney];
        confirmVc.youzhanName = self.youzhanName;
        confirmVc.type = 2;
        
    }
}
@end
