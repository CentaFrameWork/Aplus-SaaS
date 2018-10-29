//
//  CustomerListEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "CustomerEntity.h"

@interface CustomerListEntity : AgencyBaseEntity

@property (nonatomic,strong) NSArray *inquirys;
@property (nonatomic,assign) NSInteger recordCount;

@end
