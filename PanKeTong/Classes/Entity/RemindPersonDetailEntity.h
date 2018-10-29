//
//  RemindPersonDetailEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/29.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface RemindPersonDetailEntity : SubBaseEntity

@property (nonatomic,strong) NSString *departmentKeyId;
@property (nonatomic,strong) NSString *departmentName;
@property (nonatomic,strong) NSString *resultName;
@property (nonatomic,strong) NSString *resultKeyId;
@property (nonatomic,assign) NSInteger userOrDepart;


@property (nonatomic, copy)NSString *type;

@end
