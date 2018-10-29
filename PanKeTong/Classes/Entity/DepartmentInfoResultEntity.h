//
//  DepartmentInfoResultEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"
#import "IdentifyEntity.h"
#import "PermisstionsEntity.h"
@interface DepartmentInfoResultEntity : SubBaseEntity<MTLJSONSerializing>

@property (nonatomic,strong)IdentifyEntity *identify;
@property (nonatomic,strong)PermisstionsEntity * permisstions;
@property (nonatomic,copy)NSString * accountInfo;

@end
