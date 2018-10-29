//
//  TakeLookScreeningVO.h
//  PanKeTong
//
//  Created by 王雅琦 on 2017/11/13.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseVO.h"

@interface TakeLookScreeningVO : BaseVO

@property (nonatomic,copy)NSString *dateTimeStart;
@property (nonatomic,copy)NSString *dateTimeEnd;
@property (nonatomic,copy)NSString *employeeName;
@property (nonatomic,copy)NSString *departmentKeyId;
@property (nonatomic,copy)NSString *departmentName;
@property (nonatomic,copy)NSString *seePropertyType;

@end
