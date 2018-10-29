//
//  CheckTrustEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/31.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CheckTrustEntity.h"

@implementation CheckTrustEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    if ([CommonMethod isRequestNewApiAddress])
    {
        return [self getBaseFieldWithOthers:@{
                                              @"attachmentModels":@"Attachments"
                                              }];
    }
    return [self getBaseFieldWithOthers:@{
                                          @"attachmentModels":@"AttachmentModels"
                                          }];
}

+(NSValueTransformer *)attachmentModelsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubCheckTrustEntity class]];
}



@end
