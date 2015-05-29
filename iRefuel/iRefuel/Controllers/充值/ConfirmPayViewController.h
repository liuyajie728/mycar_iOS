//
//  ConfirmPayViewController.h
//  iRefuel
//
//  Created by wangdi on 15/5/28.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmPayViewController : UIViewController

//付款的钱数
@property (nonatomic,copy)NSString * payNum;

//油站的名字
@property (nonatomic,copy)NSString * youzhanName;

//1 充值、 2 付款 
@property (nonatomic,assign) int type;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end


@interface confirmPayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *money_label;

@end