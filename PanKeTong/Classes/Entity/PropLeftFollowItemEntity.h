//
//  PropLeftFollowItemEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 16/4/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface PropLeftFollowItemEntity : SubBaseEntity

@property (nonatomic,strong) NSString *keyId;               // - 跟进KeyId (Nullable`1)
@property (nonatomic,strong) NSString *followTypeKeyId;     //- 跟进类型 (Guid)
@property (nonatomic,strong) NSString *followType;          //- 跟进类型，系统参数项名称 (String)
@property (nonatomic,strong) NSString *followTypeCode;      //- 跟进类型code，系统参数项名称 (String)
@property (nonatomic,strong) NSString *followContent;       //- 跟进内容 (String)
@property (nonatomic,strong) NSString *follower;            //- 跟进人 (String)
@property (nonatomic,strong) NSString *followTime;          //- 跟进时间,精度到秒 (DateTime)
@property (nonatomic,strong) NSString *confirmRoleName;     //- 确认人角色名称 (String)
@property (nonatomic,strong) NSString *confirmRoleKeyId;    //- 确认人角色KeyId (Guid)
@property (nonatomic,strong) NSString *confirmUserName;     //- 确认人名称 (String)
@property (nonatomic,strong) NSString *confirmUserKeyId;    //- 确认人KeyId (Guid)
@property (nonatomic,strong) NSString *followerKeyId;       //- 跟进人KeyId (Guid)
@property (nonatomic,strong) NSString *departmentName;      //- 跟进人部门名称 (String)
@property (nonatomic,strong) NSString *departmentKeyId;     //- 跟进人部门KeyId (Guid)
@property (nonatomic,strong) NSString *estateName;          //- 楼盘名称 (String)
@property (nonatomic,strong) NSString *buildingName;        //- 栋座单元 (String)
@property (nonatomic,strong) NSString *houseNo;             //- 房号 (String)
@property (nonatomic,strong) NSString *propertyKeyId;       //- 房源KeyId (Guid)
@property (nonatomic,strong) NSNumber *trustType;           //- 委托类型（出售=1、出租=2、租售=3） (Nullable`1)

@end
