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

@property (weak, nonatomic) IBOutlet UIImageView *tupian_image;


@end

@interface DealDetailContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@end


//评论的cell
@interface commentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIImageView *zhiliangStart_image1;
@property (weak, nonatomic) IBOutlet UIImageView *zhiliangStart_image2;
@property (weak, nonatomic) IBOutlet UIImageView *zhiliangStart_image3;
@property (weak, nonatomic) IBOutlet UIImageView *zhiliangStart_image4;
@property (weak, nonatomic) IBOutlet UIImageView *zhiliangStart_image5;



@property (weak, nonatomic) IBOutlet UIImageView *fuwuStart_image1;
@property (weak, nonatomic) IBOutlet UIImageView *fuwuStart_image2;
@property (weak, nonatomic) IBOutlet UIImageView *fuwuStart_image3;
@property (weak, nonatomic) IBOutlet UIImageView *fuwuStart_image4;
@property (weak, nonatomic) IBOutlet UIImageView *fuwuStart_image5;


@end