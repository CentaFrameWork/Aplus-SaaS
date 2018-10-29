//
//  JMScanController.m
//  PanKeTong
//
//  Created by Admin on 2018/3/9.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMScanController.h"
#import "JMScanJumpYCuiController.h"
#import "JMScanJumpWebController.h"
#import "JMScanJumpOtherController.h"
#import <AVFoundation/AVFoundation.h>
#define  X (APP_SCREEN_WIDTH-240)/2
#define  Y (APP_SCREEN_HEIGHT-360)/2
#define kScanRect CGRectMake(X, Y, 240, 240)

@interface JMScanController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic,strong)UIView *loadingView;
@property (nonatomic,strong)UIImageView *lineV;

@end

@implementation JMScanController


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self setUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self setNav];

    //开始启动
    [self.session startRunning];
    [self.view addSubview:_lineV];
    [self animation:_lineV];
    

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
   
    if ([metadataObjects count] >0){
      
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
         NSString *stringValue = metadataObject.stringValue;
       
        //停止扫描
        [_session stopRunning];
        [_lineV removeFromSuperview];
        
        [self.view addSubview:self.loadingView];
        [self performSelector:@selector(scanRestlt:) withObject:stringValue afterDelay:1.0];
        
        
    }
    
    
}

#pragma mark -  **************扫描结果处理**************
- (void)scanRestlt:(NSString*)string {
    
    [self.loadingView removeFromSuperview];
    
    if ([string isValidUrl]) {
        
        NSURL *url = [NSURL URLWithString:string.lowercaseString];
        
        if ([url.scheme contains:@"http"]) {
            
            
            JMScanJumpWebController *vc = [[JMScanJumpWebController alloc] initWithUrl:url];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if ([url.scheme contains:@"yuancui"]){
            
            
            JMScanJumpYCuiController *vc = [[JMScanJumpYCuiController alloc] initWithUrlString:string];
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }else{
            
            //其他协议 之后拓展
            
        }
        
        
    }else{
        
        
        JMScanJumpOtherController *vc = [[JMScanJumpOtherController alloc] initWithUrlString:string];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}


+ (void)scanController:(void(^)(bool isInstance ,UIViewController *vc ))block {
    
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            if (granted) {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    JMScanController *vc = [[JMScanController alloc] init];
                    block(YES,vc);
                });
                
            }
        }];
        
    }else if (authStatus == AVAuthorizationStatusAuthorized) {
        
        
        JMScanController *vc = [[JMScanController alloc] init];
        block(YES,vc);
        
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机未授权" message:@"请前往设置，打开原萃的通讯录权限后继续使用" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:1 handler:nil]];
        
        block(NO,alert);
        
        
    }
}



- (void)setUI {
    
    self.navigationController.navigationBarHidden = NO;
    
    [self setNavTitle:@"二维码扫描"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"返回箭头-白色"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    [self.output setRectOfInterest:CGRectMake(Y/APP_SCREEN_HEIGHT,X/APP_SCREEN_WIDTH, 240/APP_SCREEN_HEIGHT, 240/APP_SCREEN_WIDTH)];
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.preview = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.preview.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH , APP_SCREEN_HEIGHT);
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.preview];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    _lineV = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y+10, 240, 2)];
    _lineV.image = [UIImage imageNamed:@"lineG"];
    
    
    //提示文字
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.x, CGRectGetMaxY(imageView.frame)+10, 240, 30)];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [label setLayerCornerRadius:15];
    label.text = @"对准二维码到框内即可扫描";
    label.textAlignment = 1;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:label];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, APP_SCREENSafeAreaHeight-50, APP_SCREEN_WIDTH, 50)];
    [btn setImage:[UIImage imageNamed:@"flashlightOFF"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"flashlightON"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    CAShapeLayer *cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, kScanRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.2];
    
    [self.view.layer addSublayer:cropLayer];
}





- (void)setNav {
    
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"nav_line_clear"]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

-(void)animation:(UIImageView*)imageV {
    
    
        CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
         CGPoint point = imageV.center;
         NSValue *value1=[NSValue valueWithCGPoint:point];
         NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(point.x, point.y+220)];
         keyAnima.values=@[value1,value2];
         keyAnima.removedOnCompletion=NO;
         keyAnima.fillMode=kCAFillModeForwards;
         keyAnima.duration= 1.5;
         keyAnima.repeatCount = MAXFLOAT;
         [imageV.layer addAnimation:keyAnima forKey:nil];
    
    
}


- (void)btnClick:(UIButton*)btn {
    
    btn.selected = !btn.selected;
    
    [_device lockForConfiguration:nil];
    
    [_device setTorchMode:btn.selected ?AVCaptureTorchModeOn:AVCaptureTorchModeOff];
    
    [_device unlockForConfiguration];
    
    
}


- (UIView *)loadingView {
    
    if (!_loadingView) {
        
        _loadingView = [[UIView alloc] initWithFrame:kScanRect];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        indicator.center = CGPointMake(115,110);
        [indicator startAnimating];
        [_loadingView addSubview:indicator];
        
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(indicator.frame)+5, 240, 30)];
        
        
        label.text = @"正在处理...";
        label.textAlignment = 1;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0];
        [_loadingView addSubview:label];
        
    }
    
    return _loadingView;
}



@end
