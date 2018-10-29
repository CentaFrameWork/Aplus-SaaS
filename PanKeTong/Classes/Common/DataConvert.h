//
//  DataConvert.h
//  MCocoapods
//
//  Created by 燕文强 on 16/7/26.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import <Foundation/Foundation.h>
/// 数据转换
@interface DataConvert : NSObject

/**
 *  将Dic转成model
 */
+ (id)convertDic:(NSDictionary *)dic
        toEntity:(Class)cls;

/**
 *将 model 转化为Dic
 */

+ (id)convertEntityToDic:(id)entity;

@end
