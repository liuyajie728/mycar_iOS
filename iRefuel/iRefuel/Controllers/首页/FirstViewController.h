//
//  FirstViewController.h
//  iRefuel
//
//  Created by 刘亚杰Kamas on 15/4/16.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FirstViewController : UIViewController

@end

@interface homeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *littleImage3;
@property (weak, nonatomic) IBOutlet UILabel *littleImage2;
@property (weak, nonatomic) IBOutlet UILabel *littleImage1;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *youzhanName;
@property (weak, nonatomic) IBOutlet UILabel *youzhanAddress;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end

