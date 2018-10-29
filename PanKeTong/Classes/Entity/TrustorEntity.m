//
//  TrustorEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "TrustorEntity.h"

@implementation TrustorEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"trustorName":@"TrustorName",
             @"trustorType":@"TrustorType",
             @"trustorMobile":@"Mobile",
             @"keyId":@"KeyId",
             @"tel" : @"Tel",
             @"trustorTypeKeyId" : @"TrustorTypeKeyId",
             };
}

@end
