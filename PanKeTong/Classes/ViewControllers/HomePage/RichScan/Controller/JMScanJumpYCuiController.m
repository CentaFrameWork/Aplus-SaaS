//
//  JMScanJumpYCuiController.m
//  PanKeTong
//
//  Created by Admin on 2018/6/14.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMScanJumpYCuiController.h"

@interface JMScanJumpYCuiController ()

@property (nonatomic,strong) UIView *QRCodeLogingView;//二维码登录
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSDictionary *dict;

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UIButton *btn1;
@end

@implementation JMScanJumpYCuiController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    if ([_url.host contains:@"qrcode"]) {
        
        [self requestQRCodeScan];
        
    }else{
        
        
    }
    
    
    
}


- (void)requestQRCodeScan {
    
    
    [self setNav];
    
    
    [AFUtils POST:QRCode_sacn parameters:_dict controller:self successfulDict:^(NSDictionary *successfuldict) {
        
        [self.view addSubview:self.QRCodeLogingView];
        
    } failureDict:^(NSDictionary *failuredict) {
        
        [self.view addSubview:self.QRCodeLogingView];
        self.imageV.image = [UIImage imageNamed:@"scanError"];
        self.label2.text = failuredict[@"ErrorMsg"];
        self.label2.textColor = rgba(230, 95, 95, 1);
        [self.btn1 setTitle:@"重新扫描" forState:UIControlStateNormal];
        
        
        
    } failureError:^(NSError *failureerror) {
        
    }];
    
}


#pragma mark -  ************二维码登录************
- (UIView *)QRCodeLogingView {
    
    if (!_QRCodeLogingView) {
        
       
        UILabel*(^Label)(CGRect,NSString*,CGFloat,int) = ^(CGRect rect , NSString*title,CGFloat titleSize,int number){
            
            UILabel *label = [[UILabel alloc] initWithFrame:rect];
            label.textAlignment = 1;
            label.text = title;
            label.font = [UIFont fontWithName:titleSize>16? @"Helvetica-Bold":@"Helvetica" size:titleSize];;
            label.textColor = UICOLOR_RGB_Alpha(number,1.0);
            return label;
        };
        
        UIButton*(^Button)(CGRect,NSString*,CGFloat,int,int) = ^(CGRect rect , NSString*title,CGFloat titleSize,int number,int titleColor){
            
            UIButton *btn = [[UIButton alloc] initWithFrame:rect];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:UICOLOR_RGB_Alpha(titleColor,1.0) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:titleSize];
            btn.backgroundColor = UICOLOR_RGB_Alpha(number,1.0);
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setLayerCornerRadius:5];
            
            
            return btn;
        };
        
        
        
        _QRCodeLogingView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH-280)*0.5, 80, 280, 140)];
        _imageV.image = [UIImage imageNamed:@"scanWait"];
        [_QRCodeLogingView addSubview:_imageV];
        
        
        
        CGFloat height = kDevice_Is_iPhone5?20:70*HeightRatio;
        UILabel* label1 = Label(CGRectMake(0, _imageV.bottom+height, APP_SCREEN_WIDTH, 44),@"原萃PC端登录确认",24,0x333333);
        [_QRCodeLogingView addSubview:label1];
        
        
        _label2 = Label(CGRectMake(0, label1.bottom, APP_SCREEN_WIDTH, 44),@"",18,0x333333);
        [_QRCodeLogingView addSubview:_label2];
        
        
        _btn1 = Button(CGRectMake(36, APP_Height_Bottom - 180, APP_SCREEN_WIDTH-72, 60),@"确认登录PC端",18,0x25A763,0xFFFFFF);
        [_QRCodeLogingView addSubview:_btn1];
        
        
        UIButton *btn2 = Button(CGRectMake(36, _btn1.bottom+12, APP_SCREEN_WIDTH-72, 60),@"取消登录",18,0xFFFFFF,0x999999);
        [_QRCodeLogingView addSubview:btn2];
        
        
    }
    return _QRCodeLogingView;
}


#pragma mark -  按钮点击
- (void)btnClick:(UIButton*)btn {
    
    if ([btn.currentTitle contains:@"确认"]) {
        
        [AFUtils POST:QRCode_login parameters:_dict
           controller:self successfulDict:^(NSDictionary *successfuldict) {
            
               [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failureDict:^(NSDictionary *failuredict) {
            
            
            self.imageV.image = [UIImage imageNamed:@"scanError"];
            self.label2.text = failuredict[@"ErrorMsg"];
            self.label2.textColor = rgba(230, 95, 95, 1);
            [self.btn1 setTitle:@"重新扫描" forState:UIControlStateNormal];
            
            
        } failureError:^(NSError *failureerror) {
            
        }];
        
    }else if([btn.currentTitle contains:@"重新"]) {
        

        [self back];
        
    }else{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}


- (instancetype)initWithUrlString:(NSString *)string {
    
    if (self = [super init]) {
        
        _url = [NSURL URLWithString:string];
        
        _dict = @{@"UserId":[_url.relativePath substringFromIndex:1],@"Token":[AgencyUserPermisstionUtil getToken]};
        
        
       
    }
    return self;
}

- (void)setNav {
    
    [self setNavTitle:@"扫码登录"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"back"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    
    [self.navigationController.navigationBar setShadowImage:nil];  
}

@end
