//
//  ChannelFilterEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/29.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemindPersonDetailEntity.h"

@interface ChannelFilterEntity : NSObject

@property (nonatomic,strong) NSDate *startTime; //开始日期
@property (nonatomic,strong) NSDate *endTime;   //结束日期
@property (nonatomic,strong) RemindPersonDetailEntity *department;  //所属部门
@property (nonatomic,strong) RemindPersonDetailEntity *person;  //所属经纪人
@property (nonatomic,strong) NSMutableArray *channelSource;    //渠道

@end
