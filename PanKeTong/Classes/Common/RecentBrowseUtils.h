//
//  RecentBrowseUtils.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/6/2.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 最近浏览Util
@interface RecentBrowseUtils : NSObject

/*
 *  记录最近查看房号
 */
+ (void)setRecentBrowse:(NSString *)houseId;

/*
 *  查看该房源是否为缓存房源
 */
+ (BOOL)istHouseIdCache:(NSString *)houseId;

@end
