//
//  RealSurveyFilterVC.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/15.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchRemindPersonViewController.h"
@class RealSurveyAuditingEntity;

typedef enum
{
    RealSurveyPerson = 1,//实勘人
    RealSurveyDeparment,//实勘部门
    ExaminePerson,//审核人
}SearchRealSurveyType;



@protocol RealSurveyFilterDelegate <NSObject>

- (void)RealSurveyFilterWithRealSurveyAuditingEntity:(RealSurveyAuditingEntity *)Entity;

@end


@interface RealSurveyFilterVC : BaseViewController

@property (nonatomic,readwrite,strong)NSString *startTime;       //开始时间
@property (nonatomic,readwrite,strong)NSString *endTime;         //结束时间
@property (nonatomic, assign)id <RealSurveyFilterDelegate>delegate;
@property (nonatomic,strong)NSDictionary *dataDic;
//@property (strong, nonatomic)RealSurveyAuditingEntity *realSurveyAuditingEntity;


@end
