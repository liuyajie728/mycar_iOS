//
//  BalanceAndPrepaidTakeViewController.h
//  iRefuel
//
//  Created by wangdi on 15/5/13.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceAndPrepaidTakeViewController : UIViewController

@end


@interface balanceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTopLabel_lb;
@property (weak, nonatomic) IBOutlet UILabel *leftDownLabel_lb;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel_lb;
@property (weak, nonatomic) IBOutlet UILabel *rightDownLabel_lb;
@property (weak, nonatomic) IBOutlet UILabel *zeng;
@property (weak, nonatomic) IBOutlet UILabel *zengNum;



@end
