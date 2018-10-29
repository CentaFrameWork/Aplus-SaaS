//
//  ZYDealScreen.h
//  PanKeTong
//
//  Created by 陈行 on 2018/4/9.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZYCodeName.h"

@interface ZYDealScreen : NSObject

@property (nonatomic, copy) NSString * propertyCategory;

@property (nonatomic, assign) NSInteger selectType;//选中类型标示
@property (nonatomic, copy) NSString * startTime;//开始时间
@property (nonatomic, copy) NSString * endTime;//结束时间
@property (nonatomic, copy) NSString * type;//交易类型
@property (nonatomic, copy) NSString * typeID;//交易类型
@property (nonatomic, copy) NSString * dealPeople;//成交人
@property (nonatomic, copy) NSString * dealPeopleId;//成交人ID
@property (nonatomic, copy) NSString * resultsPeople;//业绩分配人
@property (nonatomic, copy) NSString * resultsPeopleId;//业绩分配人ID
@property (nonatomic, copy) NSString * buildingNameKey;//楼盘名称
@property (nonatomic, copy) NSString * buildingNameValue;//楼盘名称id
@property (nonatomic, copy) NSString * unitNameKey;//栋座单元名称
@property (nonatomic, copy) NSString * unitNamevalue;//栋座单元id

@property (nonatomic, strong) ZYCodeName * progress;//成交进度



@end
