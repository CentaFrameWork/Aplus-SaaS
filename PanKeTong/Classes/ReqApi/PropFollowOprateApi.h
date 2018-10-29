//
//  PropFollowOprateApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
#define ConfirmPropFollow 1//确认跟进
#define DeletePropFollow 2//删除跟进

///确认跟进／删除跟进
@interface PropFollowOprateApi : APlusBaseApi

@property (nonatomic,assign)NSInteger PropFollowOprateType;
@property (nonatomic,copy)NSString *keyids;
@property (nonatomic,copy)NSString *PropertyKeyId;

@end
