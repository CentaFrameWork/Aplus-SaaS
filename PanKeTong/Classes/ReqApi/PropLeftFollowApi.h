//
//  PropLeftFollowApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
/// 跟进列表
@interface PropLeftFollowApi : APlusBaseApi

@property (nonatomic, copy)NSString *followTypeKeyId;
@property (nonatomic, copy)NSString *propertyKeyId;
@property (nonatomic, copy)NSString *followTimeFrom;

@property (nonatomic, copy)NSString *followTimeTo;
@property (nonatomic, copy)NSString *keyword;
@property (nonatomic, copy)NSString *followPersonKeyId;
@property (nonatomic, copy)NSString *followDeptKeyId;
@property (nonatomic, copy)NSString *pageIndex;
@property (nonatomic, copy)NSString *pageSize;
@property (nonatomic, copy)NSString *sortField;

@end
