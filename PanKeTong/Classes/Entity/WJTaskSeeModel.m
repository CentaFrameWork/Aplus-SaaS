//
//  WJTaskSeeModel.m
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/9.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "WJTaskSeeModel.h"

@implementation WJTaskSeeModel

-(WJTaskSeeModel *)initDic:(NSDictionary *)dic
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
    }else if([key isEqualToString:@"PropertyList"])
    {
        NSMutableArray * dataArray = [[NSMutableArray alloc] init];
        if (value == nil) {
            //
            self.PropertyList = [NSArray array];
        }else {
            NSArray * arr = value;
            for (int i=0; i < arr.count; i++) {
                PropertyList * mod = [[PropertyList alloc] initDic:arr[i]];
                [dataArray addObject:mod];
            }
            self.PropertyList = dataArray;
        }
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

@implementation PropertyList

-(PropertyList *)initDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
    
    
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"key = %@",key);
}

@end

