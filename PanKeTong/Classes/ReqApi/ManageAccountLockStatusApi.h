//
//  ManageAccountLockStatusApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "HKBaseApi.h"
#define GetAccountLockStatus 1
#define ResetAccountLockStatus 2

/// 获取或恢复强制解锁密码状态
@interface ManageAccountLockStatusApi : HKBaseApi

@property (nonatomic,assign) NSInteger ManageAccountLockStatusType;

@property (nonatomic, copy) NSString * mobile;

@end
