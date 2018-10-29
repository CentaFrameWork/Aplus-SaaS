//
//  MoreFollowListViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/4.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "PropertysModelEntty.h"
#import "PropPageDetailEntity.h"
#import "PropertysModelEntty.h"
#import "AddContactsViewController.h"

@protocol FreshFollowListDelegate <NSObject>
//刷新跟进列表
- (void)freshFollowListMethod;
@end

@interface MoreFollowListViewController : BaseViewController

@property (nonatomic,strong) NSString *propKeyId;   //房源id

/// <summary>
/// 房源状态四大分类枚举：1-有效，2-暂缓，3-预定，4-无效
/// </summary>
@property (nonatomic, assign) NSNumber *propertyStatusCategory;

@property (strong, nonatomic) PropPageDetailEntity *propDetailEntity;

@property (strong, nonatomic) PropertysModelEntty *propModelEntity;

@property (nonatomic, copy) NSString *departmentPermisstion;

@property (nonatomic,assign)id <FreshFollowListDelegate>freshFollowListDelegate;

@property (nonatomic, copy) NSString *propTrustType;

@property (nonatomic, copy) NSString *propertyStatus;   // 当前房源状态

@end
