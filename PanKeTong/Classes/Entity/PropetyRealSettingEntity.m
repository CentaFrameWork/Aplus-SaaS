//
//  PropetyRealSettingEntity.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "PropetyRealSettingEntity.h"

@implementation PropetyRealSettingEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *dic = [self getBaseFieldWithOthers:@{
                                                       @"minUpdate":@"MinUpdate",
                                                       @"maxUpdate":@"MaxUpdate",
                                                       @"maxRoomPhotoCount":@"MaxRoomPhotoCount",
                                                       @"fictitiousNumberSwitch":@"FictitiousNumberSwitch",
                                                       @"virtualCall":@"VirtualCall",
                                                       @"imageMinWidth":@"ImageMinWidth",
                                                       @"imageMinHeight":@"ImageMinHeight",
                                                       @"centaBoxSwitch":@"CentaBoxSwitch",
                                                       @"boxRange":@"BoxRange"
                                                    }];
    return dic;
}

@end
