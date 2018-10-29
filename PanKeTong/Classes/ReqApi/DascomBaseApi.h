//
//  DascomBaseApi.h
//  PanKeTong
//
//  Created by 中原管家 on 16/8/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseApi.h"

/// 虚拟号网络请求基类
@interface DascomBaseApi : BaseApi

@property (nonatomic, copy)NSString *empNo;


- (BOOL)isAplusPath;


@end
