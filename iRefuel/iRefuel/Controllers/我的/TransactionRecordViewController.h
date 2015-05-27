//
//  TransactionRecordViewController.h
//  iRefuel
//
//  Created by wangdi on 15/5/14.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionRecordViewController : UIViewController

@end

@interface TransactionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhifuLabel;

@end