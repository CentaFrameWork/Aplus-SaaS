//
//  GetTrustorListEntity.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/20.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "GetTrustorListEntity.h"
#import "OwnerEntity.h"


@implementation GetTrustorListEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"trustors":@"Trustors"
                                          }];
}


+(NSValueTransformer *)trustorsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[OwnerEntity class]];
}
@end
