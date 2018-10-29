//
//  AllTakeSeesApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 2018/1/3.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"
#import "TakingSeeEntity.h"

/// 房源下的带看记录
@interface AllTakeSeesApi : APlusBaseApi

@property (nonatomic, copy) NSString *keyId;    // 房源KeyID

@end
