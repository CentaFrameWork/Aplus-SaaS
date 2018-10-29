//
//  PublishCusDetailBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "PublishCusDetailBasePresenter.h"

@implementation PublishCusDetailBasePresenter

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self)
    {
        _selfView = delegate;
    }
    return self;
}

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
    }
    else if ([tradeType isEqualToString:@"求购"])
    {
        [publishCusTitleArray removeObject:RentPrice];
    }

    return publishCusTitleArray;
}

/// 是否需要验证权限
- (BOOL)needCheckPermisstion
{
    return NO;
}

@end
