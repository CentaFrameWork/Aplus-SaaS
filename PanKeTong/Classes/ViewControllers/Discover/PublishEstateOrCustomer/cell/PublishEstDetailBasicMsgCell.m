//
//  PublishEstDetailBasicMsgCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PublishEstDetailBasicMsgCell.h"
#import "PublishCusDetailPageMsgEntity.h"
#import "PublishCusDetailBasePresenter.h"



@implementation PublishEstDetailBasicMsgCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _leftTitleLabel.font = [UIFont setFontSizeWithFontName:FontName andSize:15.0];
    _rightValueLabel.font = [UIFont setFontSizeWithFontName:FontName  andSize:15.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPublishCusTitleArray:(NSArray *)publishCusTitleArray
{
    _publishCusTitleArray = publishCusTitleArray;
}

- (void)setPublishCusDetailPageMsgEntity:(PublishCusDetailPageMsgEntity *)publishCusDetailPageMsgEntity
{
    _publishCusDetailPageMsgEntity = publishCusDetailPageMsgEntity;
    
    NSString *leftTitleText = [_publishCusTitleArray objectAtIndex:_indexPath.row-1];
    self.leftTitleLabel.text = leftTitleText;
    NSString *rightValueStr;
    
    if ([leftTitleText isEqualToString:TradeType])
    {
        // 交易类型
        rightValueStr = _publishCusDetailPageMsgEntity.inquiryTradeType;
    }
    else if ([leftTitleText isEqualToString:Status])
    {
        // 状态
        rightValueStr = _publishCusDetailPageMsgEntity.inquiryStatus;
    }
    else if ([leftTitleText isEqualToString:CustomerRequirement])
    {
        // 客户需求
    }
    else if ([leftTitleText isEqualToString:TargetArea])
    {
        // 目标区域
        rightValueStr = [NSString stringWithFormat:@"%@%@",
                         _publishCusDetailPageMsgEntity.districts?_publishCusDetailPageMsgEntity.districts:@"",
                         _publishCusDetailPageMsgEntity.areas?_publishCusDetailPageMsgEntity.areas:@""];
    }
    else if ([leftTitleText isEqualToString:TargetEstates])
    {
        // 目标楼盘
        rightValueStr = _publishCusDetailPageMsgEntity.targetEstates;
    }
    else if ([leftTitleText isEqualToString:HouseTypes])
    {
        // 房型
        rightValueStr = _publishCusDetailPageMsgEntity.houseTypes;
    }
    else if ([leftTitleText isEqualToString:RoomTypes])
    {
        // 户型
        rightValueStr = _publishCusDetailPageMsgEntity.roomTypes;
    }
    else if ([leftTitleText isEqualToString:HouseArea])
    {
        // 面积
        rightValueStr = _publishCusDetailPageMsgEntity.houseArea;
    }
    else if ([leftTitleText isEqualToString:SalePrice])
    {
        // 心理购价
        rightValueStr = _publishCusDetailPageMsgEntity.salePrice;
    }
    else if ([leftTitleText isEqualToString:RentPrice])
    {
        // 心里租价
        rightValueStr = _publishCusDetailPageMsgEntity.rentPrice;
    }
    else if ([leftTitleText isEqualToString:PropertyUsage])
    {
        // 房屋用途
        rightValueStr = _publishCusDetailPageMsgEntity.propertyUsage;
    }
    else if ([leftTitleText isEqualToString:PropertyType])
    {
        // 建筑类型
        rightValueStr = _publishCusDetailPageMsgEntity.propertyType;
    }
    else if ([leftTitleText isEqualToString:HouseDirections])
    {
        // 朝向
        rightValueStr = _publishCusDetailPageMsgEntity.houseDirections;
    }
    else if ([leftTitleText isEqualToString:DecorationSituation])
    {
        // 装修情况
        rightValueStr = _publishCusDetailPageMsgEntity.decorationSituation;
    }
    else if ([leftTitleText isEqualToString:BuyReason])
    {
        // 购房原因
        rightValueStr = _publishCusDetailPageMsgEntity.buyReason;
    }
    else if ([leftTitleText isEqualToString:Emergency])
    {
        // 紧迫度
        rightValueStr = _publishCusDetailPageMsgEntity.emergency;
    }
    else if ([leftTitleText isEqualToString:FamilySize])
    {
        // 居住人口
        rightValueStr = _publishCusDetailPageMsgEntity.familySize;
    }
    else if ([leftTitleText isEqualToString:PayCommissionType])
    {
        // 付佣方式
        rightValueStr = _publishCusDetailPageMsgEntity.payCommissionType;
    }
    else if ([leftTitleText isEqualToString:InquiryPayment])
    {
        // 付款方式
        rightValueStr = _publishCusDetailPageMsgEntity.inquiryPayment;
    }
    else if ([leftTitleText isEqualToString:Transportations])
    {
        // 期望路线
        rightValueStr = _publishCusDetailPageMsgEntity.transportations;
    }
    else if ([leftTitleText isEqualToString:InquirySource])
    {
        // 来源
        rightValueStr = _publishCusDetailPageMsgEntity.inquirySource;
    }
    else if ([leftTitleText isEqualToString:RentExpireDate])
    {
        // 租期至
        rightValueStr = _publishCusDetailPageMsgEntity.rentExpireDate;
    }
    else if ([leftTitleText isEqualToString:Floor])
    {
        // 楼层
        rightValueStr = _publishCusDetailPageMsgEntity.floor;
    }
    
    self.rightValueLabel.text = rightValueStr;
}

@end
