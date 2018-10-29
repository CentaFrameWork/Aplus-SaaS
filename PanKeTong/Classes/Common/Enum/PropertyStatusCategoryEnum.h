//
//  PropertyStatusCategoryEnum.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/26.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#ifndef PropertyStatusCategoryEnum_h
#define PropertyStatusCategoryEnum_h

///房源状态
enum PropertyStatusCategoryEnum{
    VALID = 1,      // 有效
    DELAY = 2,      // 暂缓
    PREORDAIN = 3,  // 预订
    INVALID = 4,    // 无效
    SOLD = 5,       // 已售
    RENTED = 6,     // 已租
    EMPTY = 7,      // 空置
};

#endif /* PropertyStatusCategoryEnum_h */
