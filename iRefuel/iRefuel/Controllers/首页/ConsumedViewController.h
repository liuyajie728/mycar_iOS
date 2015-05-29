//
//  ConsumedViewController.h
//  iRefuel
//
//  Created by wangdi on 15/5/25.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumedViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *myTopTextField;
@property (weak, nonatomic) IBOutlet UITextField *myDownTextField;


//油站的名字
@property (nonatomic,copy)NSString * youzhanName;


@end
