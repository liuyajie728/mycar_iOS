//
//  RevampViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/20.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "RevampViewController.h"
#import "CommonUtil.h"

@interface RevampViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation RevampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"0 %d",self.myType);
    
    NSString * titleStr;
    if (self.myType == 1) {
        //昵称
        titleStr = @"修改昵称";
    }
    
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:titleStr andFount:18 andTitleColour:TitleColor];
    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"clockicon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    
    //nav右边按钮
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"clockicon.png"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * saveItem = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //添加输入框监听事件
    [self.myTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.deleteBtn.layer.cornerRadius = 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveInfo
{

}
- (IBAction)clickDelete:(id)sender {
    self.myTextField.text = @"";
}

#pragma textFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.myTextField) {
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
