//
//  UserAndPublicAccountApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/8.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///归属人或公客池智能提示
@interface UserAndPublicAccountApi : APlusBaseApi

@property (nonatomic,copy)NSString *keyWords;
@property (nonatomic,copy)NSString *topCount;

@end
