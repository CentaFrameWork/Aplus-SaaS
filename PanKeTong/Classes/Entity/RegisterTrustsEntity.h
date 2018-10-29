//
//  RegisterTrustsEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/25.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "SubRegisterTrustsEntity.h"

///委托审核列表
@interface RegisterTrustsEntity : AgencyBaseEntity

@property (nonatomic,strong) NSArray *propertyRegisterTrusts;//委托列表


@end
