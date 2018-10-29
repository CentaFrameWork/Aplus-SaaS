//
//  CallRealPhoneLimitUtil.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseOperation.h"
#import "AgencyUserPermisstionUtil.h"

/// 拨打电话Util
@interface CallRealPhoneLimitUtil : NSObject

/**
 *  添加房源keyId
 *
 *  为做拨打电话计数处理
 */
+ (void)addCallRealPhoneRecordWithPropKeyId:(NSString *)propKeyId;

/**
 *  今日已拨打电话次数
 */
+ (NSInteger)getCountForToday;

/**
 *  删除非当日的拨打记录
 */
+ (void)deleteNotToday;

/**
 *  检查此房源id是否存在
 *
 *  为实现同一个房源不做计数处理
 */
+ (BOOL)isExistWithPropKeyId:(NSString *)propKeyId;

@end
