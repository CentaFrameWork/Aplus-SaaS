//
//  AddTakingSeeVC.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "PropertysModelEntty.h"
#import "PropPageDetailEntity.h"    // 房源详情实体
#import "CustomerEntity.h"          // 客户实体
#import "SearchRemindPersonViewController.h"
#import "SelectPropertyEntity.h"
#import "AddTakingSeeApi.h"

#define Customer 0     // 客户
#define Property 1     // 房源
#define RemindPerson 2 // 提醒人

@protocol AddTakingSeeDelegate <NSObject>

/**
 *  新增约看成功
 */
- (void)addTakingSeeSuccess;

@end

/// 新增约看
@interface AddTakingSeeVC : BaseViewController

@property (nonatomic,copy) NSString *customerFed;   // 客户反馈

@property (nonatomic, assign) id <AddTakingSeeDelegate> delegate;

@property (nonatomic, strong) CustomerEntity *selectCustomerEntity; // 选择客户实体

@property (nonatomic, assign) BOOL isFromCustomerFollow;    // 是否从客户跟进跳进来

@property (nonatomic, assign) BOOL isFromHomePage; // 是否是首页快捷入口








@end
