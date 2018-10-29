//
//  AllRoundDetailMoreItemCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AllRoundDetailMoreItemCell.h"
#import "CityCodeVersion.h"

@implementation AllRoundDetailMoreItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if([CityCodeVersion isShenZhen])
    {
        _signedExclusive.text = @"签约";
    }
    else
    {
        _signedExclusive.text = @"独家";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
