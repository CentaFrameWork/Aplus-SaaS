//
//  DESUtil.h
//  testdes
//
//  Created by 陈行 on 2018/6/19.
//  Copyright © 2018年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESUtil : NSObject

+ (NSString *)encrypWithText:(NSString *)text andKey:(NSString *)key;

@end
