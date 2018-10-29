//
//  DascomGetNumbeApi.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/22.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "DascomGetNumbeApi.h"
#import "DascomGetPhoneEntity.h"

@implementation DascomGetNumbeApi

- (NSString *)getPath
{    
    if ([self isAplusPath])
    {
        if ([CommonMethod isRequestNewApiAddress])
        {
            return @"get-virtual-phone";
        }
        
        return @"dascom_get_number";
    }
    
    return  @"GetSsmnNumber.do";
}

- (Class)getRespClass
{
    return [DascomGetPhoneEntity class];
}




@end
