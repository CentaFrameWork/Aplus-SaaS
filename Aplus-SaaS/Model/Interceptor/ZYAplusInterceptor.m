//
//  ZYAplusInterceptor.m
//  Aplus-SaaS
//
//  Created by Admin on 2018/8/31.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYAplusInterceptor.h"

@implementation ZYAplusInterceptor
- (CentaResponse *)convertData:(id)task andRespData:(id)respData andApi:(AbsApi<ApiDelegate> *)api {
                                                        
    NSLog(@"*************拦截器***************");
    CentaResponse *resp = [super convertData:task andRespData:respData andApi:api];
    
    NSDictionary *dict = resp.data;
    
    Class cls = api.getRespClass;
    
    resp.data = [cls yy_modelWithJSON:dict];
    
    return resp;
}
@end
