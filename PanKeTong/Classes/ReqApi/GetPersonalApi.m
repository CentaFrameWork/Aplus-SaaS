//
//  GetPersonalApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetPersonalApi.h"
#import "PersonalInfoEntity.h"

@implementation GetPersonalApi

- (NSDictionary *)getBody {
    return @{
             @"staffNo":_staffNo ? : @"",
             @"cityCode":_cityCode ? : @""
             };
    
}


- (NSString *)getPath {
    
    
    return @"permission/user-info";
    
}


- (Class)getRespClass
{
    return [PersonalInfoEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}



@end
