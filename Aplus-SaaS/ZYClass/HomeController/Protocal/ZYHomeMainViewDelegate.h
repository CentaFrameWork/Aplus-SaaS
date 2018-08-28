//
//  ZYHomeControllerDelegate.h
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/28.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZYHousePageFunc.h"

@protocol ZYHomeMainViewDelegate <NSObject>

/**
 *  获取到数据通知
 */
- (void)getServerData:(ZYHousePageFunc *)data;

@end
