//
//  PropListEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropListEntity.h"

@implementation PropListEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    if ([CommonMethod isRequestNewApiAddress])
    {
        return [self getBaseFieldWithOthers:@{
                                              @"recordCount":@"RecordCount",
                                              @"propertysModel":@"Properties",
                                              @"permisstionsModel":@"PermisstionsModel",
                                              }];
    }
    
    return [self getBaseFieldWithOthers:@{
                                          @"recordCount":@"RecordCount",
                                          @"propertysModel":@"PropertysModel",
                                          @"permisstionsModel":@"PermisstionsModel",
                                          }];
}




+(NSValueTransformer *)propertysModelJSONTransformer
{

    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PropertysModelEntty class]];
}


+(NSValueTransformer *)permisstionsModelJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PropPermisstionsModelEntity class]];
}

@end
