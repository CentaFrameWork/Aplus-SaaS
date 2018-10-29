//
//  HeadView.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/13.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView {
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, self.height-35*NewRatio)];
    _bgImgView.image = [UIImage imageNamed:@"bannerImage"];
    _bgImgView.userInteractionEnabled = YES;
    [self addSubview:_bgImgView];

    // 城市
    _cityView = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityView.frame = CGRectMake(10, STATUS_BAR_HEIGHT + 10*NewRatio, 0, 0);
    [_cityView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cityView.titleLabel.font = [UIFont systemFontOfSize:16*NewRatio];
    [_cityView setImage:[UIImage imageNamed:@"H定位"] forState:UIControlStateNormal];
    NSString *string = [NSString stringWithFormat:@"  %@", [CommonMethod getUserdefaultWithKey:CorporationName]];
//    string = @"  优诺"; 
    [_cityView setTitle:string forState:UIControlStateNormal];
    [_cityView sizeToFit];
    [self addSubview:_cityView];

    // 扫一扫
    _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanBtn.frame = CGRectMake(APP_SCREEN_WIDTH - 50*NewRatio, _cityView.top-10*NewRatio, 50*NewRatio, 50*NewRatio);
    [_scanBtn setImage:[UIImage imageNamed:@"扫"] forState:UIControlStateNormal];
    [self addSubview:_scanBtn];

 

    // 搜索
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(10*NewRatio, self.height - 70*NewRatio, self.width - 20*NewRatio, 70*NewRatio);
    _searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -50*NewRatio, 0, 50*NewRatio);
    _searchBtn.backgroundColor = [UIColor clearColor];
    [_searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forState:UIControlStateNormal];
    [_searchBtn setTitle:@"  输入城区、片区、楼盘名" forState:UIControlStateNormal];
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:15*NewRatio];
    [self addSubview:_searchBtn];

}




@end
