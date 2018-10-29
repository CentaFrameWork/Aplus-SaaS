//
//  SectionFooterBtn.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/25.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "SectionFooterBtn.h"

@implementation SectionFooterBtn

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self setImage:[UIImage imageNamed:@"icon_jm_show_more_under"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_jm_show_more_on"] forState:UIControlStateSelected];
        [self setTitle:@"展开" forState:UIControlStateNormal];
        [self setTitle:@"收起" forState:UIControlStateSelected];
//        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -13, -14, 0)];// 标题
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];// 图片

        [self setTitleColor:YCTextColorAuxiliary forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight];
    }

    return self;
}

@end
