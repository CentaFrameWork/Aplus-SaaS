//
//  TakingSeeVC.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "RemindPersonDetailEntity.h"

/// 约看
@interface TakingSeeVC : BaseViewController

@property (nonatomic,strong) RemindPersonDetailEntity *departmentEntity;    // 部门
@property (nonatomic,strong) RemindPersonDetailEntity *employeeEntity;      // 人员
@property (nonatomic,copy) NSString *dateTimeStart; // 开始时间
@property (nonatomic,copy) NSString *dateTimeEnd;   // 结束时间

@property (nonatomic, assign) BOOL isPopToRoot;

@end
