//
//  CheckRoomNumUtil.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 查看房号Util
@interface CheckRoomNumUtil : NSObject

/**
 *  查看，剩余查看房号次数
 */
+ (NSInteger)timesOfCheckNum;

/**
 *  查看房号
 */
+ (void)useCheckRoomNumLimit;

@end
