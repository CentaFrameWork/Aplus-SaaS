//
//  SearchPropDetailEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface SearchPropDetailEntity : SubBaseEntity

@property (nonatomic, copy) NSString *itemValue;    // 楼盘名
@property (nonatomic, copy) NSString *itemText;
@property (nonatomic, copy) NSString *extendAttr;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *houseNo;
@property (nonatomic, copy) NSString *districtName; // 城区
@property (nonatomic, copy) NSString *areaName;     // 片区

@end
