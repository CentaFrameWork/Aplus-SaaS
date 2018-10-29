//
//  RealSurveySearchApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/2.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RealSurveySearchApi.h"
#import "SearchPropEntity.h"

@implementation RealSurveySearchApi

- (NSDictionary *)getBody
{
    return @{
             @"Name":_name?[_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:@"",
             @"TopCount":_topCount,
             @"EstateSelectType":_estateSelectType,
             @"BuildName":_buildName?[_buildName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:@""
             };
    
}

-   (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"property/auto-estate";
    }
    
    return @"WebApiProperty/get_Prop_param_hint";
}


- (Class)getRespClass
{
    return [SearchPropEntity class];
}

- (int)getRequestMethod{
    
    return RequestMethodGET;
    
}


@end

