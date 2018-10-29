//
//  PropetyRealSettingApi.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "PropetyRealSettingApi.h"
#import "PropetyRealSettingEntity.h"

@implementation PropetyRealSettingApi

- (NSString *)getPath {

    
    return @"property/real-survey-setting";
    
}

- (Class)getRespClass {
    return [PropetyRealSettingEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
