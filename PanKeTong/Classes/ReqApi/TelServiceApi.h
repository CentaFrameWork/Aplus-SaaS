//
//  TelServiceApi.h
//  PanKeTong
//
//  Created by 中原管家 on 2016/11/28.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseApi.h"

@interface TelServiceApi : BaseApi
@property (nonatomic, copy)NSString *staffNo;// 用户工号
@property (nonatomic, copy)NSString *tel1;// 主叫号码
@property (nonatomic, copy)NSString *tel2; // 被叫号码

@end