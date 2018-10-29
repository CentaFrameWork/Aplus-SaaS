//
//  TrustFilterVC.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/19.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseViewController.h"


@protocol TrustFilterDelegate <NSObject>
@optional
- (void)trustFilterWithEstateName:(NSString *)estateName
                   andEstateKeyId:(NSString *)estateKeyId
                 andBuildingNames:(NSString *)buildingNames
                 andBuildingKeyId:(NSString *)buildingKeyId
                       andHouseNo:(NSString *)houseNo
                andEmployeeEntity:(RemindPersonDetailEntity *)employeeEntity
                    andDeptEntity:(RemindPersonDetailEntity *)deptEntity
                      andTimeFrom:(NSString *)timeFrom
                        andTimeTo:(NSString *)timeTo;
@end



/// 委托审核筛选
@interface TrustFilterVC : BaseViewController

@property (nonatomic,copy) NSString *estateName;// 楼盘名
@property (nonatomic,copy) NSString *estateKeyId;
@property (nonatomic,copy) NSString *buildingName;// 楼栋名
@property (nonatomic,copy) NSString *buildingKeyId;
@property (nonatomic,copy) NSString *searchPropertyNum;// 搜索房号
@property (nonatomic,copy) NSString *startTime;// 开始日期
@property (nonatomic,copy) NSString *endTime;// 结束日期

@property (nonatomic,strong) RemindPersonDetailEntity *departEntity;// 签署部门名称
@property (nonatomic,strong) RemindPersonDetailEntity *employeeEntity;// 签署人名称

@property (nonatomic,assign) id <TrustFilterDelegate>trustFilterDelegate;

@end
