//
//  ApplyTransferEstSelectItemCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ApplyTransferEstSelectItemCell.h"

@implementation ApplyTransferEstSelectItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupLeftTitleWithString:(NSString *)title
			   rightLabelString:(NSString *)rightString{
	NSMutableAttributedString *leftTitleStr = [[NSMutableAttributedString alloc] initWithString:title];
	[leftTitleStr addAttribute:NSForegroundColorAttributeName
						 value:[UIColor redColor]
						 range:NSMakeRange(0, 1)];
	self.leftTitleLabel.attributedText = leftTitleStr;
	
	self.rightValueLabel.text = rightString;
	self.rightValueLabel.textColor = [UIColor colorWithRed:0.718  green:0.718  blue:0.718 alpha:1];
	self.rightValueLabel.textAlignment = NSTextAlignmentRight;
	
}

- (void)rightLabelWithString:(NSString *)str{
	
	self.rightValueLabel.text = str;
	self.rightValueLabel.textColor = [UIColor blackColor];
	self.rightValueLabel.textAlignment = NSTextAlignmentRight;

}

@end
