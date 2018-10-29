//
//  JMCustomMessageCell.m
//  PanKeTong
//
//  Created by Admin on 2018/4/20.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMCustomMessageCell.h"

@implementation JMCustomMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.number setLayerCornerRadius:5];
    self.selectionStyle = 0;
    
}
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(12, 0, rect.size.width-24, 95)
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    [[UIColor whiteColor] set];
    [maskPath fill];
}


@end
