//
//  ZYUniversalApi.h
//  PanKeTong
//
//  Created by Admin on 2018/9/12.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "ZYAplusApi.h"
typedef NS_ENUM(NSInteger, RequestPath) {
    
    path_login, //登陆
    
    
};
@interface ZYUniversalApi : ZYAplusApi
@property (nonatomic,strong) NSDictionary *argument_dict;
@property (nonatomic,assign) RequestPath pathType;
@end


