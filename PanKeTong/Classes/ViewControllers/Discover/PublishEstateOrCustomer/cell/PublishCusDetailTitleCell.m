//
//  PublishCusDetailTitleCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PublishCusDetailTitleCell.h"

@implementation PublishCusDetailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _cusDetailTitleLabel.font = [UIFont setFontSizeWithFontName:FontName
                                                        andSize:15.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
