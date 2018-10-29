//
//  PropListEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "PropPermisstionsModelEntity.h"
#import "PropertysModelEntty.h"

@interface PropListEntity : AgencyBaseEntity

@property (nonatomic,assign) NSInteger recordCount;
@property (nonatomic,strong) NSArray *propertysModel;
@property (nonatomic,strong) PropPermisstionsModelEntity *permisstionsModel;

@end
