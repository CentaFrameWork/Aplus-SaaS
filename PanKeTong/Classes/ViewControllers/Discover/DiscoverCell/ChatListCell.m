//
//  ChatListCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/16.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ChatListCell.h"

@implementation ChatListCell


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    _badgeNumLabel.layer.masksToBounds = YES;
    _badgeNumLabel.layer.cornerRadius = 9.0;
}


@end
