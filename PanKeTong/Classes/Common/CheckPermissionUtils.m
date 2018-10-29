//
//  CheckPermissionUtils.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/11/1.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CheckPermissionUtils.h"
#import "AgencyUserInfoApi.h"
#import "DepartmentInfoEntity.h"
#import "LogOffUtil.h"
#import "AppDelegate.h"
#import "Error.h"
#import "CheckHttpErrorUtil.h"
#import "JDStatusBarNotification.h"

#define ChangedString @"您当前登录角色或部门发生异动，请重新登录！"

static CheckPermissionUtils *checkPermissionUtils;

@implementation CheckPermissionUtils

+ (CheckPermissionUtils *)sharedCheckPermissionUtils
{
    if (!checkPermissionUtils)
    {
        checkPermissionUtils = [[self alloc] init];
    }
    
    return checkPermissionUtils;
}

- (void)checkUserPermission
{
    [checkPermissionUtils hasManager];
    
    NSString *staff = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
    AgencyUserInfoApi *userInfoApi = [AgencyUserInfoApi new];
    userInfoApi.staffNo = @[staff];
    [_manager sendRequest:userInfoApi];
}

- (void)hasManager
{
    if (!checkPermissionUtils.manager)
    {
        checkPermissionUtils.manager = [RequestManager initManagerWithDelegate:self];
    }
}

- (NSString *)isEqualToDepartmentInfo:(DepartmentInfoResultEntity *)entity
{
    DataBaseOperation *dataBase = [DataBaseOperation sharedataBaseOperation];
    DepartmentInfoResultEntity *muserInfo = [dataBase selectAgencyUserInfo];
    
    IdentifyEntity *newIdentifyEntity = entity.identify;
    IdentifyEntity *mIdentifyEntity = muserInfo.identify;
    
    // token
    if (![entity.accountInfo isEqualToString:muserInfo.accountInfo]) {
        return @"NO";
    }
    
    // 角色ID
    if (![newIdentifyEntity.uId isEqualToString:mIdentifyEntity.uId]) {
        return @"NO";
    }
    
    // 部门ID
    if (![newIdentifyEntity.departId isEqualToString:mIdentifyEntity.departId]) {
        return @"NO";
    }
    
    
    return @"YES";
}

//- (void)handleError:(Error *)error
//{
//    if ([@"A connection failure occurred" isEqualToString:error.rDescription])
//    {
//        showMsg(@"无法连接服务器，请稍后再试!");
//    }
//    else if ([@"The request timed out" isEqualToString:error.rDescription])
//    {
//        showMsg(@"网络不给力，请稍后再试!");
//    }
//    else if ([error.rDescription rangeOfString:@"SSL"].location != NSNotFound)
//    {
//        //连接到需要认证的wifi环境
//        showMsg(@"网络不给力，请稍后再试!");
//    }
//    else
//    {
//        NSString *errorMsg = error.rDescription;
//        
//        if (error.rDescription)
//        {
//            
//            if ([error.rDescription isEqualToString:@"数据为空"])
//            {
//                [CustomAlertMessage showAlertMessage:@"没有找到符合条件的信息\n\n"
//                                     andButtomHeight:APP_SCREEN_HEIGHT/2];
//            }
//            else
//            {
//                showMsg(errorMsg);
//            }
//        }
//    }
//}

#pragma mark - <UIAlertViewDelegate>

/// 人员异动，退出，重新登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [LogOffUtil clearUserInfoFromLocal];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate changeDiscoverRootVCIsLogin:YES];
}

#pragma mark - <ResponseDelegate>

/// 响应成功
- (void)respSuc:(id)data andRespClass:(id)cls
{
    if ([cls isEqual:[DepartmentInfoEntity class]])
    {
        DepartmentInfoEntity *departmentEntity = [DataConvert convertDic:data toEntity:cls];
        
        NSMutableArray *changedArr = [NSMutableArray array];
        if (departmentEntity.result.count > 0)
        {
            for (DepartmentInfoResultEntity *entity in departmentEntity.result)
            {
                [changedArr addObject:[self isEqualToDepartmentInfo:entity]];
            }
        }
        
        if (![changedArr containsObject:@"YES"] || departmentEntity.result.count == 0)
        {
            // 人员异动了
            [[[UIAlertView alloc] initWithTitle:nil message:ChangedString
                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
    }
}

/// 响应失败
- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    NSString *errorMsg = @"";
    if ([error isKindOfClass:[Error class]])
    {
        Error *failError = (Error *)error;
        errorMsg = [CheckHttpErrorUtil handleError:failError];
    }
    else
    {
        Error *failError = [[Error alloc]init];
        
        failError.rDescription = error.localizedDescription;
        failError.httpCode = error.code;
        
        errorMsg = [CheckHttpErrorUtil handleError:failError];
    }
    
    if (![NSString isNilOrEmpty:errorMsg])
    {
        showJDStatusStyleErrorMsg(errorMsg);
    }
}

@end
