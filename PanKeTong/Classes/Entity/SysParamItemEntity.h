//
//  SysParamItemEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"
#import "SelectItemDtoEntity.h"

@interface SysParamItemEntity : SubBaseEntity
/// <summary>
/// 参数名称
/// </summary>
@property (nonatomic,strong) NSString *parameterName;

/// <summary>
/// 参数类型
/// </summary>
@property (nonatomic,assign) NSInteger parameterType;

/// <summary>
/// 参数状态
/// </summary>
@property (nonatomic,assign) NSNumber *parameterStatus ;

/// <summary>
/// 房源筛选条件选项集合
/// </summary>
@property (nonatomic,strong) NSArray *itemList;

@end
