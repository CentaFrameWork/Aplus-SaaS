//
//  DataFilterEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/11/2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"
#import "FilterEntity.h"
@interface DataFilterEntity : SubBaseEntity


/*
    筛选的名字
 */
@property (nonatomic,strong)NSString * nameString;

/*
    筛选展现的文字
 */
@property (nonatomic,strong)NSString * showText;

/*
    筛选发请求的实体
 */
@property (nonatomic,strong)NSString * entity;


@end
