//
//  PropertyCallRecordResultEntity.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/17.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "PropertyCallRecordResultEntity.h"

@implementation PropertyCallRecordResultEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *dic = [self getBaseFieldWithOthers:@{
                                                         @"owner":@"Owner",
                                                         @"operatorStr":@"Operator",
                                                         @"empID":@"EmpID",
                                                         @"deptID":@"DeptID",
                                                         @"callTime":@"CallTime",
                                                         @"startTime":@"StartTime",
                                                         @"endTime":@"EndTime",
                                                         @"operationDepart":@"OperationDepart",
                                                         @"tape":@"Tape",
                                                         @"recordId":@"RecordId",
                                                         @"relevantFollow":@"RelevantFollow",
                                                         @"propertyKeyId":@"PropertyKeyId",
                                                         @"propertyKeyId":@"PropertyKeyId",
                                                         @"followContent":@"FollowContent",
                                                         @"peroId":@"PeroId",
                                                        }];
    return dic;
}

@end
