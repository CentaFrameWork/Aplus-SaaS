//
//  AgencyUserPermisstionUtil.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/19.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DepartmentInfoResultEntity.h"
#import "IdentifyEntity.h"
#import "PermisstionsEntity.h"
#import "DataBaseOperation.h"
#import "AgencyPermissionsDefine.h"
#import "AccessModelScopeEnum.h"

/// A+用户权限Util
@interface AgencyUserPermisstionUtil : NSObject

// 验证PermUserInfo
+ (void) checkPermUserInfo;
// 获取用户身份信息
+ (IdentifyEntity *) getIdentify;
// 获取用户的权限信息
+ (PermisstionsEntity *) getAgencyPermisstion;

#pragma mark - 权限验证

// 是否有XX操作权限
+ (BOOL)hasRight:(NSString *)rightName;
// 是否有XX菜单权限
+ (BOOL)hasMenuPermisstion:(NSString *)menuPermission;

#pragma mark - others

// 更新用户的权限信息
+ (void)updateUserPermission:(PermisstionsEntity *)perm;

// 获取用户的token
+ (NSString *) getToken;

// 获取房源房号查看限制次数
+ (NSInteger)getPropNOLimit;

// 保存用户相关信息
+ (void) saveUserInfo:(DepartmentInfoResultEntity *)permUserInfo;
// 删除用户相关信息
+ (void)deleteUserInfo;

//用户的权限是否为空（包括right和menu）
+ (BOOL)permissionIsEmpty;

+ (NSInteger)getPropScope;

// 是否包含……
+ (BOOL)Content:(NSString *)content ContainsWith:(NSString *)child;


@end
