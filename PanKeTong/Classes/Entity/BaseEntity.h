//
//  BaseEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

/**
 *  移动A+ 实体基类
 *
 */

#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "SQLiteManager.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@interface BaseEntity : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger  rCode;
@property (nonatomic, copy) NSString  *rMessage;
@property (nonatomic,assign) NSInteger total;
@property (nonatomic, assign) NSInteger tag;

+ (NSMutableDictionary *)getBaseFieldWithOthers:(NSDictionary *)dic;

@end
