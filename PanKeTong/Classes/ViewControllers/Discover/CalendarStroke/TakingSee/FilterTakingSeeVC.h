//
//  FilterTakingSeeVC.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/30.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "RemindPersonDetailEntity.h"


@protocol FilterDelegate <NSObject>

- (void)commitDataWithDepartment:(RemindPersonDetailEntity *)departEntity   // 部门
                    withEmployee:(RemindPersonDetailEntity *)employeeEntity // 人员
                   withStartTime:(NSString *)startTime
                     withEndTime:(NSString *)endTime;

@end

/// 约看筛选
@interface FilterTakingSeeVC : BaseViewController

@property (nonatomic,copy) NSString *startTime; // 开始时间
@property (nonatomic,copy) NSString *endTime;   // 结束时间
@property (nonatomic,strong) RemindPersonDetailEntity *remindPersonDetailEntity1;   // 部门
@property (nonatomic,strong) RemindPersonDetailEntity *remindPersonDetailEntity2;   // 人员

@property (nonatomic,assign)id <FilterDelegate>myDelegate;

@end
