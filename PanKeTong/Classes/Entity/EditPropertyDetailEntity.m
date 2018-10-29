//
//  EditPropertyDetailEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/28.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "EditPropertyDetailEntity.h"

@implementation EditPropertyDetailEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *dic = [self getBaseFieldWithOthers:@{
                                                       @"salePrice":@"SalePrice",
                                                       @"rentPrice":@"RentPrice",
                                                       @"houseDirectionKeyId":@"HouseDirectionKeyId",
                                                       @"propertyRightNatureKeyId":@"PropertyRightNatureKeyId",
                                                       @"square":@"Square",
                                                       @"squareUse":@"SquareUse",
                                                       @"propertyChiefKeyId":@"PropertyChiefKeyId",
                                                       @"propertyChiefDepartmentKeyId":@"PropertyChiefDepartmentKeyId",
                                                       @"propertyStatusCategory":@"PropertyStatusCategory",
                                                       @"propertyUsageKeyId":@"PropertyUsageKeyId",
                                                       @"isLockSquare":@"IsLockSquare"
                                                       }];
    NSLog(@"%@",dic);
    return dic;
}


@end
