//
//  PropKeysEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface PropKeysEntity : SubBaseEntity

/// <summary>
/// 收钥匙人
/// </summary>
@property (nonatomic,strong) NSString *receiver;

/// <summary>
/// 收钥匙时间
/// </summary>
@property (nonatomic,strong) NSString *receivedTime;

/// <summary>
/// 钥匙数量
/// </summary>
@property (nonatomic,assign) NSInteger keyCount;

/// <summary>
/// 存放位置
/// </summary>
@property (nonatomic,strong) NSString *propKeyStatus;

/// <summary>
/// 中原or行家
/// </summary>
@property (nonatomic,strong) NSString *type;

/// <summary>
/// 收钥匙人所属部门
/// </summary>
@property (nonatomic,strong) NSString *departmentName;

/// <summary>
/// 收钥匙人电话
/// </summary>
@property (nonatomic,strong) NSString *receiverPhone;

/// 钥匙Id
@property (nonatomic,copy) NSString *propertyKeyNo;

/// 收钥匙人电话(重庆)
@property (nonatomic, copy) NSString *linkPhone;

// 位置
@property (nonatomic, copy) NSString *keyLocation;


@end
