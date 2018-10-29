//
//  GetPersonalApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"

///获取员工个人信息
@interface GetPersonalApi : APlusBaseApi
@property (nonatomic,copy)NSString *staffNo;
@property (nonatomic,copy)NSString *cityCode;
@end
