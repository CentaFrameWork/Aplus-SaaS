
//
//  ServiceHelper.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ServiceHelper.h"


@implementation ServiceHelper

+ (id)checkAuthorityWith:(id)responseData {
    
    //考虑到空数据问题
    if (responseData == nil) {
        
        return nil;
        
    }
    
    Error *error = nil;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (![responseData isKindOfClass:[NSDictionary class]]) {
        dic = [NSJSONSerialization JSONObjectWithData:responseData
                                              options:NSJSONReadingAllowFragments
                                                error:&error];
    }else{
        
        dic = responseData;
    }
    
    
    NSArray *dicKeys = [[NSArray alloc]initWithArray:[dic allKeys]];
    
//    //这里特殊处理房源列表，因为房源列表里有权限更新，而权限更新不跟随flag值有任何关系
//    if ([dic isKindOfClass:[PropListEntity class]]) {
//        PropListEntity *propListEntity = [MTLJSONAdapter modelOfClass:[PropListEntity class]
//                                                       fromJSONDictionary:dic
//                                                                    error:nil];
//        
//        return propListEntity;
//    }
    
    for (NSString *keyStr in dicKeys) {
        
        if ([keyStr isEqualToString:@"RCode"]) {
            
            BaseEntity *baseEntity = [MTLJSONAdapter modelOfClass:[BaseEntity class]
                                               fromJSONDictionary:dic
                                                            error:nil];
            if (baseEntity.rCode == 200) {
                
                return baseEntity;
                
            } else {
                
                error = [[Error alloc] init];
                
                [error setStatus:ERROR];
                [error setRCode:baseEntity.rCode];
                
                // Handle exeception
                
                switch (baseEntity.rCode) {
                        
                    case 201:
                        error.rDescription = baseEntity.rMessage != nil ? baseEntity.rMessage : @"相同资源已被创建";
                        break;
                        
                    default:
                        
                        error.rDescription = baseEntity.rMessage;
                        
                        break;
                }
            }
            
        }else if ([keyStr isEqualToString:@"Flag"]){
            
            AgencyBaseEntity *agencyBaseEntity = [MTLJSONAdapter modelOfClass:[AgencyBaseEntity class]
                                                           fromJSONDictionary:dic
                                                                        error:nil];

            //判断实体是否包含房源列表实体成员
            if ([[dic allKeys] containsObject:@"PropertysModel"] && [[dic allKeys] containsObject:@"PermisstionsModel"]) {
                
                //这里特殊处理房源列表，因为房源列表里有权限更新，而权限更新不跟随flag值有任何关系
                PropListEntity *propListEntity = [MTLJSONAdapter modelOfClass:[PropListEntity class]
                                                           fromJSONDictionary:dic
                                                                        error:nil];
                
                return propListEntity;
                
            }
            
            if (agencyBaseEntity.flag) {
                
                return agencyBaseEntity;
            }else {
                
                error = [[Error alloc] init];
                
                [error setStatus:ERROR];
                [error setRDescription:agencyBaseEntity.errorMsg];
                
            }
            
        }
    }
    return error;
    
}

+ (id)checkHKData:(NSDictionary *)dic
{
    Error *error = nil;
    
    BaseEntity *baseEntity = [MTLJSONAdapter modelOfClass:[BaseEntity class]
                                       fromJSONDictionary:dic
                                                    error:nil];
    if (baseEntity.rCode == 200) {
        
        return baseEntity;
        
    } else {
        
        error = [[Error alloc] init];
        
        [error setStatus:ERROR];
        [error setRCode:baseEntity.rCode];
        
        // Handle exeception
        
        switch (baseEntity.rCode) {
                
            case 201:
                error.rDescription = baseEntity.rMessage != nil ? baseEntity.rMessage : @"相同资源已被创建";
                break;
                
            default:
                
                error.rDescription = baseEntity.rMessage;
                break;
        }
    }

    return error;

}

+ (id)checkAPlusData:(NSDictionary *)dic
{
    Error *error = nil;

    AgencyBaseEntity *agencyBaseEntity = [MTLJSONAdapter modelOfClass:[AgencyBaseEntity class]
                                                   fromJSONDictionary:dic
                                                                error:nil];
    
    //判断实体是否包含房源列表实体成员
    if ([[dic allKeys] containsObject:@"PropertysModel"]||[[dic allKeys] containsObject:@"PermisstionsModel"]
        ||[[dic allKeys] containsObject:@"Properties"])
    {
        
        //这里特殊处理房源列表，因为房源列表里有权限更新，而权限更新不跟随flag值有任何关系
        PropListEntity *propListEntity = [MTLJSONAdapter modelOfClass:[PropListEntity class]
                                                   fromJSONDictionary:dic
                                                                error:nil];
        return propListEntity;
    }
    
    if (agencyBaseEntity.flag)
    {
        return agencyBaseEntity;
    }
    else
    {
        error = [[Error alloc] init];
        [error setStatus:ERROR];
        [error setRDescription:agencyBaseEntity.errorMsg];
        
        NSString *lowerDescription = [error.rDescription lowercaseString];
        
        if([lowerDescription contains:@"request failed"])
        {
            [error setRDescription:@"请求失败"];
        }
        
    }
    

        return error;
}



@end
