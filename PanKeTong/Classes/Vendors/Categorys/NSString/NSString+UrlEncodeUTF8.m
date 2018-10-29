//
//  NSString+UrlEncodeUTF8.m
//  URLHttpEncodeUTF8Demo
//
//  Created by plee on 15/7/10.
//  Copyright (c) 2015年 FengYun Technology. All rights reserved.
//

#import "NSString+UrlEncodeUTF8.h"

@implementation NSString (UrlEncodeUTF8)

/**
 *  对含有中文的URL进行普通编码
 *
 *  @param urlString 要编码的URL地址
 *
 *  @return 返回一个经过 中文UTF8编码之后的地址
 */
- (NSString *)encodeUrlWithUTF8_CN:(NSString *)urlString
{
    /**
     *  对URL的中文进行UTF8编码
     *  stringByAddingPercentEscapesUsingEncoding
     */
    urlString  = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return urlString;
}
/**
 *  编码特殊字符的UTF8
 *
 *  @param urlString <#urlString description#>
 *
 *  @return <#return value description#>
 */

- (NSString *)encodeToPercentEscapeString: (NSString *) urlString
{
    NSString *outputStr = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlString,NULL,(CFStringRef)@"!*'();:@&=+ $,/?%#[]",kCFStringEncodingUTF8));
    return outputStr;
}

//- (NSString *)encodeToPercentEscapeString:(NSString *)urlString
//{//
//    NSString *encodeString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault , (CFStringRef)urlString,NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));//kCFStringEncodingUTF8
////    CFRelease((__bridge CFTypeRef)(encodeString));
//
//    
//    return encodeString;
//}
/**
 *  解码URL地址路径
 *
 *  @param urlString 解码字符串
 *
 *  @return 返回解码后的原始地址
 */
- (NSString *)decodeFromPercentEscapeString:(NSString *)urlString{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:urlString];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}
@end
