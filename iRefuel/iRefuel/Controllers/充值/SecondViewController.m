//
//  SecondViewController.m
//  iRefuel
//
//  Created by 刘亚杰Kamas on 15/4/16.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "SecondViewController.h"
#import "CommonUtil.h"

@interface SecondViewController ()

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

@end
