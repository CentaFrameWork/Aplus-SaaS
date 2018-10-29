//
//  CheckPermissionInstantiation.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/27.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CheckPermissionInstantiation.h"

@implementation CheckPermissionInstantiation
/// 是否有查看房源跟进权限
- (BOOL)haveFollowListPerm:(NSString *)deptPerm
{
    BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_SEARCH_ALL];
    
    BOOL hasPermisstion = YES;
    
    if (![NSString isNilOrEmpty:deptPerm]) {
        hasPermisstion = [deptPerm contains:DEPARTMENT_PROPERTY_FOLLOW_SEARCH_ALL];
    }
    
    if(isAble && hasPermisstion)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/// 添加实勘权限
- (BOOL)haveAddUploadrealSurveyPerm:(NSString *)deptPerm
{
    BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_ADD_ALL];
    
    BOOL hasPermisstion = YES;
    
    if (![NSString isNilOrEmpty:deptPerm])
    {
        hasPermisstion = [deptPerm contains:DEPARTMENT_PROPERTY_REALSURVEY_ADD_ALL];
    }
    
    if(isAble && hasPermisstion)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 查看实勘权限
- (BOOL)haveUploadrealSurveyPerm:(NSString *)deptPerm
{
    BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_SEARCH_ALL];
    
    BOOL hasPermisstion = YES;
    
    if (![NSString isNilOrEmpty:deptPerm]) {
        hasPermisstion = [deptPerm contains:DEPARTMENT_PROPERTY_REALSURVEY_SEARCH_ALL];
    }
    
    if(isAble && hasPermisstion){
        return YES;
    }
    else
    {
        return NO;
    }
}

// 查看钥匙权限
- (BOOL)havePropKeyPerm:(NSString *)deptPerm
{
    BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_KEY_SEARCH_ALL];
    
    BOOL hasPermisstion = YES;
    
    if (![NSString isNilOrEmpty:deptPerm]) {
        hasPermisstion =   [deptPerm contains:PROPERTY_KEY_SEARCH_ALL];
    }
    
    if (hasPermisstion && isAble)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/// 查看联系人权限
- (BOOL)haveViewTrustorsPerm:(NSString *)deptPerm
{
    BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_CONTACTINFORMATION_SEARCH_ALL];
    
    BOOL hasPermisstion = YES;
    
    if (![NSString isNilOrEmpty:deptPerm]) {
        hasPermisstion = [deptPerm contains:DEPARTMENT_PROPERTY_CONTACTINFORMATION_SEARCH_ALL];
    }
    
    if (isAble && hasPermisstion){
        return YES;
    }else{
        return NO;
    }
}

@end
