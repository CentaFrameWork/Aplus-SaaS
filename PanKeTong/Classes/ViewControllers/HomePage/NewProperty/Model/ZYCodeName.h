//
//  ZYCodeName.h
//  PanKeTong
//
//  Created by 陈行 on 2018/4/10.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYCodeName : NSObject

@property (nonatomic, copy) NSString * code;

@property (nonatomic, copy) NSString * name;

+ (NSMutableArray *)codeNameArrWithFileName:(NSString *)fileName;

@end
