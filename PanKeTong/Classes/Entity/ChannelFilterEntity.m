//
//  ChannelFilterEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/29.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "ChannelFilterEntity.h"

@implementation ChannelFilterEntity

- (instancetype)init{
    self = [super init];
    if (self) {
        self.channelSource = [NSMutableArray array];
    }
    return self;
}
@end
