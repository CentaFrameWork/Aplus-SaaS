//
//  PropFollowRecordDetailEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface PropFollowRecordDetailEntity : AgencyBaseEntity


@property (nonatomic, copy) NSString *followTypeKeyId;
@property (nonatomic, copy) NSString *followType;
@property (nonatomic, copy) NSString *followTypeCode;
@property (nonatomic, copy) NSString *followContent;
@property (nonatomic, copy) NSString *follower;
@property (nonatomic, copy) NSString *followTime;
@property (nonatomic, assign) BOOL topFlag;            // 是否置顶

@property (nonatomic, copy) NSString *keyId;
@property (nonatomic, copy) NSString *confirmRoleName;//确认人角色名称
@property (nonatomic, copy) NSString *confirmRoleKeyId;//确认人角色keyid
@property (nonatomic, copy) NSString *confirmUserName;//确认人名称
@property (nonatomic, copy) NSString *confirmUserKeyId;//确认人keyid

@property (nonatomic, copy) NSString *followerKeyId;//跟进人KeyId
@property (nonatomic, copy) NSString *departmentName;//跟进人部门名称
@property (nonatomic, copy) NSString *departmentKeyId;//跟进人部门KeyId

@end
