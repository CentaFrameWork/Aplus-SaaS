//
//  AgencyInfoManager.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseManager.h"
#import "DepartmentInfoEntity.h"

/// 员工信息及权限
@interface AgencyInfoManager : BaseManager

- (void)insertAgencyUserInfoWithJson:(NSString *)agencyUserInfo;

- (void)deleteAgencyUserInfo;

- (DepartmentInfoResultEntity *)selectAgencyUserInfo;

@end
