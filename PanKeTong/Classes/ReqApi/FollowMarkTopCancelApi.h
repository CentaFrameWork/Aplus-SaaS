//
//  FollowMarkTopCancelApi.h
//  PanKeTong
//
//  Created by 乔书超 on 2017/7/14.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///取消跟进置顶
@interface FollowMarkTopCancelApi : APlusBaseApi

@property (nonatomic, copy) NSString *propertyFollowKeyId;      // 跟进ID
@property (nonatomic, copy) NSString *propertyKeyId;            // 房源ID

@end
