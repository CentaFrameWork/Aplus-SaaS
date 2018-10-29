//
//  PropLeftFollowItemEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/4/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PropLeftFollowItemEntity.h"

@implementation PropLeftFollowItemEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"keyId":@"KeyId",
             @"followTypeKeyId":@"FollowTypeKeyId",
             @"followType":@"FollowType",
             @"followTypeCode":@"FollowTypeCode",
             @"followContent":@"FollowContent",
             @"follower":@"Follower",
             @"followTime":@"FollowTime",
             @"confirmRoleName":@"ConfirmRoleName",
             @"confirmRoleKeyId":@"ConfirmRoleKeyId",
             @"confirmUserName":@"ConfirmUserName",
             @"confirmUserKeyId":@"ConfirmUserKeyId",
             @"followerKeyId":@"FollowerKeyId",
             @"departmentName":@"DepartmentName",
             @"departmentKeyId":@"DepartmentKeyId",
             @"estateName":@"EstateName",
             @"buildingName":@"BuildingName",
             @"houseNo":@"HouseNo",
             @"propertyKeyId":@"PropertyKeyId",
             @"trustType":@"TrustType"
             };
}

@end
