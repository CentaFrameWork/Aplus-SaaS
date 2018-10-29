//
//  HQAllRoundDetailBasicMsgCell.m
//  Calendar module
//
//  Created by 李慧娟 on 16/11/23.
//  Copyright © 2016年 luqinbin. All rights reserved.
//

#import "HQAllRoundDetailBasicMsgCell.h"

@implementation HQAllRoundDetailBasicMsgCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _propHouseType.text = @"房型：";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}
@end
