//
//  PublishCusDetailHZPresenter.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/6/29.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "PublishCusDetailZJPresenter.h"

@implementation PublishCusDetailZJPresenter

/// 获得页面字段array
- (NSArray *)getPublishCusTitleArray:(NSString *)tradeType
{
    
    NSMutableArray *publishCusTitleArray = [[NSMutableArray alloc]initWithObjects:
                                            TradeType,
                                            Status,
                                            CustomerRequirement,
                                            TargetArea,
                                            TargetEstates,
                                            HouseTypes,
                                            HouseArea,
                                            SalePrice,
                                            RentPrice,
                                            RentExpireDate,
                                            PropertyUsage,
                                            PropertyType,
                                            HouseDirections,
                                            DecorationSituation,
                                            BuyReason,
                                            Emergency,
                                            FamilySize,
                                            PayCommissionType,
                                            InquiryPayment,
                                            Transportations,
                                            InquirySource,nil];
    
    
    if ([tradeType isEqualToString:@"求租"])
    {
        [publishCusTitleArray removeObject:SalePrice];
        [publishCusTitleArray removeObject:InquiryPayment];
        [publishCusTitleArray removeObject:BuyReason];
    }
    else if ([tradeType isEqualToString:@"求购"])
    {
        [publishCusTitleArray removeObject:RentPrice];
        [publishCusTitleArray removeObject:PayCommissionType];
        [publishCusTitleArray removeObject:RentExpireDate];
    }

    return publishCusTitleArray;
}

/// 是否需要验证权限
- (BOOL)needCheckPermisstion
{
    return YES;
}


@end
