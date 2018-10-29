//
//  RecentBrowseUtil.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/6/2.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RecentBrowseUtils.h"
#import "DataBaseOperation.h"
#import "PropertysModelEntty.h"


/*
 *  最多记录一百条最近查看通盘房源id
 */
#define kMaxselectHouseIdCacheCount 100


@implementation RecentBrowseUtils

static NSMutableArray *houseIdArray;

+ (NSMutableArray *)checkHouseIdArray
{
    if (!houseIdArray) {
        //如果数组不存在，从数据库中读取
        houseIdArray = [NSMutableArray array];
        DataBaseOperation *dataBase = [DataBaseOperation sharedataBaseOperation];
        houseIdArray = [dataBase selectHouseIdCache];
    }
    return houseIdArray;
    
}

/*
 *  记录最近查看房号
 */
+ (void)setRecentBrowse:(NSString *)houseId
{
    [self checkHouseIdArray];
    DataBaseOperation *dataBase = [DataBaseOperation sharedataBaseOperation];
    [dataBase insertHouseID:houseId];
    [houseIdArray addObject:houseId];
    
    if (houseIdArray.count > kMaxselectHouseIdCacheCount) {
        [houseIdArray removeObjectAtIndex:0];
        [dataBase deleteFirstHouseId:houseId];
    }
}

/*
 *  查看该房源是否为缓存房源
 */
+ (BOOL)istHouseIdCache:(NSString *)houseId
{
    [self checkHouseIdArray];
    if ([houseIdArray containsObject:houseId]) {
        return YES;
    }else{
        return NO;
    }
}

@end
