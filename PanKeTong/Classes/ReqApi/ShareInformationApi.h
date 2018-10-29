//
//  ShareInformationApi.h
//  PanKeTong
//
//  Created by 乔书超 on 2017/8/10.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

@interface ShareInformationApi : APlusBaseApi

@property (nonatomic, copy) NSString *articleId;            // 文章资讯ID
@property (nonatomic, copy) NSString *employeeKeyId;        // 人员ID
@property (nonatomic, copy) NSString *employeeNo;           // 人员编号
@property (nonatomic, copy) NSString *employeeName;         // 人员名称
@property (nonatomic, copy) NSString *employeeDeptKeyId;    // 部门ID
@property (nonatomic, copy) NSString *employeeDeptName;     // 部门名称

@end
