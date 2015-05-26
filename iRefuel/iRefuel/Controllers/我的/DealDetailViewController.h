//
//  DealDetailViewController.h
//  iRefuel
//
//  Created by wangdi on 15/5/18.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealDetailViewController : UIViewController

//上个界面穿过来的数据
@property (nonatomic,strong)NSDictionary * transactionInfo;

@end

@interface DealDetailTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *deputyTitle1;
@property (weak, nonatomic) IBOutlet UILabel *deputyTitle2;

@end

@interface DealDetailContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;


@end