//
//  JMTakeLookPropertyDetailCell.m
//  PanKeTong
//
//  Created by 陈行 on 2018/4/27.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMTakeLookPropertyDetailCell.h"

@implementation JMTakeLookPropertyDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProperty:(PropertyList *)property{
    
    _property = property;
    
    self.houseNameLabel.text = property.PropertyInfo;
    
    self.feedbackLabel.text = property.Content;
    
}

@end
