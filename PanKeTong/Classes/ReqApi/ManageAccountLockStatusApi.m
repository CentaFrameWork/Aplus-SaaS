//
//  ManageAccountLockStatusApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ManageAccountLockStatusApi.h"
#import "LockStatusEntity.h"


@implementation ManageAccountLockStatusApi

- (NSString *)getPath
{
    return @"AccountLock";

}

- (NSDictionary *)getBody{
    
    return @{
             @"Mobile" : self.mobile ? : @"",
             };
}


- (int)getRequestMethod {
    
    if (self.ManageAccountLockStatusType == GetAccountLockStatus) {
        //获取
        return RequestMethodGET;
    }
    //重置
    return RequestMethodPOST;
}

- (Class)getRespClass
{
    return [LockStatusEntity class];
}



@end
