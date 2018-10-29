//
//  SearchPropApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//


#import "APlusBaseApi.h"
#import "SearchPropEntity.h"

///搜索通盘房源职能提示

@interface SearchPropApi : APlusBaseApi
/*
 Name - 表示城区/片区/楼盘名的楼盘名 的字符串 (String)
 EstateSelectType - 查询范围枚举 (EstateSelectTypeEnum)
 TopCount - 返回的记录的Top数 (Int32)
 BuildName - 模糊栋座名称 (String)
 KeyId - KeyId (Nullable`1)
 IsMobileRequest - 是否是手机端请求 (Boolean)
 */

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *topCount;

@property (nonatomic,copy)NSString *estateSelectType;
@property (nonatomic,copy)NSString *buildName;



@end
