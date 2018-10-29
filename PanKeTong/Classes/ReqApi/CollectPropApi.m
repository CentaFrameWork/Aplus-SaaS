//
//  CollectPropApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CollectPropApi.h"

@implementation CollectPropApi


- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_propKeyId,
             };
}

- (NSString *)getPath {
    
    if (_isCollect) {
        
        
        return @"property/favorite-property";
        
    }else{
        
        return @"property/cancel-favorite-property";
       
    }
    

  
}


- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}
- (int)getRequestMethod {
    
    return RequestMethodPUT;
}

@end
