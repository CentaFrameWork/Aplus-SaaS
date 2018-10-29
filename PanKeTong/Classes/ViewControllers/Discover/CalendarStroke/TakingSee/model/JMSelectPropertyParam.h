//
//  JMSelectPropertyParam.h
//  PanKeTong
//
//  Created by 陈行 on 2018/6/7.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSelectPropertyParam : NSObject

/**
 *  显示的标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  根据对象取数据
 */
@property (nonatomic, copy) NSString * propKey;
/**
 *  单位
 */
@property (nonatomic, copy) NSString * unit;
/**
 *  是否显示单位
 */
@property (nonatomic, assign) BOOL isShowUnit;
/**
 *  显示的值
 */
@property (nonatomic, copy) NSString * value;

+ (NSMutableArray *)selectPropertyParamArrayFromPlist;

@end
