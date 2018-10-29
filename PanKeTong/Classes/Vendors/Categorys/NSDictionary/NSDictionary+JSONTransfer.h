//
//  NSDictionary+JSONTransfer.h
//  PanKeTong
//
//  Created by 苏军朋 on 16/4/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONTransfer)

/// 字典转换为JSON串
- (NSString *)JSONString;

@end
