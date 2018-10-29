//
//  MoreTopView.m
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/17.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "MoreTopView.h"
#import "APPConfigEntity.h"

@implementation MoreTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initView];
    }

    return self;
}

- (void)initView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*NewRatio, (self.height - 20*NewRatio)/2, 70*NewRatio, 20*NewRatio)];
    titleLabel.font = [UIFont systemFontOfSize:15*NewRatio];
    titleLabel.textColor = MainGrayFontColor;
    titleLabel.text = @"首页应用";
    [self addSubview:titleLabel];

    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(APP_SCREEN_WIDTH - 40*NewRatio, (self.height - 50*NewRatio)/2, 40*NewRatio, 50*NewRatio);
    [_moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    _moreBtn.hidden = YES;
    [self addSubview:_moreBtn];

}

- (void)setHomeArr:(NSArray *)homeArr
{
    if (_homeArr != homeArr)
    {
        _homeArr = homeArr;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    // 绘制图片(最多7个)
    if (_homeArr.count > 0)
    {
        NSInteger minCount = MIN(_homeArr.count, 7);
        for (int i = 0; i < minCount; i++)
        {
            APPLocationEntity *entity = _homeArr[i];
            CGFloat width = (APP_SCREEN_WIDTH - 160*NewRatio) / 7;
            CGRect rect =  CGRectMake((width + 5*NewRatio) * i + 85*NewRatio, (60*NewRatio - width) / 2, width, width);

            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:entity.iconUrl]]];

            [image drawInRect:rect];
        }
    }
}

@end
