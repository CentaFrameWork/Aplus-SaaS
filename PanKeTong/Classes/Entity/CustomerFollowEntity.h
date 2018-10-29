//
//  CustomerFollowEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "CustomerFollowItemEntity.h"

@interface CustomerFollowEntity : AgencyBaseEntity

@property (nonatomic,strong) NSArray *inqFollows;
@property (nonatomic,assign) NSInteger recordCount;

@end
