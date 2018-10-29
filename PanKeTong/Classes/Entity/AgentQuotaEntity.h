//
//  AgentQuotaEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/11/6.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface AgentQuotaEntity : SubBaseEntity
@property (nonatomic, assign)BOOL admPermission;
@property (nonatomic, copy)NSString *registerTrustsOnOff;//业主委托权限开关
@property (nonatomic, copy)NSString *registerTrustAudit;//委托书必须审核通过才能放盘开关
@property (nonatomic, assign)NSInteger packageCount ;
@property (nonatomic, assign)NSInteger countIsPropertyAd ;
@property (nonatomic, assign)NSInteger countPropertyAd ;
@property (nonatomic, assign)BOOL flag;
@property (nonatomic, strong)NSString * errorMsg;
@property (nonatomic, strong)NSString * runTime;
@property (nonatomic, assign)NSInteger tag;

@end
