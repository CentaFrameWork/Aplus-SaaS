//
//  TrustAuditingCell.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/19.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "TrustAuditingCell.h"

@implementation TrustAuditingCell{
    __weak IBOutlet UILabel *_propertyInfoLabel;
    __weak IBOutlet UILabel *_propertyTypeAndDirectionLabel;
    __weak IBOutlet UILabel *_departNameLabel;
    __weak IBOutlet UILabel *_photoCount;
    __weak IBOutlet UILabel *_employeeLabel;
    __weak IBOutlet UILabel *_timeLabel;
}

- (void)setEntity:(SubRegisterTrustsEntity *)entity{
    if (_entity != entity) {
        _entity = entity;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

    _propertyInfoLabel.text = [NSString stringWithFormat:@"%@ %@",_entity.estateName,_entity.buildingName];
    if (_entity.houseDirection != nil && _entity.houseDirection.length > 0)
    {
        _propertyTypeAndDirectionLabel.text = [NSString stringWithFormat:@"%@  %@",_entity.houseType,_entity.houseDirection];
    }
    else
    {
        _propertyTypeAndDirectionLabel.text = _entity.houseType;

    }
    NSString *textStr = [NSString stringWithFormat:@"附件数量:%ld",[_entity.photoCount integerValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(5,textStr.length - 5)];
    _photoCount.attributedText = str;
    _departNameLabel.text = _entity.personDeptDepName;
    _employeeLabel.text = _entity.creatorPersonName;
    _timeLabel.text = [_entity.signDate substringToIndex:10];
}


@end
