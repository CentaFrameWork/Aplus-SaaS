//
//  MyPerformanceEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/7.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "MyPerformanceEntity.h"

@implementation PerformanceItemEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"employeeName":@"EmployeeName",
             @"billCount":@"BillCount",
             @"achievementDiff":@"AchievementDiff",
             @"achievementPlace":@"AchievementPlace",
             @"performance":@"Performance",
             };

}

@end


@implementation MyPerformanceEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"result":@"Result",
             };

}

+(NSValueTransformer *)resultJSONTransformer
{

    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PerformanceItemEntity class]];
}


@end
