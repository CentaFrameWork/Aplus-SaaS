//
//  NSString+Extension.m
//  新浪微博
//
//  Created by xc on 15/3/6.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/// 文字过滤表情
+ (NSString *)filterEmoji:(NSString *)string
{
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [string UTF8String];
    char *newUTF8 =malloc(sizeof(char)*len);
    int j = 0;

    for (int i =0; i < len; i++)
    {
        unsigned int c = utf8[i];
        BOOL isControlChar = NO;

        if (c == 4294967280)
        {
            i = i+3;
            isControlChar = YES;
        }

        if (!isControlChar)
        {
            newUTF8[j] = utf8[i];
            j++;
        }
    }

    newUTF8[j] = '\0';
    
    NSString *encrypted = [[NSString alloc]initWithCString:(const char*)newUTF8 encoding:NSUTF8StringEncoding];
    
    return encrypted;
}

///  获取房源租售类型
+ (NSString *)getTrustTypeWith:(NSInteger)trustType
{
    if (trustType == SALE)
    {
        return @"看售";
    }
    else if (trustType == RENT)
    {
        return @"看租";
    }
    else if (trustType == BOTH)
    {
        return @"看租售";
    }
    else if (trustType == RENTBOTH)
    {
        return @"看租 看租售";
    }
    else if (trustType == SALEBOTH)
    {
        return @"看售 看租售";
    }
    else if (trustType == ALLBOTH)
    {
        return @"全部";
    }

    return nil;
}

/// 是否以……结尾
- (BOOL)endWith:(NSString *)child
{
    NSString *lastString = [self substringFromIndex:self.length - child.length];
    BOOL isEqual = [lastString isEqualToString:child];

    return isEqual;
}

/// 是否以……开头
- (BOOL)startWith:(NSString *)child
{
    NSRange range = NSMakeRange(0, child.length);
    NSString *startStr = [self substringWithRange:range];
    BOOL isEqual = [startStr isEqualToString:child];

    return isEqual;
}

/// 是否包含……
- (BOOL)contains:(NSString *)content
{
    if ([self rangeOfString:content].location != NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/// 是否是nil或@""
+ (BOOL)isNilOrEmpty:(NSString *)string
{
    if (!string || string.length <= 0 || string == nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/// 是否全部是空格
+ (BOOL)isEmptyWithLineSpace:(NSString *)string
{
    NSString *trimedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([trimedString length] == 0)
    {
        return YES;
    }

    return NO;
}

+ (BOOL)stringContainsEmoji:(NSString *)string

{
    __block BOOL returnValue = NO;

    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])

                               options:NSStringEnumerationByComposedCharacterSequences

                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {

                                const unichar hs = [substring characterAtIndex:0];

                                if (0xd800 <= hs && hs <= 0xdbff)
                                {
                                    if (substring.length > 1)
                                    {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;

                                        if (0x1d000 <= uc && uc <= 0x1f77f)
                                        {
                                            returnValue = YES;
                                        }
                                    }
                                }
                                else if (substring.length > 1)
                                {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3)
                                    {
                                        returnValue = YES;
                                    }
                                }
                                else
                                {
                                    if (0x2100 <= hs && hs <= 0x27ff)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x2B05 <= hs && hs <= 0x2b07)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x2934 <= hs && hs <= 0x2935)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x3297 <= hs && hs <= 0x3299)
                                    {
                                        returnValue = YES;

                                    }
                                    else if (hs == 0xa9 ||
                                             hs == 0xae ||
                                             hs == 0x303d ||
                                             hs == 0x3030 ||
                                             hs == 0x2b55 ||
                                             hs == 0x2b1c ||
                                             hs == 0x2b1b ||
                                             hs == 0x2b50)
                                    {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isNum:(NSString *)checkedNumString
{
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0)
    {
        return NO;
    }
    return YES;
}

/// 返回的格式 周几
- (NSString *)weekDayFormDate
{
    if (self)
    {
        static   NSDateFormatter *inputFormatter = nil;
        if (inputFormatter == nil)
        {
            inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        }
        NSRange range = [self rangeOfString:@"."];
        NSString *targetString = nil;

        if (range.length == 0)
        {
            [inputFormatter setDateFormat:DateAndTimeFormat];
            targetString = self;
        }
        else
        {
            [inputFormatter setDateFormat:DateAndTimeFormat];
            targetString  = [self substringToIndex:range.location];
        }
        NSDate* inputDate = [inputFormatter dateFromString:targetString];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:inputDate];

        return [self getWeek:comps.weekday];
    }

    return nil;
}

-(NSString *)getWeek:(NSInteger)week
{
    switch (week)
    {
        case 1:
        {
            return @"星期日";
        }
            break;
        case 2:
        {
            return @"星期一";
        }
            break;
        case 3:
        {
            return @"星期二";
        }
            break;
        case 4:
        {
            return @"星期三";
        }
            break;
        case 5:
        {
            return @"星期四";
        }
            break;
        case 6:
        {
            return @"星期五";
        }
            break;
        case 7:
        {
            return @"星期六";
        }
            break;

        default:
            return nil;

            break;
    }
}

/// 字符串为nil时，转化为@"",
+ (NSString *)nilToEmptyWithStr:(id)str
{
    if (str == nil) {
        return @"";
    }
    return str;
}

/**
 *  将字符串进行编码
 *  codingType:编码方式
 */
- (NSString *)encodeWithCodingType:(NSStringEncoding)codingType
{
    return [self stringByAddingPercentEscapesUsingEncoding:codingType];
}

/**
 *  将字符串进行解码
 *  codingType:编码方式
 */
- (NSString *)decodeWithCodingType:(NSStringEncoding)codingType
{
    return [self stringByReplacingPercentEscapesUsingEncoding:codingType];
}
- (BOOL)isValidUrl {
    
//    NSString *regex =@"http://([/w-]+/.)+[/w-]+(/[/w-./?%&=]*)?";
       NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

+ (NSString *)formattingYMdHmsHTimeStr:(NSString *)timeStr{
    
    if (![timeStr isKindOfClass:[NSString class]]) {
        
        return timeStr;
        
    }
    
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    if ([timeStr contains:@"."]) {
        
        NSRange range = [timeStr rangeOfString:@"."];
        
        timeStr = [timeStr substringToIndex:range.location];
        
    }
    
    return timeStr;
    
}

+ (NSString *)formattingYMdHmHTimeStr:(NSString *)timeStr{
    
    if (![timeStr isKindOfClass:[NSString class]]) {
        
        return timeStr;
        
    }
    
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    if (timeStr.length > 16) {
        
        timeStr = [timeStr substringToIndex:16];
        
    }
    
    return timeStr;
    
}

@end
