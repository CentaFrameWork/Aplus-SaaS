//
//  AllRoundListCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/25.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AllRoundListCell.h"

@implementation AllRoundListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _propTitleLabel.font = [UIFont setFontSizeWithFontName:FontName
                                                   andSize:14.0];
    _propSupportLabel.font = [UIFont setFontSizeWithFontName:FontName
                                                     andSize:11.0];
    _propPriceLabel.font = [UIFont setFontSizeWithFontName:BoldFontName
                                                   andSize:16.0];
    _propAvgPriceLabel.font = [UIFont setFontSizeWithFontName:FontName
                                                      andSize:12.0];
    _propDetailMsgLabel.font = [UIFont setFontSizeWithFontName:FontName
                                                       andSize:10.0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
