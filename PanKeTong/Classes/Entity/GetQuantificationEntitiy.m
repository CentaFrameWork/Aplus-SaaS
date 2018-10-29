//
//  getQuantificationEntitiy.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/5/6.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetQuantificationEntitiy.h"
#import "GetQuantificationSubEntitiy.h"
#import "GetQuantificationItemEntitiy.h"
#import "GetTJQuantificationSubEntity.h"
#import "HQMyLiangHuaEntity.h"

@implementation GetQuantificationEntitiy
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"workStats":@"workStats"
                                          }];
}

+(NSValueTransformer *)workStatsJSONTransformer
{
    if ([CityCodeVersion isBeiJing]||[CityCodeVersion isNanJing]||[CityCodeVersion isChongQing]) {
        //北京
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[GetQuantificationSubEntitiy class]];
    }else if ([CityCodeVersion isTianJin]){
        //天津
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[GetTJQuantificationSubEntity class]];
    }else if ([CityCodeVersion isAoMenHengQin])
    {
        // 横琴
        return  [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[HQMyLiangHuaEntity class]];
    }

    //深圳 广州
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[GetQuantificationItemEntitiy class]];
}
@end
