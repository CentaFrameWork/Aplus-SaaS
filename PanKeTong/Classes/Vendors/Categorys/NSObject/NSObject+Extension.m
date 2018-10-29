//
//  NSObject+Extension.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/7/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "NSObject+Extension.h"

#import <MJExtension/MJExtension.h>
#import <objc/runtime.h>

@implementation NSObject (Extension)

/// 判断类／字符串是否为空
- (BOOL)isNil
{
    if ([self isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else
    {
        if ([self isKindOfClass:[NSString class]])
        {
            NSString *str = (NSString *)self;
            NSString *checkStr = [NSString stringWithFormat:@"%@",str];

            return [checkStr isEqualToString:@"(null)"] || [checkStr isEqualToString:@""] || checkStr.length == 0 ? YES:NO;
        }
        else
        {
            return NO;
        }
    }
}


/// 从实体转化为字典
- (NSDictionary *)dictionaryFromModel
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];

    for (int i = 0; i < count; i++)
    {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];

        //only add it to dictionary if it is not nil
        if (key && value) {
            if ([value isKindOfClass:[NSString class]]
                || [value isKindOfClass:[NSNumber class]])
            {
                // 普通类型的直接变成字典的值
                [dict setObject:value forKey:key];
            }
            else if ([value isKindOfClass:[NSArray class]]
                     || [value isKindOfClass:[NSDictionary class]])
            {
                // 数组类型或字典类型
                [dict setObject:[self idFromObject:value] forKey:key];
            }
            else
            {
                // 如果model里有其他自定义模型，则递归将其转换为字典
                [dict setObject:[value dictionaryFromModel] forKey:key];
            }
        }
        else if (key && value == nil)
        {
            // 如果当前对象该值为空，设为nil。在字典中直接加nil会抛异常，需要加NSNull对象
            [dict setObject:[NSNull null] forKey:key];
        }
    }

    free(properties);
    return dict;
}

- (id)idFromObject:(nonnull id)object
{
    if ([object isKindOfClass:[NSArray class]])
    {
        if (object != nil && [object count] > 0)
        {
            NSMutableArray *array = [NSMutableArray array];
            for (id obj in object)
            {
                // 基本类型直接添加
                if ([obj isKindOfClass:[NSString class]]
                    || [obj isKindOfClass:[NSNumber class]])
                {
                    [array addObject:obj];
                }
                // 字典或数组需递归处理
                else if ([obj isKindOfClass:[NSDictionary class]]
                         || [obj isKindOfClass:[NSArray class]])
                {
                    [array addObject:[self idFromObject:obj]];
                }
                // model转化为字典
                else
                {
                    [array addObject:[obj dictionaryFromModel]];
                }
            }
            return array;
        }
        else
        {
            return object ? : [NSNull null];
        }
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        if (object && [[object allKeys] count] > 0)
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *key in [object allKeys])
            {
                // 基本类型直接添加
                if ([object[key] isKindOfClass:[NSNumber class]]
                    || [object[key] isKindOfClass:[NSString class]])
                {
                    [dic setObject:object[key] forKey:key];
                }
                // 字典或数组需递归处理
                else if ([object[key] isKindOfClass:[NSArray class]]
                         || [object[key] isKindOfClass:[NSDictionary class]])
                {
                    [dic setObject:[self idFromObject:object[key]] forKey:key];
                }
                // model转化为字典
                else
                {
                    [dic setObject:[object[key] dictionaryFromModel] forKey:key];
                }
            }
            return dic;
        }
        else
        {
            return object ? : [NSNull null];
        }
    }

    return [NSNull null];
}

- (NSString *)otherDescription{
    
    NSMutableString * str=[NSMutableString string];
    
    [str appendFormat:@"%@ [",NSStringFromClass([self class])];
    
    NSMutableArray * pros = [self propertyNameArray];
    
    for (NSString * key in pros) {
        id value = [self valueForKey:key];
        [str appendFormat:@"%@=%@,", key, value];
        
    }
    
    [str appendString:@"]"];
    
    return str;
}

- (instancetype)objectForCopy{
    
    NSArray * propNameArr = [self propertyNameArray];
    
    NSString * className = NSStringFromClass([self class]);
    
    NSObject * newObject = [[NSClassFromString(className) alloc] init];
    
    for (NSString * propName in propNameArr) {
        [newObject setValue:[self valueForKey:propName] forKey:propName];
    }
    
    return newObject;
}

+ (NSMutableArray *)propertyNameArray{
    
    __strong NSMutableArray * properties = [[NSMutableArray alloc] init];
    
    [[self class] mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        
        [properties addObject:property.name];
        
    }];
    
    return properties;
    
}

- (NSMutableArray *)propertyNameArray{
    
    __strong NSMutableArray * properties = [[NSMutableArray alloc] init];
    
    [[self class] mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        
        [properties addObject:property.name];
        
    }];
    
    return properties;
    
//    NSMutableArray * array=[[NSMutableArray alloc]init];
//    unsigned int count;
//
//    objc_property_t * pros=class_copyPropertyList([self class], &count);
//
//    for(int i=0;i<count;i++){
//        objc_property_t property= pros[i];
//        const char * nameChar=property_getName(property);
//        NSString * name=[NSString stringWithFormat:@"%s",nameChar];
//        [array addObject:name];
//    }
//    free(pros);
//    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    NSLog(@"%@不存在", key);
    
}

- (id)valueForUndefinedKey:(NSString *)key{
    
    NSLog(@"%@不存在", key);
    
    return nil;
    
}

- (UIAlertController *)presentAlterVCWithString:(NSString*)string {
    
    NSString *title = [string stringByAppendingString:@"未授权"];
    NSString *message = [NSString stringWithFormat:@"请前往设置，打开原萃的%@权限后继续使用",string];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:1 handler:nil]];
    
    return alert;
}





@end
