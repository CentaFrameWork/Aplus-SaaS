//
//  ChannelCallTimeTableViewCell.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/19.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "ChannelCallTimeTableViewCell.h"

@implementation ChannelCallTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)dateStartTouch:(id)sender {
    if(_delegate)
    {
        [_delegate dateStartPick];
    }
}
- (IBAction)dateEndTouch:(id)sender {
    if(_delegate)
    {
        [_delegate dateEndPick];
    }
}

@end
