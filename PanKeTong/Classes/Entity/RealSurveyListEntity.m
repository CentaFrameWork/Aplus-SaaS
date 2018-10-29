//
//  RealSurveyListEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "RealSurveyListEntity.h"

@implementation RealSurveyListEntity


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"realSurveys":@"RealSurveys"
                                          }];
}

+(NSValueTransformer *)realSurveysJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[RealSurveyEntity class]];
}


@end
