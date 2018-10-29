//
//  PhoneNumberCell.m
//  PanKeTong
//
//  Created by zhwang on 16/4/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PhoneNumberCell.h"
#define PHONE_PLACEHOLDER_COLOR                    [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0f]

@implementation PhoneNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [_rightPhoneTextField setValue:PHONE_PLACEHOLDER_COLOR forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
