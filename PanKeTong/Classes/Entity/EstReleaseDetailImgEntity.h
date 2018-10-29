//
//  EstReleaseDetailImgEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface EstReleaseDetailImgEntity : SubBaseEntity
@property (nonatomic,assign)NSInteger recordCount;
@property (nonatomic,strong)NSArray * records;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)NSString * statusMessage;
@property (nonatomic,assign)NSInteger tag;
@end
