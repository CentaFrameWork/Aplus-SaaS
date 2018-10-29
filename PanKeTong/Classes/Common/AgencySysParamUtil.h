//
//  AgencySysParamUtil.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemParamEntity.h"
#import "DataBaseOperation.h"

/// A+系统参数工具类
@interface AgencySysParamUtil : NSObject

/**
 *  获取系统参数
 */
+ (SystemParamEntity *)getSystemParam;


/**
 *  记录系统参数
 */
+ (void)setSystemParam:(SystemParamEntity *)sysParam;


/**
 * 根据系统参数类型Id获取系统参数实体
 */
+ (SysParamItemEntity *)getSysParamByTypeId:(NSInteger)typeId;

/**
 *  获得系统参数更新时间
 */
+ (NSString *)getSysParamNewUpdTime;

/*
 * 排除冻结且排序
 */
+ (NSArray *)selectItemDtoSortValid:(NSArray *)array;

/*
 * 排序
 */
+ (NSArray *)selectItemDtoSort:(NSArray *)array;

/*
 * 移除冻结状态下的Entity
 */
+ (NSArray *)removeFrozenSysParamEntity:(NSArray *)array;
@end
