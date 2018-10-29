//
//  PropFollowRecordDetailEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropFollowRecordDetailEntity.h"

@implementation PropFollowRecordDetailEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"followTypeKeyId":@"FollowTypeKeyId",
             @"followType":@"FollowType",
             @"followTypeCode":@"FollowTypeCode",
             @"followContent":@"FollowContent",
             @"follower":@"Follower",
             @"followTime":@"FollowTime",
             @"topFlag":@"TopFlag",
             @"keyId":@"KeyId",
             @"confirmRoleName":@"ConfirmRoleName",
             @"confirmRoleKeyId":@"ConfirmRoleKeyId",
             @"confirmUserName":@"ConfirmUserName",
             @"confirmUserKeyId":@"ConfirmUserKeyId",
             @"followerKeyId":@"FollowerKeyId",
             @"departmentName":@"DepartmentName",
             @"departmentKeyId":@"DepartmentKeyId"
             };
}

@end
