//
//  MessageEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "MessageResultEntity.h"
@interface MessageEntity : AgencyBaseEntity

@property (nonatomic,strong)NSArray * result;
@property (nonatomic,assign)NSInteger recordCount;

@end
