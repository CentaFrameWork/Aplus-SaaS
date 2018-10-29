//
//  EstReleaseDetailImgEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "EstReleaseDetailImgEntity.h"
#import "EstReleaseDetailImgResultEntity.h"
@implementation EstReleaseDetailImgEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"recordCount":@"RecordCount",
             @"records":@"Records",
             @"status":@"Status",
             @"statusMessage":@"StatusMessage",
             };
}
+(NSValueTransformer *)recordsJSONTransformer
{

    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[EstReleaseDetailImgResultEntity class]];
}
@end
