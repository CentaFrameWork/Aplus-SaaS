//
//  ZYHomeControllerPresent.h
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYBasePresent.h"

@protocol ZYHomeControllerPresentDelegate <NSObject>

/**
 *  获取到数据通知
 */
- (void)getServerData:(id)data;

@end

@interface ZYHomeControllerPresent : ZYBasePresent

@property (nonatomic, weak) id<ZYHomeControllerPresentDelegate> delegate;

- (void)sendRequest;

@end
