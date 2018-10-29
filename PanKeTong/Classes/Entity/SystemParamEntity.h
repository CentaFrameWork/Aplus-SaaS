//
//  SystemParamEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "SysParamItemEntity.h"

@interface SystemParamEntity : AgencyBaseEntity
/// <summary>
/// 系统参数最新更新时间
/// </summary>
@property (nonatomic,strong) NSString *sysParamNewUpdTime;

/// <summary>
/// 是否需要更新
/// </summary>
@property (nonatomic,assign) BOOL needUpdate;

/// <summary>
/// agency系统参数
/// </summary>
@property (nonatomic,strong) NSArray *sysParamList;
@end
