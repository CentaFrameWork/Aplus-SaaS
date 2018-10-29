//
//  CallRealPhoneLimitUtil.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CallRealPhoneLimitUtil.h"

@implementation CallRealPhoneLimitUtil

/**
 *  添加房源keyId
 *
 *  为做拨打电话计数处理
 */
+ (void)addCallRealPhoneRecordWithPropKeyId:(NSString *)propKeyId
{
    NSString *staffNo = [AgencyUserPermisstionUtil getIdentify].userNo;
    NSString *dateNow = [self getDateTimeNow];
    
    DataBaseOperation *dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
    [dataBaseOperation insertCallRealPhoneWithStaffNo:staffNo
                                         andPropKeyId:propKeyId
                                              andDate:dateNow];
}

/**
 *  今日已拨打电话次数
 */
+ (NSInteger)getCountForToday
{
    NSString *staffNo = [AgencyUserPermisstionUtil getIdentify].userNo;
    NSString *dateNow = [self getDateTimeNow];
    
    DataBaseOperation *dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
    NSInteger count = [dataBaseOperation selectCountForStaffNo:staffNo andDate:dateNow];
    
    return count;
}

/**
 *  删除非当日的拨打记录
 */
+ (void)deleteNotToday
{
    NSString *staffNo = [AgencyUserPermisstionUtil getIdentify].userNo;
    NSString *dateNow = [self getDateTimeNow];
    
    DataBaseOperation *dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
    [dataBaseOperation deleteRealPhoneForStaffNo:staffNo andDate:dateNow];
}

/**
 *  检查此房源id是否存在
 *  
 *  为实现同一个房源不做计数处理
 */
+ (BOOL)isExistWithPropKeyId:(NSString *)propKeyId
{
    NSString *staffNo = [AgencyUserPermisstionUtil getIdentify].userNo;
    NSString *dateNow = [self getDateTimeNow];
    
    DataBaseOperation *dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
    BOOL isExist = [dataBaseOperation isExistWithStaffNo:staffNo
                             andPropKeyId:propKeyId
                                  andDate:dateNow];
    return isExist;
}

+ (NSString *)getDateTimeNow
{
    NSDate *dateNow=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString=[dateformatter stringFromDate:dateNow];
    return locationString;
}

@end
