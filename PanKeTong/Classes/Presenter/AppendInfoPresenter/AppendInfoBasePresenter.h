//
//  AppendInfoBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/9.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"
#import "APlusBaseApi.h"
#import "PropertyFollowAllAddApi.h"
#import "FollowTypeDefine.h"


@interface AppendInfoBasePresenter : BasePresenter

@property (strong, nonatomic) NSMutableArray *contactsNameArr;
@property (strong, nonatomic) NSMutableArray *contactsKeyIdArr;
@property (strong, nonatomic) NSMutableArray *informDepartsKeyIdArr;
@property (strong, nonatomic) NSMutableArray *informDepartsNameArr;

@property (assign, nonatomic) id selfView;

- (instancetype)initWithDelegate:(id)delegate;

- (void)getContactsInfoAndDepartInfo:(NSArray *)personArr;

/// 获得请求api
- (APlusBaseApi *)getRequestApi:(NSArray *)personArr
               andPropertyKeyId:(NSString *)propertyKeyId
           andAppendMessageType:(NSInteger)appendMessageType
               andFollowContent:(NSString *)followContent
                     andMsgTime:(NSString *)msgTime;

/// 是否含有提醒时间功能
- (BOOL)haveReminderTimeFunction;

/// 是否含有提醒人
- (BOOL)haveRemindPeople;

/// 是否含有快捷输入模块
- (BOOL)haveQuickInputModule;

/// 提醒人是否屏蔽自己
- (BOOL)isExceptMe;

@end
