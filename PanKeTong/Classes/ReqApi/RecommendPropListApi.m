//
//  RecommendPropListApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RecommendPropListApi.h"
#import "PropListEntity.h"

@implementation RecommendPropListApi

- (NSDictionary *)getBody
{
    return @{
             @"GetCount":@"5"
             };
}


- (NSString *)getPath {
    
    
    return @"property/recommends";
 
}


- (Class)getRespClass
{
    return [PropListEntity class];
}
- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
