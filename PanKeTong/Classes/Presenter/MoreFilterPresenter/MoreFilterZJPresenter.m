//
//  MoreFilterHZPresenter.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/6/28.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "MoreFilterZJPresenter.h"

@implementation MoreFilterZJPresenter

/// 类型title集合
- (NSArray *)getHeaderTitleArray
{
//    return @[@"房型",@"房源状态",@"房屋现状",@"朝向",@"房源标签",@"建筑类型",@"建筑面积",@"价格"];
    return @[@"房型",@"房源状态",@"房屋现状",@"朝向",@"房源标签",@"建筑类型"]; // LJS 建筑面积 价格
}

///  获得类型集合
- (NSArray *)getValueArray
{
    return @[self.roomTypeValueArray.itemList,
             self.propStatusValueArray.itemList,
             self.propSituationValueArray.itemList,
             self.directionValueArray.itemList,
             self.propTagValueArray,
             self.buildingTypeValueArray.itemList];
}

/// 含有房源等级
- (BOOL)haveHousingGrade
{
    return NO;
}

/// 获得价格所在section
- (NSInteger)getPriceSectionNumber
{
    return 7;
}


@end
