//
//  ZYCodeName.m
//  PanKeTong
//
//  Created by 陈行 on 2018/4/10.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "ZYCodeName.h"

#import <MJExtension/MJExtension.h>

@implementation ZYCodeName

+ (NSMutableArray *)codeNameArrWithFileName:(NSString *)fileName{
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    NSArray * tmpArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in tmpArr) {
        
        [dataArray addObject:[self mj_objectWithKeyValues:dict]];
        
    }
    
    return dataArray;
    
}

@end
