//
//  SelectItemDtoEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface SelectItemDtoEntity : SubBaseEntity

/// <summary>
/// 值
/// </summary>
@property (nonatomic,strong) NSString *itemValue;

/// <summary>
/// 名称
/// </summary>
@property (nonatomic,strong) NSString *itemText;

/// <summary>
/// 编码
/// </summary>
@property (nonatomic,strong) NSString *itemCode;

/// <summary>
/// 状态
/// 1：ACTIVE-激活状态, 2:INACTIVE-冻结状态
/// </summary>
@property (nonatomic,assign) NSInteger itemStatus;

/// <summary>
/// 扩展属性
/// </summary>
@property (nonatomic,strong) NSString *extendAttr;

/// <summary>
/// 是否是默认值
/// </summary>
@property (nonatomic,assign) BOOL flagDefault;

/// <summary>
/// 排序号
/// </summary>
@property (nonatomic,assign) NSInteger seq ;

@end
