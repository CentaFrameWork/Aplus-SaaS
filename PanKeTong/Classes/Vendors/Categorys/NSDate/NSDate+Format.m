//
//  NSDate+Format.m
//  TCAccount
//
//  Created by TailC on 16/1/20.
//  Copyright © 2016年 TailC. All rights reserved.
//

#import "NSDate+Format.h"

@implementation NSDate (Format)

+ (NSString *)dateStr{
    
    NSDate * date = [NSDate date];
    
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    
    NSTimeInterval time = [zone secondsFromGMTForDate:date];
    
    date = [date dateByAddingTimeInterval:time];
    
    NSString * res = [date description];
    
    return [res substringToIndex:res.length - 6];
}

/// 日期->字符串(年-月-日 时:分:秒)
+ (NSString *)stringWithDate:(NSDate *)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSTimeZone *timeZone = [NSTimeZone localTimeZone];
	[formatter setTimeZone:timeZone];
	[formatter setDateFormat:CompleteFormat];

	return [formatter stringFromDate:date];
}

/// 日期->字符串(年-月-日)
+ (NSString *)stringWithSimpleDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:OnlyDateFormat];
    
    return [formatter stringFromDate:date];
}

/// 字符串->日期(年-月-日)
+ (NSDate *)dateFromString:(NSString *)dateStr
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:OnlyDateFormat];
	NSDate *destDate= [dateFormatter dateFromString:dateStr];
	
	return destDate;
}

/// 字符串->日期(去除8小时时差)
+ (NSDate *)getCurrentSystemDateWithDateStr:(NSString *)dateStr
                           AndDateFormatter:(NSString *)foramtter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:foramtter];
    NSDate *date1 = [dateFormatter dateFromString:dateStr];
    NSDate *date2 = [date1 dateByAddingTimeInterval:8 * 60 * 60];
    
    return date2;
}

/// 日期->带有年、月、日、时、分、秒、星期的components
+ (NSDateComponents *)getCurrentDateInfoWithData:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents *comp = [gregorian components: unitFlags fromDate:date];
    /*
     NSLog(@"现在是%ld年" , comp.year);
     NSLog(@"现在是%ld月 " , comp.month);
     NSLog(@"现在是%ld日" , comp.day);
     NSLog(@"现在是%ld时" , comp.hour);
     NSLog(@"现在是%ld分" , comp.minute);
     NSLog(@"现在是%ld秒" , comp.second);
     NSLog(@"现在是星期%ld" , comp.weekday);
     */
    return comp;
}

/// 获取某月的天数总长
+ (NSInteger)getCurrentMonthDaysWithYear:(NSInteger)year andMonth:(NSInteger )month
{
    NSArray *monthArr1 = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12",];
    if ([monthArr1 containsObject:[NSString stringWithFormat:@"%ld",(long)month]])
    {
        return 31;
    }else if (month == 2)
    {
        if (year % 100 == 0)
        {
            if (year % 400 == 0)
            {
                // 闰年
                return 29;
            }
            return 28;
        }else
        {
            if (year % 4 == 0)
            {
                // 闰年
                return 29;
            }
            return 28;
        }
    }
    
    return 30;
}


/// 判断当前日期是否已过某天的24点
+ (BOOL)islaterDate24WithDate:(NSString *)eventDateStr
{
    // 获取约看时间当日的24点
    NSString *selectDate = [eventDateStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];

    // 获取当前时区的标准日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:CompleteFormat];
    NSDate *eventDate = [dateFormatter dateFromString:selectDate];
    NSDate *nowDate = [NSDate date];
    
    
   NSComparisonResult result = [eventDate compare:nowDate];
    
    if (result == NSOrderedDescending) {
        
        return NO;
    
    }else {
        
         return YES;
       
    }
    
    
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay
//                                               fromDate:eventDate];
//    NSDate *startDate = [calendar dateFromComponents:components];
//    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
//    NSDate *event24Date = [endDate dateByAddingTimeInterval:8 * 60 * 60];
//
//    // 返回较早的日期
//    NSDate *earlyDate = [event24Date earlierDate:nowDate];
//
//    if (earlyDate == event24Date)
//    {
//        return YES;
//    }
//
//    return NO;
}

/// 判断当前月是否已过某个月
+ (BOOL)isEarlyCurrentMonthWithDateStr:(NSString *)dateStr
{
    NSDate *goOutDate = [NSDate dateFromString:dateStr];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay;

    // 获取不同时间字段的信息
    NSDateComponents *goOutComp = [gregorian components: unitFlags fromDate:goOutDate];
    NSDateComponents *nowComp = [gregorian components: unitFlags fromDate:[NSDate date]];
    if (nowComp.year >= goOutComp.year)
    {
        if (nowComp.month > goOutComp.month)
        {
            return YES;

        }
    }
    
    return NO;
}

@end
