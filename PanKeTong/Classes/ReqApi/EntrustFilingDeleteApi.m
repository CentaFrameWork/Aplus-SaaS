//
//  EntrustFilingDeleteApi.m
//  PanKeTong
//
//  Created by 张旺 on 2017/8/2.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "EntrustFilingDeleteApi.h"

@implementation EntrustFilingDeleteApi

- (NSDictionary *)getBody
{
    NSDictionary *dic = @{
                          @"KeyId":_keyId,
                          @"IsMobileRequest":@"true",
                          };
    return dic;
}

- (NSString *)getPath {
    return @"property/property-trust-record-remove";
}

- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodDELETE;
}

@end
