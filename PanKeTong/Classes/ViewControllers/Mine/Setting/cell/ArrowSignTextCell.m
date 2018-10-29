//
//  ArrowSignTextCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ArrowSignTextCell.h"

@implementation ArrowSignTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _leftTextLabel.font = [UIFont setFontSizeWithFontName:FontName
                                                  andSize:15.0];
    _rightTextLabel.font = [UIFont setFontSizeWithFontName:FontName
                                                   andSize:14.0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
