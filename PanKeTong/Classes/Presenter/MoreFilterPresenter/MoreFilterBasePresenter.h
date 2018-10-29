//
//  MoreFilterBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/8.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"

@interface MoreFilterBasePresenter : BasePresenter

@property (strong, nonatomic) SysParamItemEntity *roomTypeValueArray;
@property (strong, nonatomic) SysParamItemEntity *propStatusValueArray;
@property (strong, nonatomic) SysParamItemEntity *propSituationValueArray;
@property (strong, nonatomic) NSMutableArray *roomLevelValueArray;
@property (strong, nonatomic) SysParamItemEntity *directionValueArray;
@property (strong, nonatomic) NSMutableArray *propTagValueArray;
@property (strong, nonatomic) SysParamItemEntity *buildingTypeValueArray;

@property (assign, nonatomic) id selfView;

- (instancetype)initWithDelegate:(id )delegate;

/// 获得每个类型的value集合
- (void)getEveryTypeValueArray;

/// 类型title集合
- (NSArray *)getHeaderTitleArray;

/// 类型value集合
- (NSArray *)getValueArray;

/// 含有房源等级
- (BOOL)haveHousingGrade;

/// 房源等级titel array
- (NSArray *)getHousingGradeTitleArray;

/// 房源等级value array
- (NSArray *)getHousingGradeValueArray;

/// 获得价格所在section
- (NSInteger)getPriceSectionNumber;

/// 获得建筑面积title
- (NSString *)getAreaOfBuildingTitle;

/// 是否含有委托已审
- (BOOL)haveTrustsApproved;

///是否含有证件齐全
- (BOOL)haveCompleteDoc;

///是否含有委托房源
- (BOOL)haveTrustProperty;

/// section add count
- (NSInteger)sectionAddCount;

@end
