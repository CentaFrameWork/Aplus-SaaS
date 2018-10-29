    //
    //  NetSpeedUtility.m
    //  PanKeTong
    //
    //  Created by Liyn on 2017/11/29.
    //  Copyright © 2017年 中原集团. All rights reserved.
    //

#import "NetSpeedUtility.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@implementation NetSpeedUtility

+ (NetSpeedUtility *)shareNetSpeedUtility{
    
    static NetSpeedUtility *net = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        net = [[NetSpeedUtility alloc]init];
    });
    return net;
    
}

// 网卡下载的速度
+ (long long) getInputInterfaceBytes
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }

    uint32_t iBytes = 0;

    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;

        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;

        if (ifa->ifa_data == 0)
            continue;

        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;

            iBytes += if_data->ifi_ibytes;
        }
    }
    freeifaddrs(ifa_list);
    return iBytes;
}

// 网卡上传的速度
+ (long long) getOutputInterfaceBytes
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }

    uint32_t oBytes = 0;

    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;

        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;

        if (ifa->ifa_data == 0)
            continue;

        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;

            oBytes += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);

    return oBytes;
}

// 当前上传或者下载速度
+ (NSString *)getNetSpeedWithTotalSize:(long long)totalSize
                              progress:(float)progress
                          lastProgress:(float)lastProgress
                                  time:(NSInteger)time
{
    //进度差值
    float progressGap = progress - lastProgress;
    
    //大小差值
    long long byte = llabs((long long)(totalSize * progressGap));
    
    //速度 字节数每秒
    float bps = byte / time; // (Byte per second)
    
    NSString * bytePerSecond = nil;
    
    if (bps < 1024) { //(Byte per second)
        
        NSInteger speed = bps;
        bytePerSecond = [NSString stringWithFormat:@"%ld B/S",speed];
        
    }else if (bps < 1024 * 1024 ){ //(KiloByte per second)
        
        NSInteger speed = bps / 1024.0;
        bytePerSecond = [NSString stringWithFormat:@"%ld KB/S",speed];
        
        
    }else if (bps  < 1024 * 1024 * 1024) {//(millonByte per second)
        
        float speed = bps / 1024 / 1024.0;
        bytePerSecond = [NSString stringWithFormat:@"%.1f MB/S",speed];
        
    }
    return bytePerSecond;//[NSString stringWithFormat:@"%lld",byte];
}

@end
