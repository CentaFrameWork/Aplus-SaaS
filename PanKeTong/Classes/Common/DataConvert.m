//
//  DataConvert.m
//  MCocoapods
//
//  Created by 燕文强 on 16/7/26.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import "DataConvert.h"
#import "MTLJSONAdapter.h"

@implementation DataConvert

/**
 *  将Dic转成model
 */
+ (id)convertDic:(NSDictionary *)dic
        toEntity:(Class)cls
{
    return [MTLJSONAdapter modelOfClass:cls
                     fromJSONDictionary:dic
                                  error:nil];
}

/**
 *将 model 转化为Dic
 */

+ (id)convertEntityToDic:(id)entity
{
    return [MTLJSONAdapter JSONDictionaryFromModel:entity];
}


@end
