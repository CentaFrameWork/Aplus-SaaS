//
//  ReleaseEstListEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/20.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ReleaseEstListEntity.h"
#import "ReleaseEstListResultEntity.h"

@implementation ReleaseEstListEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSString *advertProperties = @"AdvertPropertys";
    
    if ([CommonMethod isRequestFinalApiAddress])
    {
        advertProperties = @"AdvertProperties";
    }
    
    return @{
            @"recordCount":@"RecordCount",
            @"advertPropertys":advertProperties,
            @"errorMsg":@"ErrorMsg",
            @"runTime":@"RunTime",
            @"flag":@"Flag",
             };
}
+(NSValueTransformer *)advertPropertysJSONTransformer
{

    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[ReleaseEstListResultEntity class]];
}
@end
