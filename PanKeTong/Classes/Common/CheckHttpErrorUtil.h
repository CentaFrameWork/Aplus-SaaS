//
//  CheckHttpErrorUtil.h
//  PanKeTong
//
//  Created by 王雅琦 on 2018/1/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Error;

/// 检查网络请求返回error
@interface CheckHttpErrorUtil : NSObject

+ (NSString *)handleError:(Error *)error;

@end
