//
//  CheckRealProtectedDurationApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/2.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CheckRealProtectedDurationApi.h"
#import "CheckRealProtectedEntity.h"
@implementation CheckRealProtectedDurationApi


// 请求体参数
- (NSDictionary *)getBody
{
    return @{@"KeyId":_keyId};
}

- (NSString *)getPath {

    
    return @"property/check-real-protected-duration";
    
}


- (Class)getRespClass
{
    return [CheckRealProtectedEntity class];
}
- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
