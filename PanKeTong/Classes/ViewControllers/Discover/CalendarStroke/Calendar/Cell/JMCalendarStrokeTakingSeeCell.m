//
//  JMCalendarStrokeTakingSeeCell.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMCalendarStrokeTakingSeeCell.h"

#import "NSString+Extension.h"

@implementation JMCalendarStrokeTakingSeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.typeLabel setLayerCornerRadius:YCLayerCornerRadius];
    
}

- (void)setEntity:(SubTakingSeeEntity *)entity{
    
    _entity = entity;
    
    self.customerNameLabel.text = entity.customerName;
    
    self.customerPhoneNumLabel.text = entity.mobile;
    
    self.timeLabel.text = [NSString formattingYMdHmHTimeStr:entity.reserveTime];
    
}


@end
