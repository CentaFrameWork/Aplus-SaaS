//
//  GoOutScreeningVO.h
//  PanKeTong
//
//  Created by 王雅琦 on 2017/11/13.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseVO.h"

@interface GoOutScreeningVO : BaseVO

@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *endTime;
@property (nonatomic,copy)NSString *employeeKeyId;
@property (nonatomic,copy)NSString *employeeName;
@property (nonatomic,copy)NSString *employeeDeptKeyid;
@property (nonatomic,copy)NSString *employeeDeptName;

@end
