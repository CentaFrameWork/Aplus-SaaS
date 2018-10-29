//
//  CheckRoomNumUtil.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CheckRoomNumUtil.h"

@implementation CheckRoomNumUtil

+ (void)useCheckRoomNumLimit
{
    /**
     *  查看房号，使用剩余次数,剩余次数减一
     */
    
    NSInteger times = 0;
    
    times = [[NSUserDefaults standardUserDefaults]integerForKey:CheckRoomNumberLimitTimes];
    
    times -= 1;
    
    [CommonMethod setUserdefaultWithValue:[NSNumber numberWithInteger:times]
                                   forKey:CheckRoomNumberLimitTimes];
}

+ (NSInteger)timesOfCheckNum
{
    
    NSInteger times = 0;
    
    if ([self isCurDateTime]) {
        
        //同一天下操作，直接使用系统保存的次数
        
        times = [[NSUserDefaults standardUserDefaults]integerForKey:CheckRoomNumberLimitTimes];
        
    }else{
        //不是同一天操作，设置为30
        
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithInteger:30]
                                       forKey:CheckRoomNumberLimitTimes];
        
        times = 30;
    }
    
    return times;
}

+ (BOOL)isCurDateTime
{
    /**
     *  上一次保存的时间
     */
    NSString *saveDateTimeStr = [[NSUserDefaults standardUserDefaults]stringForKey:SaveDateTime];
    
    /**
     *  当前系统时间（用来和上一次保存的时间判断是否是当日使用APP）
     */
    NSString *curDateTimeStr = [CommonMethod formatDateStrFromDate:[NSDate date]];
    
    if ([saveDateTimeStr isEqualToString:curDateTimeStr]) {
        
        //距离上次操作还未超过一天，不用覆盖保存的时间
        
        return YES;
    }else{
        
        //距离上次操作已超过一天，覆盖之前保存的时间，重新计算
        
        [CommonMethod setUserdefaultWithValue:curDateTimeStr
                                       forKey:SaveDateTime];
        
        return NO;
    }
    
}

@end
