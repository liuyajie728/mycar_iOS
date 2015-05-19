//
//  GasStationDetailViewController.h
//  iRefuel
//
//  Created by wangdi on 15/5/19.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GasStationDetailViewController : UIViewController

//扫描二维码的数据
@property (nonatomic,strong)NSString * codeSrt;

@end


@interface GasStationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myCellContentLabel;

@end