//
//  CheckAppVersonUtil.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CheckAppVersonUtil.h"

@implementation CheckAppVersonUtil

+ (void)checkVersonMethod
{

    /**
     *  检查是否首次安装APP
     *  添加广告页
     */
    NSString *curAppVerson = [[NSUserDefaults standardUserDefaults]stringForKey:CurrentAppVerson];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    if (!curAppVerson ||
        [curAppVerson isEqualToString:@""]) {
        
        //首次安装
        [CommonMethod setUserdefaultWithValue:app_Version
                                       forKey:CurrentAppVerson];
        
        //首次安装，保存当前时间,为了限制某些当日限制的功能
        
        NSString *curDateStr = [CommonMethod formatDateStrFromDate:[NSDate date]];
        [CommonMethod setUserdefaultWithValue:curDateStr
                                       forKey:SaveDateTime];
        
        //首次安装，设置可查看房号次数为30次
        
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithInteger:30]
                                       forKey:CheckRoomNumberLimitTimes];
        
        /**
         *  设置欢迎页
         */
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES]
                                       forKey:ShowWelcomePage];
        
    }else if (![curAppVerson isEqualToString:app_Version]){
        
        //非首次安装（更新）
        
        [CommonMethod setUserdefaultWithValue:app_Version
                                       forKey:CurrentAppVerson];
        /**
         *  设置欢迎页
         */
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES]
                                       forKey:ShowWelcomePage];
        
        
    }
    
}

@end
