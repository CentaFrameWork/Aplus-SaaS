//
//  NSObject+SQLiteManagerKeyValue.h
//  PanKeTong
//
//  Created by 陈行 on 2018/4/25.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SQLiteManagerKeyValue<NSObject>

@optional

/**
 *  这个数组中的属性名将会被忽略：不进行保存
 */
+ (NSArray *)chh_cache_ignoredPropertyNames;

/**
 *  这个数组中的属性名才会被允许解析缓存
 */
+ (NSArray *)chh_cache_allowedPropertyNames;

@end

@interface NSObject (SQLiteManagerKeyValue)<SQLiteManagerKeyValue>



@end
