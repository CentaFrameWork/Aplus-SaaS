//
//  ZYBasePresent.h
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RequestManager.h"

@interface ZYBasePresent : NSObject<YResponseDelegate>

@property (nonatomic, strong) RequestManager * manager;

@property (nonatomic, weak) id view;

/**
 *  初始化要绑定的视图
 */
- (instancetype)initWithView:(id)view;

@end
