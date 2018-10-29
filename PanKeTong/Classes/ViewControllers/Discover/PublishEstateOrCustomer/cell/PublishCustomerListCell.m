//
//  PublishCustomerListCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PublishCustomerListCell.h"

@implementation PublishCustomerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _leftDetailLabel.font = [UIFont setFontSizeWithFontName:FontName
                                                    andSize:14.0];
    _leftSecondDetailLabel.font = [UIFont setFontSizeWithFontName:FontName
                                                          andSize:12.0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
