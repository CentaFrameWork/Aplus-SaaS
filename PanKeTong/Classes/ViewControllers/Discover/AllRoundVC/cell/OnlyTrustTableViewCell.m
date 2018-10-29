//
//  OnlyTrustTableViewCell.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "OnlyTrustTableViewCell.h"
#import "PropOnlyTrustEntity.h"

@implementation OnlyTrustTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPropOnlyTrustEntity:(PropOnlyTrustEntity *)propOnlyTrustEntity
{
    _propOnlyTrustEntity = propOnlyTrustEntity;
    
    self.onlyTrustPerson.text = propOnlyTrustEntity.onlyTrustPerson;
    self.onlyTrustType.text = propOnlyTrustEntity.onlyTrustType;
    self.effectiveDate.text = propOnlyTrustEntity.effectiveDate;
}

@end
