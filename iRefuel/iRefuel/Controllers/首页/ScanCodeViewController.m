//
//  ScanCodeViewController.m
//  iRefuel
//
//  Created by wangdi on 15/5/19.
//  Copyright (c) 2015年 SenseStrong E-Commerce Co. Ltd. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CommonUtil.h"
#import "GasStationDetailViewController.h"

@interface ScanCodeViewController ()<UIGestureRecognizerDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    NSString *stringValue;
}

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

//边框
@property (weak, nonatomic) IBOutlet UIImageView *rimRightDown;
@property (weak, nonatomic) IBOutlet UIImageView *rimLeftTop;
@property (weak, nonatomic) IBOutlet UIImageView *rimLeftDown;
@end

#define degreeTOradians(x) (M_PI * (x)/180)
@implementation ScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [CommonUtil getTitleViewWithTitle:@"扫描二维码" andFount:18 andTitleColour:TitleColor];
    

    
    //设置nav左边按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"clockicon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];

    //添加向右滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //设置四个边角图片
    [UIView animateWithDuration:0.0f
                     animations:^{
                         [self.rimRightDown setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
                         [self.rimLeftDown setTransform:CGAffineTransformMakeRotation(degreeTOradians(180))];
                         [self.rimLeftTop setTransform:CGAffineTransformMakeRotation(degreeTOradians(-90))];
                
                     }];
    
    
    
    
//    //扫描二维码
//    //初始化
//    if (!_device) {
//        // Device
//        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        
//        // Input
//        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
//        
//        // Output
//        _output = [[AVCaptureMetadataOutput alloc]init];
//    }
//    
//    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    
//    // Session
//    _session = [[AVCaptureSession alloc]init];
//    [_session setSessionPreset:AVCaptureSessionPresetHigh];
//    
//    if ([_session canAddInput:self.input])
//    {
//        [_session addInput:self.input];
//    }
//    
//    if ([_session canAddOutput:self.output])
//    {
//        [_session addOutput:self.output];
//    }
//    
//    // 条码类型 AVMetadataObjectTypeQRCode
//    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
//    
//    // Preview
//    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
//    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
//    _preview.frame =self.view.layer.bounds;
//    [self.view.layer insertSublayer: _preview atIndex:0];
//    
//    // Start
//    [_session startRunning];
    
    
    [self performSegueWithIdentifier:@"GoGasStationDetail" sender:self];
    
}

-(void)backBtn:(UIButton*)send
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{

    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        
        NSLog(@"二维码扫描结果 %@",stringValue);
        [self performSegueWithIdentifier:@"GoGasStationDetail" sender:self];
    }
}

#pragma mark Storyboard
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoGasStationDetail"]) {
        //扫描二维码传值
        GasStationDetailViewController * send = segue.destinationViewController;
        send.codeSrt = stringValue;
    }
}

@end
