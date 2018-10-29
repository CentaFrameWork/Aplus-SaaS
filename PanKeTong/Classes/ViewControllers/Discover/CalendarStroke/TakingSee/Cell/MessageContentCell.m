//
//  MessageContentCell.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/5.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "MessageContentCell.h"

@implementation MessageContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_mobanBtn setImage:[UIImage imageNamed:@"kuang1"] forState:UIControlStateSelected];
    [_mobanBtn setTitle:@"  使用模版" forState:UIControlStateSelected];
}


#pragma mark-是否适用模版
- (IBAction)selectMobanAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
