//
//  MyPrivateLetterEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/12/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface MyPrivateLetterEntity : AgencyBaseEntity

@property (nonatomic,strong)NSArray * messages;
@property (nonatomic,assign)NSInteger recordCount;

@end
