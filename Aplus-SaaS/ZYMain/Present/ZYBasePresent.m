//
//  ZYBasePresent.m
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYBasePresent.h"

@implementation ZYBasePresent

- (instancetype)initWithView:(id)view{
    
    if (self = [super init]) {
        
        _view = view;
        
    }
    
    return self;
    
}

#pragma mark - get，懒加载方式
- (RequestManager *)manager{
    
    if (_manager == nil) {
        
        _manager = [RequestManager defaultManager:self];
    }
    
    return _manager;
    
}

#pragma mark - ResponseDelegate
- (void)respSuc:(CentaResponse *)resData{
    
    
}

- (void)respFail:(CentaResponse *)error{
    
    
    
}


@end
