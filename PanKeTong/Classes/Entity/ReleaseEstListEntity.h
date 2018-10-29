//
//  ReleaseEstListEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/20.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface ReleaseEstListEntity : SubBaseEntity

@property (nonatomic,assign)NSInteger recordCount;
@property (nonatomic,strong)NSArray * advertPropertys;
@property (nonatomic,strong)NSString* errorMsg;
@property (nonatomic,strong)NSString * runTime;
@property (nonatomic,assign)BOOL flag;
@property (nonatomic,assign)NSInteger tag;
@end
