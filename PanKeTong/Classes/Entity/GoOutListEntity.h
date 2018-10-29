//
//  GoOutListEntity.h
//  PanKeTong
//
//  Created by 张旺 on 17/1/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"

//外出记录实体
@interface GoOutListEntity : AgencyBaseEntity

@property (nonatomic,assign)NSNumber *recordCount;//总记录数

@property (nonatomic,strong)NSArray *goOutMessages;//外出记录数组

@end
