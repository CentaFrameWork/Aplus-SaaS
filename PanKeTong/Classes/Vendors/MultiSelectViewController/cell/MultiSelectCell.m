//
//  MultiSelectCell.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/20.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "MultiSelectCell.h"

@implementation MultiSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}



- (void)switchAction:(UISwitch *)Switch
{
    if ([self.delegate respondsToSelector:@selector(clickSwithAction:)]) {
        [self.delegate clickSwithAction:Switch];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
