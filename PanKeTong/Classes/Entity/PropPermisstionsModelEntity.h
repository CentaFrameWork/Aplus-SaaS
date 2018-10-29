//
//  PropPermisstionsModelEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface PropPermisstionsModelEntity : SubBaseEntity

@property (nonatomic, strong)NSString * menuPermisstion;
@property (nonatomic, strong)NSString * rights;
@property (nonatomic, strong)NSDictionary * operatorValPermisstion;
@property (nonatomic, strong)NSString * departmentKeyIds;
@property (nonatomic, strong)NSString * rightUpdateTime;

@end