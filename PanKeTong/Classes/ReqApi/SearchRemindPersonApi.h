//
//  SearchRemindPersonApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"

///搜索提醒人或部门
@interface SearchRemindPersonApi : APlusBaseApi
@property (nonatomic,copy)NSString *autoCompleteType;
@property (nonatomic,copy)NSString *keyWords;
@property (nonatomic,assign)BOOL exceptMe;
@property (nonatomic,copy)NSString *departmentKeyId;

@end
