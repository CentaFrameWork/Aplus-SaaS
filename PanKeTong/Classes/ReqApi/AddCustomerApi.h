//
//  AddCustomerApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/1.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"
/// 添加客户
@interface AddCustomerApi : APlusBaseApi

@property (nonatomic,copy)NSString *contactName;                // 联系人姓名
@property (nonatomic,copy)NSString *genderKeyId;                // 联系人性别
@property (nonatomic,copy)NSString *maritalStatusKeyId;                // 客户婚姻情况
@property (nonatomic,copy)NSString *mobile;                     // 手机
@property (nonatomic,copy)NSString *inquiryTradeTypeCode;       // 客源交易类型（求购、求租、租购）Code 新增客源 编辑客源用
@property (nonatomic,copy)NSString *salePriceFrom;              // 售价区间
@property (nonatomic,copy)NSString *salePriceTo;                // 售价区间
@property (nonatomic,copy)NSString *rentPriceFrom;              // 租价区间
@property (nonatomic,copy)NSString *rentPriceTo;                // 租价区间
@property (nonatomic,copy)NSString *inquiryStatusKeyId;         // 客源状态KeyId
@property (nonatomic, copy)NSString *mobileAttribution;         // 区域选择

@property (nonatomic, copy) NSString *buyReasonKeyId;           // 购房原因
@property (nonatomic, copy) NSString *inquiryPaymentTypeCode;   // 付款方式  传code
@property (nonatomic, copy) NSString *firstPayment;             // 首付
@property (nonatomic, strong) NSArray *houseTypes;              //房型集合
@property (nonatomic, copy) NSString *areaFrom;
@property (nonatomic, copy) NSString *areaTo;
@property (nonatomic, copy) NSString *decorationSituationKeyId; // 装修情况
@property (nonatomic, copy) NSString *propertyTypeKeyId;        // 建筑类型

@end

