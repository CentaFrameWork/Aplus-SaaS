//
//  DepartmentInfoEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface DepartmentInfoEntity : AgencyBaseEntity<MTLJSONSerializing>

@property (nonatomic,strong)NSArray *result;

@end
