//
//  getQuantificationEntitiy.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/5/6.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface GetQuantificationEntitiy : AgencyBaseEntity
@property (nonatomic,strong) NSArray *workStats;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,strong) NSString *Flag;

@end
