//
//  PhoneListUtil.h
//  PanKeTong
//
//  Created by 李慧娟 on 2018/1/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

// 通讯录
@interface PhoneListUtil : NSObject

// 添加联系人
+ (void)addContacter;

// 删除联系人
+ (void)deletePeople;


+ (BOOL)filterContentForSearchText:(NSString *)searchText andNumber:(NSString *)number;

@end
