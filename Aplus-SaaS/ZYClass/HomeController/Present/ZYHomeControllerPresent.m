//
//  ZYHomeControllerPresent.m
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHomeControllerPresent.h"
#import "ZYHouseRequestApi.h"

@implementation ZYHomeControllerPresent

- (void)sendRequest{
    
    ZYHouseRequestApi * api = [[ZYHouseRequestApi alloc] init];
    
    [self.manager request:api];
    
}

- (void)didSelectItemWithIndexPath:(NSIndexPath *)indexPath{
    
    //发起请求，
    
}

#pragma mark - Delegate
- (void)respSuc:(CentaResponse *)resData{
    
    if (resData.code != 200) {
        
        
        
    }else{
        
        NSDictionary * dict = resData.data;
        
        ZYHousePageFunc * pageFunc = [ZYHousePageFunc yy_modelWithJSON:dict];
        
        if ([self.view respondsToSelector:@selector(getServerData:)]) {
            
            [self.view getServerData:pageFunc];
            
        }
        
    }
}

- (void)respFail:(CentaResponse *)error{
    
    NSLog(@"-------->%@", error);
    
    
}

@end
