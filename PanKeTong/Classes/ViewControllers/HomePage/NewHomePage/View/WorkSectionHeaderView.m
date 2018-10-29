//
//  WorkSectionHeaderView.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/17.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "WorkSectionHeaderView.h"


@implementation WorkSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    _lineView.backgroundColor = [UIColor lightGrayColor];
    _lineView.alpha = 0.5;
    
}


@end
