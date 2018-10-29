//
//  FindIsExitAdApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FindIsExitAdApi.h"
#import "FindIsExitEntity.h"

@implementation FindIsExitAdApi

- (NSDictionary *)getBody
{
    return @{
             @"PropertyKeyId":_propertyKeyId,
             @"TradeType":_tradeType
             };
}



- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress])
    {
        return @"external/exist-property-advert";
    }
    
    return @"WebApiAdvert/FindExistPropertyById";
}


- (Class)getRespClass
{
    return [FindIsExitEntity class];
}

@end
