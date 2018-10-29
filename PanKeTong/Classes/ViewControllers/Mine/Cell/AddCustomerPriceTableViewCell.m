//
//  AddCustomerPriceTableViewCell.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AddCustomerPriceTableViewCell.h"

@implementation AddCustomerPriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupLeftTitleWithString:(NSString *)title
{
    NSMutableAttributedString *leftTitleStr = [[NSMutableAttributedString alloc] initWithString:title];
    [leftTitleStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor redColor]
                         range:NSMakeRange(0, 1)];
    self.labelForKey.attributedText = leftTitleStr;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
