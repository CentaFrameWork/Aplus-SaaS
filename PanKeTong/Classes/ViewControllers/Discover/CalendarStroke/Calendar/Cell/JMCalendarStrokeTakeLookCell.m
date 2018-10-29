//
//  JMCalendarStrokeTakeLookCell.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMCalendarStrokeTakeLookCell.h"

#import "NSString+Extension.h"

@implementation JMCalendarStrokeTakeLookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.typeLabel setLayerCornerRadius:YCLayerCornerRadius];
    
}

- (void)setEntity:(SubTakingSeeEntity *)entity{
    
    _entity = entity;
    
    NSString * propertyInfo = @"";
    
    if (entity.propertyList.count > 0) {
        
        NSDictionary * dict = [entity.propertyList firstObject];
        
        propertyInfo = dict[@"PropertyInfo"];
        
    }
    
    self.contentLabel.text = [NSString stringWithFormat:@"%@：%@", entity.seePropertyType ? : @"", propertyInfo];
    
    self.customerNameLabel.text = entity.customerName;
    
    self.timeLabel.text = [NSString formattingYMdHmHTimeStr:entity.takeSeeTime];
    
}

@end
