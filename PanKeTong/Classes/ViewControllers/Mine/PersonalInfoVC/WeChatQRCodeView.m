//
//  WeChatQRCodeView.m
//  PanKeTong
//
//  Created by zhwang on 16/4/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "WeChatQRCodeView.h"

//#define ShadowBackgroundColor [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.4f]

@implementation WeChatQRCodeView
{
    // 阴影view
    UIView *_bgShadowView;
    // 二维码图片
    UIImageView *_imageQRCode;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    
    return self;
}

/**
 *  弹出微信扫二维码
 */
- (void)showWeChatQRCode:(NSString *)imageUrl
{
    // 弹出背景色
    UITapGestureRecognizer *tapHideGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(hideView)];
    tapHideGesture.numberOfTapsRequired = 1;
    tapHideGesture.numberOfTouchesRequired = 1;
    _bgShadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    _bgShadowView.backgroundColor = ShadowBackgroundColor;
    [_bgShadowView addGestureRecognizer:tapHideGesture];
    [self addSubview:_bgShadowView];
    
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    
    UIView *viewQRCode=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    [viewQRCode setCenter:self.center];
    [viewQRCode setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:viewQRCode];
    
    // 显示二维码图片
    _imageQRCode=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [_imageQRCode sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                    placeholderImage:[UIImage imageNamed:@"user_img_QR-code"]];
    [viewQRCode addSubview:_imageQRCode];
}

- (void)hideView
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         _bgShadowView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];                         
                     }];
}

@end
