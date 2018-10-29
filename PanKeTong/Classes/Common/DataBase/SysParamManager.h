//
//  SysParamManager.h
//  APlus
//
//  Created by 李慧娟 on 17/7/20.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseManager.h"

/// 系统配置参数
@interface SysParamManager : BaseManager

- (void)insertSystemParamWithJson:(NSString *)sysParamJson;

- (void)deleteSystemParam;

- (SystemParamEntity *)selectSystemParam;

@end
