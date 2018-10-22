//
//  ZYHousePageFunc.h
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZYAplusBaseEntity.h"

@class ZYHousePageFuncItem;


@interface ZYHousePageFunc : ZYAplusBaseEntity

@property (nonatomic, strong) NSArray<ZYHousePageFuncItem *> * domains;

@end


@interface ZYHousePageFuncItem : NSObject
/**
 *  类型
 */
@property (nonatomic, copy) NSString * domain_type;
/**
 *  名称
 */
@property (nonatomic, copy) NSString * domain_name;
/**
 *  地址
 */
@property (nonatomic, copy) NSString * domain_url;
/**
 *  描述
 */
@property (nonatomic, copy) NSString * domain_description;
/**
 *  扩展
 */
@property (nonatomic, copy) NSString * domain_extend;

@end
