//
//  TrustorShenZhenEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/4/20.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "TrustorShenZhenEntity.h"

@implementation TrustorShenZhenEntity


+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"trustorName":@"TrustorName",
             @"trustorType":@"TrustorType",
             @"mobile":@"Mobile",
             @"tel":@"Tel",
             @"remark":@"Remark",
             @"lastCallTime":@"LastCallTime",
             @"maxCallerTimespan":@"MaxCallerTimespan",
             @"callCount":@"CallCount",
             @"noCallerCount":@"NoCallerCount",
             @"shortCount":@"ShortCount",
             @"longCount":@"LongCount",
             @"shortCallMobile":@"ShortCallMobile",
             @"shortCallTel":@"ShortCallTel",
             @"longCallMobile":@"LongCallMobile",
             @"longCallTel":@"LongCallTel",
             @"keyId":@"KeyId"
             };
}




@end
