//
//  MyMessageListTableViewCell.m
//  PanKeTong
//
//  Created by wanghx17 on 15/12/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyMessageListTableViewCell.h"

@implementation MyMessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _unReadCountLabel.backgroundColor = YCThemeColorRed;
    [_unReadCountLabel setLayerCornerRadius:_unReadCountLabel.height/2];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
