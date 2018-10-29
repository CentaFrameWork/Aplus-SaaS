//
//  AddCustomerApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/1.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "AddCustomerApi.h"
#import "AddCustomerResultEntity.h"


@implementation AddCustomerApi


- (NSDictionary *)getBody
{
    _buyReasonKeyId = _buyReasonKeyId ? _buyReasonKeyId : @"";
    _inquiryPaymentTypeCode = _inquiryPaymentTypeCode ? _inquiryPaymentTypeCode :@"";
    _firstPayment = _firstPayment ? _firstPayment :@"";
    _houseTypes = _houseTypes ? _houseTypes : [NSArray array];
    _areaFrom = _areaFrom ? _areaFrom :@"";
    _areaTo = _areaTo ? _areaTo :@"";
    _decorationSituationKeyId = _decorationSituationKeyId ? _decorationSituationKeyId:@"";
    _propertyTypeKeyId = _propertyTypeKeyId ? _propertyTypeKeyId : @"";
    
    return @{
             @"ContactName":_contactName,
             @"GenderKeyId":_genderKeyId,
             @"MaritalStatusKeyId":_maritalStatusKeyId,
             @"Mobile":_mobile,
             @"InquiryTradeTypeCode":_inquiryTradeTypeCode,
             @"SalePriceFrom":_salePriceFrom,
             @"SalePriceTo":_salePriceTo,
             @"RentPriceFrom":_rentPriceFrom,
             @"RentPriceTo":_rentPriceTo,
             @"InquiryStatusKeyId":_inquiryStatusKeyId,
             @"MobileAttribution":_mobileAttribution,
             @"BuyReasonKeyId":_buyReasonKeyId,
             @"InquiryPaymentTypeCode":_inquiryPaymentTypeCode,
             @"FirstPayment":_firstPayment,
             @"HouseTypes":_houseTypes,
             @"AreaFrom":_areaFrom,
             @"AreaTo":_areaTo,
             @"DecorationSituationKeyId":_decorationSituationKeyId,
             @"PropertyTypeKeyId":_propertyTypeKeyId,
             };
}

//添加客户
- (NSString *)getPath {
    
    
    return @"customer/add-inquiry";

}


- (Class)getRespClass {
    return [AddCustomerResultEntity class];
}


@end
