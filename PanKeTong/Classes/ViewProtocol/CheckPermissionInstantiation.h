//
//  CheckPermissionInstantiation.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/27.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 检查权限
@protocol CheckPermissionProtocol <NSObject>

/// 是否有查看房源跟进权限
- (BOOL)haveFollowListPerm:(NSString *)deptPerm;

/// 添加实勘权限
- (BOOL)haveAddUploadrealSurveyPerm:(NSString *)deptPerm;

/// 查看实勘权限
- (BOOL)haveUploadrealSurveyPerm:(NSString *)deptPerm;

/// 是否有查看钥匙
- (BOOL)havePropKeyPerm:(NSString *)deptPerm;

/// 查看联系人权限
- (BOOL)haveViewTrustorsPerm:(NSString *)deptPerm;

@end

@interface CheckPermissionInstantiation : UIViewController <CheckPermissionProtocol>


@end
