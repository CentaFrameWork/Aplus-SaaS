//
//  LogOffUtil.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/6/16.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "LogOffUtil.h"
#import "CommonMethod.h"
#import "AgencyUserPermisstionUtil.h"
#import "ApiDomainUtil.h"
#import "RCIMUserDataSource.h"
#import "CLLockVC.h"


@implementation LogOffUtil
/**
 *  用户退出登录后清除用户信息
 */
+ (void)clearUserInfoFromLocal
{
    /**
     *  用户退出登录后清除用户信息
     */
    [AgencyUserPermisstionUtil deleteUserInfo];
    [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:NO]
                                   forKey:UserLoginSuccess];
    [CommonMethod setUserdefaultWithValue:nil
                                   forKey:UserName];
    [CommonMethod setUserdefaultWithValue:nil
                                   forKey:UserStaffNumber];
    [CommonMethod setUserdefaultWithValue:nil
                                   forKey:HouseKeeperSession];
    [CommonMethod setUserdefaultWithValue:nil
                                   forKey:UserStaffMobile];
    [CommonMethod setUserdefaultWithValue:nil forKey:UserTitle];
    [CommonMethod setUserdefaultWithValue:nil forKey:AgentUrl];
    [CommonMethod setUserdefaultWithValue:nil forKey:CityCode];
    [CommonMethod setUserdefaultWithValue:nil forKey:@"msisdn"];
    


    // 删除A+系统手机号码
    [CommonMethod setUserdefaultWithValue:nil forKey:APlusUserMobile];
    // 删除A+系统大于一个手机号码
    [CommonMethod setUserdefaultWithValue:nil forKey:APlusUserExtendMobile];
    // 删除A+经纪人部门名称
    [CommonMethod setUserdefaultWithValue:nil forKey:APlusUserDepartName];
    // 删除A+经纪人角色名称
    [CommonMethod setUserdefaultWithValue:nil forKey:APlusUserRoleName];
    // 删除A+经纪人头像路径
    [CommonMethod setUserdefaultWithValue:nil forKey:APlusUserPhotoPath];
    // 删除域名信息
    [[BaseApiDomainUtil getApiDomain] clearAllDomain];

    
    [LogOffUtil logoutRongCloudMethod];
}


/**
 *  退出融云聊天系统
 */
#pragma mark - LogoutRongCloud
+ (void)logoutRongCloudMethod
{
    
    //清除融云相关的设置
    [[RCIM sharedRCIM] logout];
    // [self sharedAppDelegate].uploadTokenSuccess = NO;
    
    [CommonMethod setUserdefaultWithValue:nil
                                   forKey:RongCloudUserToken];
}

@end
