//
//  NSString+Extension.h
//  新浪微博
//
//  Created by xc on 15/3/6.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/// 文字过滤表情
+ (NSString *)filterEmoji:(NSString *)str;

/// 获取房源租售类型
+ (NSString *)getTrustTypeWith:(NSInteger)trustType;

/// 是否以……开头
- (BOOL)startWith:(NSString *)child;

/// 是否以……结尾
- (BOOL)endWith:(NSString *)child;

/// 是否包含……
- (BOOL)contains:(NSString *)child;

/// 是否是nil或@""
+ (BOOL)isNilOrEmpty:(NSString *)string;

/// 是否全部是空格
+ (BOOL)isEmptyWithLineSpace:(NSString *)string;

/// 是否含有emoji
+ (BOOL)stringContainsEmoji:(NSString *)string;

/// 判断是否为浮点型
+ (BOOL)isPureFloat:(NSString *)string;

/// 判断是否为整形
+ (BOOL)isPureInt:(NSString *)string;

/// 是否为数字
+ (BOOL)isNum:(NSString *)checkedNumString;

/// 返回的格式 周几
- (NSString *)weekDayFormDate;

/// 字符串为nil时，转化为@"",
+ (NSString *)nilToEmptyWithStr:(id)str;

/**
 *  将字符串进行编码
 *  codingType:编码方式
 */
- (NSString *)encodeWithCodingType:(NSStringEncoding)codingType;

/**
 *  将字符串进行解码
 *  codingType:编码方式
 */
- (NSString *)decodeWithCodingType:(NSStringEncoding)codingType;
//我问问
- (BOOL)isValidUrl;


/**
 *  返回年月日时分秒
 */
+ (NSString *)formattingYMdHmsHTimeStr:(NSString *)timeStr;
/**
 *  返回年月日时分
 */
+ (NSString *)formattingYMdHmHTimeStr:(NSString *)timeStr;

@end
