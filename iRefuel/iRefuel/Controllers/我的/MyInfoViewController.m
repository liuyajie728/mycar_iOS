//
//  MyInfoViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/20.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "MyInfoViewController.h"
#import "CommonUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "RevampViewController.h"
#import "MyPreference.h"
#import "myPickerView.h"
#import "SelectedGenderViewController.h"

@implementation myInfoCell1
@end

@implementation myInfoCell2
@end


@interface MyInfoViewController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray * s1;
    NSArray * s2;
    
    NSArray * s2Infos;
    
    UIImagePickerController * imagePicker;  // 图片选择器
    
    int revampType;//用来给修改界面穿的type
    
    
    NSString * nickName;
    
    
    myPickerView * my_PickerView;
    NSArray * pickerAry;
    
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;



@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"个人信息" andFount:18 andTitleColour:TitleColor];
    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //设置tableView没有弹性
    self.myTableView.bounces = NO;

    
    
    s1 = @[@"头像",@"昵称"];
    s2 = @[@"性别",@"手机号",@"电子邮箱",@"生日"];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //设置个人信息
    NSDictionary * dic = [MyPreference getLoginInfo];
    nickName = [dic objectForKey:@"nickname"];
    
    //设置tableView显示的个人信息
    NSDictionary * userDic = [MyPreference getLoginInfo];
    
    //性别
    NSString * gender = [userDic objectForKey:@"gender"];
    if ([gender isEqualToString:@"0"]) {
        gender = @"女";
    }else if([gender isEqualToString:@"1"]){
        gender = @"男";
    }
    
    //手机号
    NSString * userPhone = [userDic objectForKey:@"mobile"];
    
    //邮箱
    NSString * eMail = [userDic objectForKey:@"email"];
    
    //生日
    NSString * birthday = [userDic objectForKey:@"dob"];
    
    s2Infos = @[gender,userPhone,eMail,birthday];
    [self.myTableView reloadData];
    
}

-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark settingTableViewHeight
-(void)settingTableViewHeight:(BOOL)isHeight
{
    if (isHeight) {
        //收
        //[UIView animateWithDuration:.3 animations:^{
            
            //调整scrollView
//            CGRect frame = self.myTableView.frame;
//            //frame.size.height = LCDH - (153+64);
//            frame.size.height = 200;
//            self.myTableView.frame = frame;
        
//        } completion:^(BOOL finished) {
//            
//        }];
        
    }else{
        //伸
    
    }


}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return s1.count;
    }else if (section == 1){
        return s2.count;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 66;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        //头像
        
        static NSString *CellIdentifier = @"myInfoCell1";
        myInfoCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[myInfoCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.headImage.backgroundColor = [UIColor redColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

        
        
    }else{
    
        static NSString *CellIdentifier = @"myInfoCell2";
        myInfoCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[myInfoCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            cell.leftLabel.text = s1[indexPath.row];
            
            //昵称的名字
            cell.rightLabel.text = nickName;
            
        }else if (indexPath.section == 1){
            cell.leftLabel.text = s2[indexPath.row];
            cell.rightLabel.text = s2Infos[indexPath.row];
        }
        
        return cell;
    
    
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            //选择头像
            
            UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择"
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"照片库",@"拍照", nil];
            
            actionSheet.actionSheetStyle = 1;
            [actionSheet showInView:self.view];
            
        }else if (indexPath.row == 1){
            //昵称
            revampType = 1;
            [self performSegueWithIdentifier:@"revamp" sender:self];
            
        }
    }else if (indexPath.section == 1){
    
        if (indexPath.row == 0) {
            
            //性别
            [self performSegueWithIdentifier:@"gender" sender:nil];

        }else if (indexPath.row == 1){
            //手机号
            
            
        }else if (indexPath.row == 2){
            //电子邮箱
            revampType = 2;
            [self performSegueWithIdentifier:@"revamp" sender:self];
            
            
        }else if (indexPath.row == 3){
            //生日
            
            
        }
    
    }

}
#pragma mark storybord
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"revamp"]) {
        RevampViewController * revampVc = segue.destinationViewController;
        revampVc.myType = revampType;
    }else if ([segue.identifier isEqualToString:@"gender"]){
        SelectedGenderViewController * selectedVc = segue.destinationViewController;
        selectedVc.gender = s2Infos[0];
        selectedVc.delegate = self;
    }
}
#pragma mark - actionDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (imagePicker == nil) {
        imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical; //设置动画
        imagePicker.allowsEditing = YES;
    }
    
    switch (buttonIndex) {
        case 0:
        {
            //照片库
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.parentViewController presentViewController:imagePicker animated:YES completion:nil];
            
        }
            break;
        case 1:
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            
            
            if (authStatus == AVAuthorizationStatusDenied||authStatus == AVAuthorizationStatusNotDetermined)
            {
//                [_error addMainTitle:@"提示" content:@"请从设置中打开相机权限" button1Title:@"" button1Taget:nil button1Sel:nil button2Title:@"" button2Taget:nil button2Sel:nil delayTime:2];
                NSLog(@"不支持相机");
                return;
            }
            
            //拍照
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.parentViewController presentViewController: imagePicker animated:YES completion:nil];
            
        }
            break;
    }
}

#pragma mark imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image  = [info objectForKey:UIImagePickerControllerEditedImage];
//    self.myFace_IV.image = image;
//    [imagePicker dismissViewControllerAnimated:YES completion:nil];
//    isUpdateImage = YES;
    
    //TODO上传头像
}

#pragma mark pickerViewDelegate
// returns the number of 'columns' to display.
//返回有几个PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return pickerAry.count;

}
//每列每行对应显示的数据是什么
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    return pickerAry[row];
}

//点击pickerview上面的取消按钮
-(void)clickPickerViewBtn{
    
    my_PickerView.hidden = YES;
    [self settingTableViewHeight:NO];
}

@end
