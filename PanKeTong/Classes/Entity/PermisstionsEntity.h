//
//  PermisstionsEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"
#import "OperatorValPermisstionEntity.h"
@interface PermisstionsEntity : SubBaseEntity<MTLJSONSerializing>

@property (nonatomic, strong)NSString * menuPermisstion;
@property (nonatomic, strong)NSString * rights;
@property (nonatomic, strong)OperatorValPermisstionEntity * operatorValPermisstion;
@property (nonatomic, strong)NSString * departmentKeyIds;
@property (nonatomic, strong)NSString * rightUpdateTime;

@end
