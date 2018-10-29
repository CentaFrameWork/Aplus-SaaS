//
//  WJDealListModel.m
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/20.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "WJDealListModel.h"

@implementation WJDealListModel

-(WJDealListModel *)initDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    if(value==nil || [value isKindOfClass:[NSNull class]])
    {
        return;
    }else
    {
        [super setValue:value forKey:key];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"key = %@",key);
}
@end
