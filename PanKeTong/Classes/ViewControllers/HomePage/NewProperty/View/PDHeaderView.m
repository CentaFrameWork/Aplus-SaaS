//
//  HeaderView.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/21.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "PDHeaderView.h"

@implementation PDHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 加载UI
        [self initView];
    }
    return self;
}

- (void)initView
{
    // 房源图片背景图
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, self.height)];
    _bgImgView.userInteractionEnabled = YES;
    _bgImgView.image = [UIImage imageNamed:@"estateCheapDefaultDetailImg"];
    [self addSubview:_bgImgView];

    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, STATUS_BAR_HEIGHT)];
    topImgView.image = [UIImage imageNamed:@"PDtop"];
    [_bgImgView addSubview:topImgView];

    UIImageView *downImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100*WIDTH_SCALE2, APP_SCREEN_WIDTH, 170*WIDTH_SCALE2)];
    downImgView.image = [UIImage imageNamed:@"PDdown"];
    [_bgImgView addSubview:downImgView];


    // 返回按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, STATUS_BAR_HEIGHT + 5, 40, 40);
    [_backBtn setImage:[UIImage imageNamed:@"PDback"] forState:UIControlStateNormal];
//    [self addSubview:_backBtn];

    // 更多按钮
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(APP_SCREEN_WIDTH - 55, STATUS_BAR_HEIGHT + 5,40 , 40);
    [_moreBtn setImage:[UIImage imageNamed:@"PDMore"] forState:UIControlStateNormal];
//    [self addSubview:_moreBtn];

    // 标签文本
    _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 140*WIDTH_SCALE2, APP_SCREEN_WIDTH - 100, 100*WIDTH_SCALE2)];
    _label.numberOfLines = 0;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_label];

    // 图片
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - 65, 180*WIDTH_SCALE2, 20, 20*WIDTH_SCALE2)];
    imgView.image = [UIImage imageNamed:@"图片"];
    imgView.contentMode = UIViewContentModeCenter;
    [self addSubview:imgView];

    //图片数量
    _photoSumlLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right, 180*WIDTH_SCALE2, 30, 20*WIDTH_SCALE2)];
    _photoSumlLabel.textColor = [UIColor whiteColor];
    _photoSumlLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_photoSumlLabel];

    // 房源名称
    _propDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(YCAppMargin, 235*WIDTH_SCALE2, APP_SCREEN_WIDTH-2*YCAppMargin, 38*WIDTH_SCALE2)];
    _propDetailLabel.backgroundColor = [UIColor redColor];
    _propDetailLabel.textColor = [UIColor blackColor];
    _propDetailLabel.backgroundColor = [UIColor whiteColor];
    _propDetailLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _propDetailLabel.textAlignment = NSTextAlignmentCenter;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_propDetailLabel.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _propDetailLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    _propDetailLabel.layer.mask = maskLayer;
    [self addSubview:_propDetailLabel];

}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    // 绘制图片阴影
}



@end
