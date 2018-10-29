//
//  ShowStaffImageView.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/12/9.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "ShowStaffImageView.h"

@interface ShowStaffImageView()
{
    // 阴影view
    UIView *_bgShadowView;
    // 员工图像
    UIImageView *_imageStaff;
}

@end

@implementation ShowStaffImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)showStaffImage:(NSString *)imgUrl {
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
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH-100, APP_SCREEN_WIDTH)];
    bgView.center = self.center;
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 7;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH-100, 60)];
    titleView.backgroundColor = [CommonMethod transColorWithHexStr:@"#FFF1F0"];
    
    NSString *staffName = [CommonMethod getUserdefaultWithKey:APlusUserName];
    UILabel *staffNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 150, 20)];
    staffNameLabel.text = staffName;
    staffNameLabel.font = [UIFont boldSystemFontOfSize:17];
    staffNameLabel.backgroundColor = [UIColor clearColor];
    [titleView addSubview:staffNameLabel];
    
    NSString *staffNo = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
    UILabel *staffNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(staffNameLabel.frame)+8, CGRectGetWidth(titleView.frame)-20, 20)];
    staffNoLabel.text = staffNo;
    staffNoLabel.font = [UIFont boldSystemFontOfSize:17];
    staffNoLabel.textColor = [UIColor lightGrayColor];
    staffNoLabel.backgroundColor = [UIColor clearColor];
    [titleView addSubview:staffNoLabel];
    
    [bgView addSubview:titleView];
    
    NSURL *staffImageUrl = [NSURL URLWithString:imgUrl];
    _imageStaff = [[UIImageView alloc] initWithFrame:CGRectMake(26, CGRectGetMaxY(titleView.frame)+15, bgView.frame.size.width-52, bgView.frame.size.height-90)];
    [_imageStaff sd_setImageWithURL:staffImageUrl];
    [bgView addSubview:_imageStaff];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
