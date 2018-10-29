//
//  JMSelectPropertyParam.m
//  PanKeTong
//
//  Created by 陈行 on 2018/6/7.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMSelectPropertyParam.h"

#import <MJExtension/MJExtension.h>

@implementation JMSelectPropertyParam

+ (NSMutableArray *)selectPropertyParamArrayFromPlist{
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"select_property_param.plist" ofType:nil];
    
    NSMutableArray * paramArr = [JMSelectPropertyParam mj_objectArrayWithFile:filePath];
    
    return paramArr;
    
}

@end
