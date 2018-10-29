//
//  AgencyBaseEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

/**
 *  Agency 实体基类
 *
 */

#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@interface AgencyBaseEntity : MTLModel<MTLJSONSerializing>

@property (nonatomic,assign) BOOL flag;
@property (nonatomic,strong) NSString *errorMsg;
@property (nonatomic,strong) NSString *runTime;
@property (nonatomic,assign) NSInteger tag;

+ (NSMutableDictionary *)getBaseFieldMapping;
+ (NSMutableDictionary *)getBaseFieldWithOthers:(NSDictionary *)dic;

@end
