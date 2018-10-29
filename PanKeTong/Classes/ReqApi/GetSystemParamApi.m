//
//  GetSystemParamApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetSystemParamApi.h"
#import "SystemParamEntity.h"

@implementation GetSystemParamApi


- (NSDictionary *)getBody
{
    _updateTime = _updateTime ? _updateTime : @"";
    return @{@"UpdateTime":_updateTime};
}

- (NSString *)getPath {
    
  return @"permission/update-parameter";
    
}


- (Class)getRespClass
{
    return [SystemParamEntity class];
}

- (int)getRequestMethod {
    
    return  RequestMethodPUT;
}

@end
