//
//  MoreFilterBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/8.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "MoreFilterBasePresenter.h"

@interface MoreFilterBasePresenter ()


@end

@implementation MoreFilterBasePresenter

- (instancetype)initWithDelegate:(id )delegate
{
    self = [super init];
    if (self) {
        _selfView = delegate;
        [self getEveryTypeValueArray];
    }
    return self;
}

/// 获得每个类型的value集合
- (void)getEveryTypeValueArray
{
    _roomTypeValueArray = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_ROOM_TYPE];
    _propStatusValueArray = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_PROP_STATUS];
    _propSituationValueArray = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_PROP_SITUATION];
    
    _roomLevelValueArray = [NSMutableArray array];
    NSArray *housingGradeTitleArray = [self getHousingGradeTitleArray];
    NSArray *housingGradeValueArray = [self getHousingGradeValueArray];
    
    for (int i = 0; i < housingGradeValueArray.count; i++)
    {
        SelectItemDtoEntity *entity = [SelectItemDtoEntity new];
        
        entity.itemText = housingGradeTitleArray[i];
        entity.itemValue = housingGradeValueArray[i];
        
        [_roomLevelValueArray addObject:entity];    // LJS 通盘房源更多筛选
    }
    
    _directionValueArray = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_DIRECTION];
    SysParamItemEntity *propTag = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_PROP_TAG];
    _propTagValueArray = [NSMutableArray arrayWithArray:propTag.itemList];  // LJS 通盘房源更多筛选
    
    _buildingTypeValueArray = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_BUILDING_TYPE];
    
    // 添加委托已审
//    SelectItemDtoEntity *entrustExamine = [SelectItemDtoEntity new];
//    entrustExamine.itemText = @"委托已审";
//    
//    [self.propTagValueArray addObject:entrustExamine];
}

/// 类型title集合
- (NSArray *)getHeaderTitleArray
{
    return @[@"房型",@"建筑面积",@"房源状态",@"房屋现状",@"房屋等级",@"朝向",@"房源标签",@"建筑类型"];
}

/// 类型value集合
- (NSArray *)getValueArray
{
    return @[self.roomTypeValueArray.itemList,
             @[[SelectItemDtoEntity new]],                                   // 建筑面积
             self.propStatusValueArray.itemList,
             self.propSituationValueArray.itemList,
             self.roomLevelValueArray,
             self.directionValueArray.itemList,
             self.propTagValueArray,
             self.buildingTypeValueArray.itemList];
}

/// 含有房源等级
- (BOOL)haveHousingGrade
{
    return YES;
}

/// 是否含有委托已审
- (BOOL)haveTrustsApproved
{
    return YES;
}

///是否含有证件齐全
- (BOOL)haveCompleteDoc{
    return NO;
}

///是否含有委托房源
- (BOOL)haveTrustProperty{
    return NO;
}

/// 房源等级titel array
- (NSArray *)getHousingGradeTitleArray
{
    return @[@"A级",@"B级",@"C级",@"D级"];
}

/// 房源等级value array
- (NSArray *)getHousingGradeValueArray
{
    return @[@"A",@"B",@"C",@"D"];
}

/// 获得价格所在section
- (NSInteger)getPriceSectionNumber
{
    return 8;
}

/// 获得建筑面积title
- (NSString *)getAreaOfBuildingTitle
{
    return @"建筑面积(㎡)";
}

- (NSInteger)sectionAddCount
{
    return 2;
}

@end
