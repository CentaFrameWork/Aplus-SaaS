//
//  OwnerEntity.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/20.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "OwnerEntity.h"

@implementation OwnerEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"keyId":@"KeyId",
             @"trustorName":@"TrustorName",
             @"trustorType":@"TrustorType",
             @"mobile":@"Mobile",
             @"tel":@"Tel",
             @"remark":@"Remark",
             @"lastCallTime":@"LastCallTime",
             @"maxCallerTimespan":@"MaxCallerTimespan",
             @"callCount":@"CallCount",
             @"noCallerCount":@"NoCallerCount",
             @"shortCount":@"shortCount",
             @"longCount":@"LongCount",
             @"shortCallMobile":@"ShortCallMobile",
             @"shortCallTel":@"ShortCallTel",
             @"longCallMobile":@"LongCallMobile",
             @"longCallTel":@"LongCallTel"
             };
    
}

@end
