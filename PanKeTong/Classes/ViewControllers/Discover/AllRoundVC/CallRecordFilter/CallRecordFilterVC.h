//
//  CallRecordFilterVC.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/19.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

@protocol CallRecordFilterDelegete <NSObject>

- (void)commitDataWithDepartment:(RemindPersonDetailEntity *)departEntity//部门
                    withEmployee:(RemindPersonDetailEntity *)employeeEntity//人员
                   withStartTime:(NSString *)startTime
                     withEndTime:(NSString *)endTime;

@end


/// 通话记录筛选
@interface CallRecordFilterVC : BaseViewController

@property (nonatomic,copy) NSString *startTimeShow;//开始时间
@property (nonatomic,copy) NSString *endTimeShow;//结束时间
@property (nonatomic,strong) RemindPersonDetailEntity *remindPersonDetailEntity1;//部门
@property (nonatomic,strong) RemindPersonDetailEntity *remindPersonDetailEntity2;//人员


@property (nonatomic,assign)id <CallRecordFilterDelegete>delegate;

@end
