//
//  NSDictionary+JSONTransfer.m
//  PanKeTong
//
//  Created by 苏军朋 on 16/4/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "NSDictionary+JSONTransfer.h"
#import <objc/runtime.h>

@implementation NSDictionary (JSONTransfer)

/// 字典转换为JSON串
- (NSString *)JSONString
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil)
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    else
    {
        return nil;
    }
}

@end
