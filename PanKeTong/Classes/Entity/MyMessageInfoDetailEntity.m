//
//  MyMessageInfoDetailEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/12/2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyMessageInfoDetailEntity.h"

@implementation MyMessageInfoDetailEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSString *result = @"Result";
    
    if ([CommonMethod isRequestNewApiAddress])
    {
        result = @"MessageDetails";
    }
    
    return  @{
              @"result":result,
              @"recordCount":@"RecordCount",
              };
}

+(NSValueTransformer *)resultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MyMessageInfoDetailResultEntity class]];
}

@end
