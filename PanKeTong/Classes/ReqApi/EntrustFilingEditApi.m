//
//  EntrustFilingEditApi.m
//  PanKeTong
//
//  Created by 张旺 on 2017/7/28.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "EntrustFilingEditApi.h"

@implementation EntrustFilingEditApi

- (NSDictionary *)getBody
{
    NSDictionary *dic = @{
                          @"KeyId":_keyId,
                          @"IsMobileRequest":@"true",
                          };
    return dic;
}

- (NSString *)getPath
{
    return @"property/trust-record";
}

- (Class)getRespClass
{
    return [EntrustFilingEditEntity class];
}


- (int)getRequestMethod {
    
    return RequestMethodGET;
}
@end
