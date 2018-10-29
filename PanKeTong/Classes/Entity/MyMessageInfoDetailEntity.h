//
//  MyMessageInfoDetailEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/12/2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "MyMessageInfoDetailResultEntity.h"
@interface MyMessageInfoDetailEntity : AgencyBaseEntity


@property (nonatomic,strong)NSArray * result;
@property (nonatomic,assign)NSInteger recordCount;

@end
