//
//  FindIsExitAdApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///判断是否已存在在上架区
@interface FindIsExitAdApi : APlusBaseApi

@property (nonatomic,copy)NSString *propertyKeyId;//房源ID
@property (nonatomic,copy)NSString *tradeType;//交易类型

@end
