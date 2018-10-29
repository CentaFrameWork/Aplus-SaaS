//
//  AgencySysParamUtil.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencySysParamUtil.h"

@implementation AgencySysParamUtil

static NSString *tag_sysParam = @"SystemParam";
// 系统参数对象
static SystemParamEntity *systemParam;

+ (SystemParamEntity *)getSystemParam
{
    [self checkSystemParam];
    return systemParam;
}

+ (void)setSystemParam:(SystemParamEntity *)sysParam
{
    systemParam = sysParam;
    
    DataBaseOperation *dataBase = [DataBaseOperation sharedataBaseOperation];
    
    NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:sysParam];
    NSString *sysParamJson = [dic JSONString];
    
    [dataBase insertSystemParamWithJson:sysParamJson];
}


/**
 * 根据系统参数类型Id获取系统参数实体
 */
+ (SysParamItemEntity *)getSysParamByTypeId:(NSInteger)typeId
{
    SystemParamEntity *mSysParam = [self getSystemParam];
    SysParamItemEntity *result = [[SysParamItemEntity alloc]init];
    
    
    if (mSysParam) {
        for (SysParamItemEntity *sysPara in mSysParam.sysParamList) {
            if (sysPara.parameterType == typeId) {
                result = sysPara;
                break;
            }
        }
    } else {
        NSLog(@"AgencySysParam is Null");
    }
    
    
    return result;
}

+ (NSString *)getSysParamNewUpdTime
{
    NSString *sysParamNewUpdTime = @"2015-08-01";
    if([AgencySysParamUtil getSystemParam])
    {
        sysParamNewUpdTime = [AgencySysParamUtil getSystemParam].sysParamNewUpdTime;
    }
    
    return sysParamNewUpdTime;
}

+ (void)checkSystemParam
{
    if(!systemParam)
    {
        //如果本地没有数据，添加数据
        DataBaseOperation *dataBase = [DataBaseOperation sharedataBaseOperation];
        SystemParamEntity *mSysParam = [dataBase selectSystemParam];
        
        systemParam = mSysParam;
    }
}

// 排除冻结array 且 排序
+ (NSArray *)selectItemDtoSortValid:(NSArray *)array
{
    // 移除冻结状态的值
    NSArray *newArray = [AgencySysParamUtil removeFrozenSysParamEntity:array];
    // 排序
    newArray = [AgencySysParamUtil selectItemDtoSort:newArray];
    
    return newArray;
}


// 排序
+ (NSArray *)selectItemDtoSort:(NSArray *)array
{
    NSArray *newArray = nil;
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    
    int arrayCount = mutableArray.count;
    
    for (int i = 0; i < arrayCount - 1; i++) {
        for (int j = 0; j < arrayCount - 1 - i; j++) {
            
            SelectItemDtoEntity *sysParamEntity = mutableArray[j];
            SelectItemDtoEntity *nextSysParamEntity = mutableArray[j+1];
            
            if (sysParamEntity.seq > nextSysParamEntity.seq) {
                SelectItemDtoEntity *temp = mutableArray[j];
                mutableArray[j] = mutableArray[j+1];
                mutableArray[j+1] = temp;
                
            }
            
        }
    }
    
    
    newArray = (NSArray *)mutableArray;
    

    return newArray;
    
}

// 移除冻结状态下的Entity
+ (NSArray *)removeFrozenSysParamEntity:(NSArray *)array
{
   
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    
    for (int i = mutableArray.count - 1; i >= 0; i--) {
       
        SelectItemDtoEntity *sysParamEntity = mutableArray[i];
        
        if (sysParamEntity.itemStatus == 2) {
            [mutableArray removeObject:sysParamEntity];
        }

    }
    
    NSArray *newArray = [NSArray arrayWithArray:mutableArray];
    
    return newArray;
}

@end
