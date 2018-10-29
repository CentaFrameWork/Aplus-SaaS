//
//  OperateResultEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface OperateResultEntity : SubBaseEntity

@property (nonatomic,assign)BOOL operateResult;
@property (nonatomic,strong)NSString *faildReason;

@end
