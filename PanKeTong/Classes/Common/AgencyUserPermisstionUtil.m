//
//  AgencyUserPermisstionUtil.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/19.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyUserPermisstionUtil.h"

@implementation AgencyUserPermisstionUtil

// 用户权限信息
static DepartmentInfoResultEntity *permission;


// 检查是PermUserInfo是否为空，并处理
+ (void) checkPermUserInfo {
    
    if (permission == nil) {
        // 如果内存中不存在，从数据库中读取
        DataBaseOperation *dataBase = [DataBaseOperation sharedataBaseOperation];
        DepartmentInfoResultEntity *muserInfo = [dataBase selectAgencyUserInfo];
        permission = muserInfo;
    }
}


+ (IdentifyEntity *) getIdentify
{
    [self checkPermUserInfo];
    return permission.identify;
}


+ (PermisstionsEntity *) getAgencyPermisstion
{
    [self checkPermUserInfo];
    return permission.permisstions;
}

// 是否有xx权限
+ (BOOL)hasRight:(NSString *)rightName
{
    [self checkPermUserInfo];
    
    if (permission == nil) {
        return NO;
    }

    NSLog(@"%@",permission.permisstions.rights);
    BOOL isright = [self Content:permission.permisstions.rights ContainsWith:rightName];
    
    return isright;
}

//是否有xx菜单权限
+ (BOOL)hasMenuPermisstion:(NSString *)menuPermission
{
    [self checkPermUserInfo];
    
    if (permission == nil) {
        return NO;
    }
    
    return [self Content:permission.permisstions.menuPermisstion ContainsWith:menuPermission];
}

// 更新用户的权限信息
+ (void)updateUserPermission:(PermisstionsEntity *)perm
{
    [self checkPermUserInfo];
    permission.permisstions = perm;
    [self saveUserInfo:permission];
}

+ (BOOL)permissionIsEmpty
{
    BOOL isEmpty = NO;
    [self checkPermUserInfo];
    if(permission.permisstions){
        NSString *right = permission.permisstions.rights;
        NSString *menu = permission.permisstions.menuPermisstion;
        
        if([right isEqualToString:@""] && [menu isEqualToString:@""]){
            return YES;
        }else{
            isEmpty = NO;
        }
        
    }else{
        isEmpty = NO;
    }
    
    return isEmpty;
}


+ (NSString *) getToken
{
    [self checkPermUserInfo];
    
    return permission.accountInfo;
}

+ (NSInteger)getPropNOLimit
{
    //todo:测试阶段设置为30
    return 30;
}


// 保存用户权限 (包括身份信息)
+ (void) saveUserInfo:(DepartmentInfoResultEntity *)permUserInfo
{
    permission = permUserInfo;
    DataBaseOperation *dataBase = [DataBaseOperation sharedataBaseOperation];
    
    NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:permUserInfo];
    NSString *userInfoJson = [dic JSONString];
    
    [dataBase insertAgencyUserInfoWithJson:userInfoJson];
}

// 删除用户相关信息，再退出时调用
+ (void)deleteUserInfo
{
    DataBaseOperation *dataBase = [DataBaseOperation sharedataBaseOperation];
    [dataBase deleteAgencyUserInfo];
    
    permission = nil;
}

+ (NSInteger)getPropScope
{
    if([self hasRight:PROPERTY_CONTRIBUTION_SEARCH_MYSELF])
    {
        return MYSELF;
    }
    if([self hasRight:PROPERTY_CONTRIBUTION_SEARCH_MYDEPARTMENT])
    {
        return MYDEPARTMENT;
    }
    if([self hasRight:PROPERTY_CONTRIBUTION_SEARCH_ALL])
    {
        return ALL;
    }
    
    return MYSELF;
    
}

#pragma mark - 内部方法
// 是否包含……
+ (BOOL)Content:(NSString *)content ContainsWith:(NSString *)child
{
    return [content contains:child];
}



@end
