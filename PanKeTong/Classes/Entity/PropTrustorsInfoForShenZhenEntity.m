//
//  PropTrustorsInfoForShenZhenEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/4/20.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PropTrustorsInfoForShenZhenEntity.h"

@implementation PropTrustorsInfoForShenZhenEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"canBrowse":@"CanBrowse",
                                          @"noCallMessage":@"NoCallMessage",
                                          @"usedBrowseCount":@"UsedBrowseCount",
                                          @"remainingBrowseCount":@"RemainingBrowseCount",
                                          @"totalBrowseCount":@"TotalBrowseCount",
                                          @"telephoneExchange":@"TelephoneExchange",
                                          @"trustors":@"Trustors",
                                          @"virtualCall":@"VirtualCall",
                                          @"callLimit":@"CallLimit"
                                          }];
}

+(NSValueTransformer *)trustorsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[TrustorShenZhenEntity class]];
}


@end
