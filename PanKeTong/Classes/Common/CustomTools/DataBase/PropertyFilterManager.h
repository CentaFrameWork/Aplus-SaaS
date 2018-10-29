//
//  PropertyFilterManager.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseManager.h"

/// 房源筛选条件
@interface PropertyFilterManager : BaseManager

- (void)insertFilterConditionName:(NSString *)filterName
                      FilterValue:(NSString *)filterShowText
                     FilterEntity:(NSString *)filterEntity;

- (void)deleteFilterConditionName:(NSString *)filterName;

- (void)deleteAllFilterCondition;

- (void)updateFilterConditionName:(NSString *)newName
                             from:(NSString *)oldName;

- (void)updateFilterConditionIsCurrent:(NSString *)newFilterEntity
                        fromFilterName:(NSString*)name;

- (NSMutableArray *)selectAllFilterCondition;

@end



//@interface DataFilterEntity : NSObject
//
//// 筛选的名字
//@property (nonatomic,strong)NSString * nameString;
//
//// 筛选展现的文字
//@property (nonatomic,strong)NSString * showText;
//
//// 筛选发请求的实体
//@property (nonatomic,strong)NSString * entity;
//
//@end



