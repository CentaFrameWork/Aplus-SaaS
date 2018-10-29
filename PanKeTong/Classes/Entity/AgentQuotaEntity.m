//
//  AgentQuotaEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/11/6.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgentQuotaEntity.h"

@implementation AgentQuotaEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{

  return  @{
           @"admPermission":@"AdmPermission",
           @"registerTrustsOnOff":@"RegisterTrustsOnOff",
           @"registerTrustAudit":@"RegisterTrustAudit",
           @"packageCount":@"PackageCount",
           @"countIsPropertyAd":@"CountIsPropertyAd",
           @"countPropertyAd":@"CountPropertyAd",
           @"flag":@"Flag",
           @"errorMsg":@"ErrorMsg",
           @"runTime":@"RunTime",
            };
}
@end
