//
//  RealSurveyReviedListEntity.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/18.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RealSurveyReviedListEntity.h"
#import "RealSurveyAuditingListEntity.h"

@implementation RealSurveyReviedListEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"result":@"Result",
                                          }];
}

+(NSValueTransformer *)resultJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[RealSurveyAuditingListEntity class]];
}

@end
