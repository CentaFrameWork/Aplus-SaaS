//
//  NSString+UrlEncodeUTF8.h
//  URLHttpEncodeUTF8Demo
//
//  Created by plee on 15/7/10.
//  Copyright (c) 2015年 FengYun Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UrlEncodeUTF8)

/**
 *  普通含有中文的编码格式
 *
 *  @param urlString 要编码的格式
 *
 *  @return 返回一个UTF8编码的URL地址
 */
- (NSString *)encodeUrlWithUTF8_CN:(NSString *)urlString;

/**
 *  使用CFStringRef进行UTF8编码
 *
 *  @param urlString 编码的字符串
 *
 *  @return 返回经过编码的字符串
 */
- (NSString *)encodeToPercentEscapeString:(NSString *)urlString;

/**
 *  解码URL地址
 *
 *  @param urlString 解码的地址字符串
 *
 *  @return 返回解码后的URL路径
 */
- (NSString *)decodeFromPercentEscapeString: (NSString *) urlString;


@end
