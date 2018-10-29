//
//  TakingSeeEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/6.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"

///约看记录实体
@interface TakingSeeEntity : AgencyBaseEntity

@property (nonatomic,assign)NSNumber *recordCount;//总记录数

@property (nonatomic,strong)NSArray *takingSees;//约看数组

@property (nonatomic,strong)NSArray *takeSees;//带看数组

@end
