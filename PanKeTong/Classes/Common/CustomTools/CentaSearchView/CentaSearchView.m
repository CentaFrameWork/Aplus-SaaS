//
//  CentaSearchView.m
//  PanKeTong
//
//  Created by 李慧娟 on 2018/2/9.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "CentaSearchView.h"

@implementation CentaSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.layer.cornerRadius = self.height / 2;
    self.layer.borderColor = SeparateLineColor.CGColor;
    self.layer.borderWidth = 1.0;

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, (self.height - 10)/2, 15, 10)];
    imgView.image = [UIImage imageNamed:@"search"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imgView];

    _mainTF = [[UITextField alloc] initWithFrame:CGRectMake(imgView.right, 0, self.width - 50, self.height)];
    _mainTF.backgroundColor = [UIColor clearColor];
    _mainTF.font = [UIFont systemFontOfSize:13.0];
    _mainTF.placeholder = @"请输入客户姓名";
    [self addSubview:_mainTF];

    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceBtn.frame = CGRectMake(_mainTF.right, 5, 20, self.height - 10);
    [_voiceBtn setImage:[UIImage imageNamed:@"语音"] forState:UIControlStateNormal];
    [self addSubview:_voiceBtn];
}
@end
