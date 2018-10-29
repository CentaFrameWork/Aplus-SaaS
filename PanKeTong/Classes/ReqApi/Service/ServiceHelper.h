//
//  ServiceHelper.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Error.h"
#import "BaseEntity.h"
#import "AgencyBaseEntity.h"
#import "PropListEntity.h"

@interface ServiceHelper : NSObject


+ (id)checkAuthorityWith:(id)responseData;

/**
 *  检查北京返回数据
 *
 *  @param dic 返回数据
 *
 *  @return error/entity
 */
+ (id)checkAPlusData:(NSDictionary *)dic;

/**
 *  检查深圳返回数据
 *
 *  @param dic 返回数据
 *
 *  @return error/entity
 */
+ (id)checkHKData:(NSDictionary *)dic;
@end
