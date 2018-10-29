    //
    //  NetSpeedUtility.h
    //  PanKeTong
    //
    //  Created by Liyn on 2017/11/29.
    //  Copyright © 2017年 中原集团. All rights reserved.
    //

#import <Foundation/Foundation.h>

typedef void(^SpeedBloack)(NSString *speedDescrition);

@interface NetSpeedUtility : NSObject

    // 网卡下载的速度
+ (long long) getInputInterfaceBytes;
    // 网卡上传的速度
+ (long long) getOutputInterfaceBytes;

    //当前上传或者下载

// 当前上传或者下载速度
+ (NSString *)getNetSpeedWithTotalSize:(long long)totalSize
                              progress:(float)progress
                          lastProgress:(float)lastProgress
                                  time:(NSInteger)time;

@end
