//
//  FollowMarkTopApi.h
//  PanKeTong
//
//  Created by 乔书超 on 2017/7/14.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///跟进置顶
@interface FollowMarkTopApi : APlusBaseApi

@property (nonatomic, strong) NSArray *propertyFollowKeyIds;
@property (nonatomic, copy) NSString *propertyKeyId;

@end
