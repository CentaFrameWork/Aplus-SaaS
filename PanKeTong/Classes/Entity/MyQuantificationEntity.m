//
//  MyQuantificationEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyQuantificationEntity.h"

@implementation MyQuantificationEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
        return @{
             @"operateResult":@"OperateResult",
             @"newPropertysCount":@"NewPropertysCount",
             @"newInquirysCount":@"NewInquirysCount",
             @"newKeysCount":@"NewKeysCount",
             @"newRealsCount":@"NewRealsCount",
             @"newOnlyTrustsCount":@"NewOnlyTrustsCount",
             @"newTakeSeesCount":@"NewTakeSeesCount",
             @"newPropertyFollowsCount":@"NewPropertyFollowsCount",
             @"newyInquiryFollowsCount":@"NewyInquiryFollowsCount",
            };
    
}


+(NSValueTransformer *)operateResultJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[OperateResultEntity class]];
}
@end
