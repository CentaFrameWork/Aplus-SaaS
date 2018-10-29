//
//  NSString+JSON.h
//  PanKeTong
//
//  Created by TailC on 16/4/7.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

/**
 *  解析JSON字符串，返回JSON字典
 *
 *  @return JSON字典
 */
- (NSDictionary *)jsonDictionaryFromJsonString;

/**
 *  解析JSON字典
 *
 *  @param dict JSON字典
 *
 *  @return JSON字符串
 */
+ (NSString *)JSONStringFromJSONDictionary:(NSDictionary *)dict;

/**
 *
 *  字典格式字符串转换为JSON串
 *
 */
- (NSString *)JSONString;


@end
