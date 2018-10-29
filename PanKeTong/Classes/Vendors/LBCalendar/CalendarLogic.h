//
//  CalendarLogic.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/22.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ChineseMonths @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]
#define WeekDays @[@" ",@"周日",@"周一",@"周二", @"周三", @"周四", @"周五", @"周六", @" "]
#define ChineseFestival @[@"春节",@"元宵",@"端午",@"七夕",@"中元",@"中秋",@"重阳",@"腊八",@"小年",@"元旦",@"情人节", @"妇女节",@"劳动节",@"儿童节",@"建军节",@"教师节",@"国庆节",@"程序员日",@"植树节",@"光棍节",@"圣诞节",@"小寒", @"大寒", @"立春", @"雨水", @"惊蛰", @"春分",@"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至",@"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分",@"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至"]
#define ChineseDays @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]


@interface CalendarLogic : NSObject

//获取某天农历日期
+ (NSString*)getChineseCalendarWithDate:(NSDate *)date;

//获取某天星期几
+ (NSString *)getWeekWithDate:(NSDate *)date;

//获取当天的节日
+ (NSString *)getHolidays:(NSDate *)date;

//获取节气
+ (NSString *)getLunarSpecialDate:(int)iYear Month:(int)iMonth Day:(int)iDay;






@end
