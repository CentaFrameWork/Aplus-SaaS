//
//  PropHZDetailPresenter.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/6/27.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "PropZJDetailPresenter.h"

@implementation PropZJDetailPresenter

/// 是否可以查看全部房号
- (BOOL)isAllHouseNum
{
    return YES;
}


/// 是否使用得实达康
- (BOOL)isUseDascom
{
    return NO;
}

// 是否使用虚拟号
- (BOOL)isCallVirtualPhone
{
    BOOL virtualCall = ![self.trustorEntity.virtualCall boolValue];
    if (virtualCall) {
        showMsg(@"暂未开通虚拟号！");
    }
    return virtualCall;
}


/// 是否可以显示联系人
- (NSString *)showTrustorsErrorMsg
{
    if(!self.trustorEntity.canBrowse)
    {
        return self.trustorEntity.noCallMessage;
    }

    return nil;
}

@end
