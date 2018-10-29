//
//  CustomerDetailEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "CustomerContacts.h"

@interface CustomerDetailEntity : AgencyBaseEntity

@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, assign) NSInteger takeSeeCount;          // 带看次数
@property (nonatomic, copy) NSString *inquiryTradeType;        // 交易类型
@property (nonatomic, copy) NSString *houseType;               // 房型
@property (nonatomic, copy) NSString *area;                    // 面积
@property (nonatomic, copy) NSString *houseDirection;          // 朝向
@property (nonatomic, copy) NSString *roomType;                // 户型
@property (nonatomic, copy) NSString *houseFloor;              // 楼层
@property (nonatomic, copy) NSString *inquiryPaymentType;      // 付款方式
@property (nonatomic, copy) NSString *targetEstates;           // 目标楼盘
@property (nonatomic, copy) NSString *emergency;               // 紧迫度
@property (nonatomic, copy) NSString *familySize;              // 居住人口
@property (nonatomic, copy) NSString *transportations;         // 期望路线
@property (nonatomic, copy) NSString *payCommissionType;       // 付拥方式
@property (nonatomic, copy) NSString *propertyType;            // 建筑类型
@property (nonatomic, copy) NSString *rentExpireDate;          // 租期至
@property (nonatomic, copy) NSString *decorationSituation;     // 装修状况
@property (nonatomic, copy) NSString *inquirySource;           // 来源
@property (nonatomic, copy) NSString *salePrice;               // 购价
@property (nonatomic, copy) NSString *rentPrice;               // 租价
@property (nonatomic, copy) NSString *buyReason;               // 购房原因
@property (nonatomic, copy) NSString *propertyUsage;           // 房屋用途
@property (nonatomic, copy) NSString *chiefDeptKeyId;          // 归属部门
@property (nonatomic, copy) NSString *chiefKeyId;              // 归属人
@end
