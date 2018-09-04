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

@end
