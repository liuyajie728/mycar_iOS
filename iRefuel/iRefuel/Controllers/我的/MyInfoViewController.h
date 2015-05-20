//
//  MyInfoViewController.h
//  iRefuel
//
//  Created by wangdi on 15/5/20.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoViewController : UIViewController

@end

@interface myInfoCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@end

@interface myInfoCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@end