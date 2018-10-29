//
//  GetPropertyDetailApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/28.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "GetPropertyDetailApi.h"
#import "EditPropertyDetailEntity.h"

@implementation GetPropertyDetailApi

- (NSDictionary *)getBody
{

    return @{
             @"KeyId":_propertyKeyId
             };
}



- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"property/detail-edit";
    }
    return @"WebApiProperty/prop_detail_edit";
}


- (Class)getRespClass
{
    return [EditPropertyDetailEntity class];
}


@end
