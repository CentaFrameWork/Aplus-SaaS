//
//  CustomerFollowItemEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface CustomerFollowItemEntity : SubBaseEntity

@property (nonatomic,strong) NSString *followPerson;//跟进人
@property (nonatomic,strong) NSString *followType;//跟进类型
@property (nonatomic,strong) NSString *followDate;//跟进日期
@property (nonatomic,strong) NSString *followContent;//跟进内容

@end
