//
//  TreatyViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/8.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "TreatyViewController.h"
#import "CommonUtil.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"


@interface TreatyViewController ()

@property (weak, nonatomic) IBOutlet UIButton *confirm_btn;
@end

@implementation TreatyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"我的车服务条款" andFount:18 andTitleColour:[UIColor whiteColor]];
    
    self.confirm_btn.layer.cornerRadius = 6;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [manager POST:@"http://www.jiayoucar.com/api/article/1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@",responseObject);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ClickBtn

- (IBAction)clickBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}



@end
