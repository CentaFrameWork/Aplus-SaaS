//
//  NSString+MD5Additions.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5Additions)

/**
 *   MD5加密，传入需要加密的字符串，不可逆
 *
 *  @param str 需要加密的字符串
 *
 *  @return 加密后字符串
 */
- (NSString *)md5;

@end
