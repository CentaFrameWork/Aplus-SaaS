//
//  PropTrustorsInfo.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropTrustorsInfoEntity.h"

@implementation PropTrustorsInfoEntity


+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
             @"canBrowse":@"CanBrowse",
             @"noCallMessage":@"NoCallMessage",
             @"usedBrowseCount":@"UsedBrowseCount",
             @"remainingBrowseCount":@"RemainingBrowseCount",
             @"totalBrowseCount":@"TotalBrowseCount",
             @"trustors":@"Trustors",
             @"fictitiousNumberSwitch":@"FictitiousNumberSwitch",
             @"virtualCall":@"VirtualCall",
             @"callLimit":@"CallLimit"
             }];
}

+(NSValueTransformer *)trustorsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[TrustorEntity class]];
}



@end
