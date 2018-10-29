//
//  FindRegisterTrustEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/3/2.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface FindRegisterTrustEntity : AgencyBaseEntity

@property (nonatomic,copy)NSString *keyId;//房源keyID

/*
 房源状态:
 -1:不是委托房源
 0:是委托房源，备案不通过
 1:是委托房源，备案通过
 2:是委托房源，备案待审核
 */
@property (nonatomic,copy)NSNumber *status;

@end
