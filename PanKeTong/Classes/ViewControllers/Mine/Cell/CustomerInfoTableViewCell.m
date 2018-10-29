//
//  CustomerInfoTableViewCell.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomerInfoTableViewCell.h"

@implementation CustomerInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
