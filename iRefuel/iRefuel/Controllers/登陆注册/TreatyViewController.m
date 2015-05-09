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


@interface TreatyViewController ()<MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIButton *confirm_btn;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation TreatyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.confirm_btn.layer.cornerRadius = 6;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:@"http://www.jiayoucar.com/api/article/" parameters:@{@"token":@"bbE0cMOoCmRJDnun8y9uqyR8C"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSDictionary * dic = responseObject;
        if ([[dic objectForKey:@"status"]longValue] == 200) {
            
            //title
            self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:[[dic objectForKey:@"content"]objectForKey:@"title"] andFount:18 andTitleColour:[UIColor whiteColor]];
            
            //text
            [self.myWebView loadHTMLString:[[dic objectForKey:@"content"]objectForKey:@"content"] baseURL:nil];
            
        }else{
        
            [CommonUtil showHUD:@"获取协议失败" delay:2.0 withDelegate:self];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];


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
