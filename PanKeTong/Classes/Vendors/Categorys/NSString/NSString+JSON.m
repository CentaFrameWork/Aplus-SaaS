//
//  NSString+JSON.m
//  PanKeTong
//
//  Created by TailC on 16/4/7.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

/**
 *  解析JSON字符串，返回JSON字典
 *
 *  @return JSON字典
 */
- (NSDictionary *)jsonDictionaryFromJsonString
{
	if (!self)
    {
		return nil;
	}
	
	NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error;
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
	
	if (error)
    {
		NSLog(@"解析失败:%@",error);
		return nil;
	}
	
	return dict;
}

/**
 *  解析JSON字典
 *
 *  @param dict JSON字典
 *
 *  @return JSON字符串
 */
+ (NSString *)JSONStringFromJSONDictionary:(NSDictionary *)dict
{
	NSError *parseError = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
	
	return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/// 字典格式字符串转换为JSON串
- (NSString *)JSONString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];

    if ([jsonData length] > 0 && error == nil)
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        return jsonString;
    }
    else
    {
        return nil;
    }
}




@end
