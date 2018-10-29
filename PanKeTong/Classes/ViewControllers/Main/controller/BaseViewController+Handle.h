//
//  BaseViewController+Handle.h
//  PanKeTong
//
//  Created by 李慧娟 on 2018/2/7.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "APPConfigEntity.h"

typedef NS_ENUM(NSInteger, JumpType)
{
    JumpToHTML = 1,                                         // 跳转到HTML
    JumpToNative = 2,                                       // 跳转到原生
    JumpToExternalApplication = 3,                          // 跳转到外部应用
};

@interface BaseViewController (Handle)

#pragma mark - 模块跳转

- (void)popWithAPPConfigEntity:(APPLocationEntity *)entity;

@end
