//
//  NSString+MD5Additions.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "NSString+MD5Additions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5Additions)

- (NSString *)md5
{
    const char *original_str = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_LONG originalLength = (CC_LONG)strlen(original_str);
    CC_MD5(original_str, originalLength, result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}


@end
