//
//  AllRoundDetailBasicMsgCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AllRoundDetailBasicMsgCell.h"
#import "CityCodeVersion.h"
@implementation AllRoundDetailBasicMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (![CityCodeVersion isTianJin])
    {
         _propHouseType.text = @"房型：";
    }
    
    if ([CityCodeVersion isChongQing])
    {
        _buildingAreaName.hidden = NO;
        _buildingAreaValue.hidden = NO;
        _practicalAreaName.hidden = NO;
        _practicalAreaValue.hidden = NO;
        _decorationSituationName.hidden = NO;
        _decorationSituationValue.hidden = NO;
        _houseUseingName.hidden = NO;
        _houseUseingValue.hidden = NO;
    }
    else
    {
        _buildingAreaName.hidden = YES;
        _buildingAreaValue.hidden = YES;
        _practicalAreaName.hidden = YES;
        _practicalAreaValue.hidden = YES;
        _decorationSituationName.hidden = YES;
        _decorationSituationValue.hidden = YES;
        _houseUseingName.hidden = YES;
        _houseUseingValue.hidden = YES;
    }
    
    for (UIView * subView in self.contentView.subviews) {

        if ([subView isKindOfClass:[UILabel class]]) {

            UILabel * tmpLabel = (UILabel *)subView;

            tmpLabel.font = [UIFont systemFontOfSize:13];

//            tmpLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;

        }

    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
