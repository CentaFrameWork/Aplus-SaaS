//
//  PublishCusDetailBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"

#define TradeType               @"交易类型："
#define Status                  @"状       态："
#define CustomerRequirement     @"客户需求"
#define TargetArea              @"目标区域："
#define TargetEstates           @"目标楼盘："
#define HouseTypes              @"房       型："
#define RoomTypes               @"户       型："
#define HouseArea               @"面       积："
#define Floor                   @"楼       层："
#define SalePrice               @"心理购价："
#define RentPrice               @"心理租价："
#define PropertyUsage           @"房屋用途："
#define PropertyType            @"建筑类型："
#define HouseDirections         @"朝       向："
#define DecorationSituation     @"装修情况："
#define BuyReason               @"购房原因："
#define Emergency               @"紧迫度："
#define FamilySize              @"居住人口："
#define PayCommissionType       @"付拥方式："
#define InquiryPayment          @"付款方式："
#define Transportations         @"期望路线："
#define InquirySource           @"来       源："
#define RentExpireDate          @"租期至："

@interface PublishCusDetailBasePresenter : BasePresenter

@property (assign, nonatomic) id selfView;

- (instancetype)initWithDelegate:(id)delegate;

/// 获得页面字段array
- (NSArray *)getPublishCusTitleArray:(NSString *)tradeType;

/// 是否需要验证权限
- (BOOL)needCheckPermisstion;

@end

