//
//  StaffInfoEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/12/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseEntity.h"
#import "StaffInfoResultEntity.h"

@interface StaffInfoEntity : BaseEntity

@property (nonatomic,strong) StaffInfoResultEntity *result;

@end
