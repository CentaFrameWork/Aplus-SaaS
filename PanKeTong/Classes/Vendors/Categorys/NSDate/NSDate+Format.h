//
//  NSDate+Format.h
//  TCAccount
//
//  Created by TailC on 16/1/20.
//  Copyright © 2016年 TailC. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DateAndAllTimeFormat    @"yyyy-MM-dd HH:mm:ss zzz"
#define DateAndTimeFormat       @"yyyy-MM-dd'T'HH:mm:ss"
#define CompleteNoFormat        @"yyyyMMddHHmmss"
#define CompleteFormat          @"yyyy-MM-dd HH:mm:ss"

#define YearToMinFormat     @"yyyy-MM-dd HH:mm"

#define OnlyDateFormat      @"yyyy-MM-dd"

@interface NSDate (Format)

//获取当前日期字符串
+ (NSString *)dateStr;

/// 日期->字符串(年-月-日 时:分:秒)
+(NSString *)stringWithDate:(NSDate *)date;

/// 日期->字符串(年-月-日)
+(NSString *)stringWithSimpleDate:(NSDate *)date;

/// 字符串->日期(年-月-日)
+(NSDate *)dateFromString:(NSString *)dateStr;

/// 字符串->日期(去除8小时时差)
+ (NSDate *)getCurrentSystemDateWithDateStr:(NSString *)dateStr
                           AndDateFormatter:(NSString *)foramtter;

/// 日期->带有年、月、日、时、分、秒、星期的components
+ (NSDateComponents *)getCurrentDateInfoWithData:(NSDate *)date;

/// 获取某月的天数总长
+ (NSInteger)getCurrentMonthDaysWithYear:(NSInteger)year andMonth:(NSInteger )month;

//// 判断当前日期是否已过某天的24点
+ (BOOL)islaterDate24WithDate:(NSString *)eventDateStr;

///  判断当前月是否已过某个月
+ (BOOL)isEarlyCurrentMonthWithDateStr:(NSString *)dateStr;

@end
