//
//  ZYUniversalApi.m
//  PanKeTong
//
//  Created by Admin on 2018/9/12.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "ZYUniversalApi.h"

@implementation ZYUniversalApi

- (NSDictionary *)getBody {
    
   
    return self.argument_dict;
}

- (NSString *)getPath {
    
    NSString *path_string;
    
    switch (self.pathType) {
            
        case path_login:
            
            path_string = @"Permission/login";
          
            break;
       
      
            
        default:
            break;
    }
    
    
    return path_string;
}



@end
