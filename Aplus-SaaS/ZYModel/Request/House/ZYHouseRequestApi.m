//
//  ZYHouseRequestApi.m
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHouseRequestApi.h"

#import "ZYHousePageFunc.h"

@implementation ZYHouseRequestApi

- (NSString *)getReqUrl{
    
    return URL_HOMEPAGE_GET_FUNC;
    
}

- (Class)getRespClass{
    
    return [ZYHousePageFunc class];
    
}

- (int)getRequestMethod{
    
    return RequestMethodGET;
    
}

@end
