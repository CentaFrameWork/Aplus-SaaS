//
//  NSObject+Description.m
//  my——QQ分组
//
//  Created by 陈行 on 15-11-11.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "NSObject+Description.h"
#import <objc/runtime.h>

@implementation NSObject (Description)

- (NSString *)otherDescription{
    NSMutableString * str = [NSMutableString string];
    
    [str appendFormat:@"%@ [",NSStringFromClass([self class])];
    Class clazz = [self class];
    unsigned int count;
    
    objc_property_t * pros = class_copyPropertyList(clazz, &count);
    for(int i=0;i<count;i++){
        if(i!=0){
            [str appendString:@", "];
        }
        objc_property_t property = pros[i];
        const char * nameChar = property_getName(property);
        NSString * name = [NSString stringWithFormat:@"%s",nameChar];
        id value = [self valueForKey:name];
        [str appendFormat:@"%@=%@",name,value];
    }
    [str appendString:@"]"];
    return str;
}

@end
