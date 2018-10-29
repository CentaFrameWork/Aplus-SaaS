//
//  RentalPricesCell.m
//  PanKeTong
//
//  Created by zhwang on 16/4/21.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RentalPricesCell.h"
#define PHONE_PLACEHOLDER_COLOR                    [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0f]

@implementation RentalPricesCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [_rightPricesTextField setValue:PHONE_PLACEHOLDER_COLOR forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
