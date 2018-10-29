//
//  SignedRecordApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"

@interface SignedRecordApi : APlusBaseApi

@property (nonatomic, copy)NSString *goOutMsgKeyId;
@property (nonatomic, copy)NSString *scope;
@property (nonatomic, copy)NSString *timeFrom;
@property (nonatomic, copy)NSString *timeTo;
@property (nonatomic, copy)NSString *employeeKeyId;
@property (nonatomic, copy)NSString *employeeDeptKeyId;
@property (nonatomic, copy)NSString *pageIndex;
@property (nonatomic, copy)NSString *pageSize;
@property (nonatomic, copy)NSString *sortField;
@property (nonatomic, copy)NSString *ascending;

@end
