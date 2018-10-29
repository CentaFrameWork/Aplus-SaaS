//
//  ChannelStaffFilterTableViewCell.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/19.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "ChannelStaffFilterTableViewCell.h"

@implementation ChannelStaffFilterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)textFeildClick:(id)sender {
    if(self.delegate)
    {
        [self.delegate textFeildPressedWithSender:self];
    }
}

@end
