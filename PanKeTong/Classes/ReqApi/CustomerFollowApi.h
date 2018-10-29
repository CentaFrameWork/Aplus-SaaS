//
//  CustomerFollowApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
/// 客户跟进
@interface CustomerFollowApi : APlusBaseApi
@property (nonatomic,copy)NSString *inquiryKeyId;//客户KeyId
@property (nonatomic,copy)NSString *followTypeKeyId;//跟进类型
@property (nonatomic,copy)NSString *pageIndex;//当前页码
@property (nonatomic,copy)NSString *pageSize;//页容量
@property (nonatomic,copy)NSString *sortField;//排序字段名称
@property (nonatomic,copy)NSString *ascending;//排序方向


@end
