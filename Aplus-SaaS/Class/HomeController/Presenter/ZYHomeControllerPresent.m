//
//  ZYShareVM.h
//  PanKeTong
//
//  Created by Admin on 2018/9/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "ZYHomeControllerPresent.h"
#import "ZYUniversalApi.h"
#import "HudViewUtil.h"
#import <YRequestManager/BaseServiceManager.h>



@interface ZYHomeControllerPresent ()
@property (nonatomic,strong) HudViewUtil *hud;

@end

@implementation ZYHomeControllerPresent

+ (void)request_loginWithArgument:(NSDictionary*)dict withSucess:(void(^)(ZYHomeControllerPresent * shareVM))block{
    
    __block ZYHomeControllerPresent *vmodel = [[ZYHomeControllerPresent alloc] init];
    
    vmodel.hud = [[HudViewUtil alloc] init];
    [vmodel.hud showLoadingView:@""];
    
    
    ZYUniversalApi *api = [ZYUniversalApi new];
    api.argument_dict = dict;
    api.pathType = path_login;
    NSLog(@"请求地址:%@\n请求参数:%@",api.getReqUrl,api.getBody);
    
    BaseServiceManager* manager = [BaseServiceManager initManager];
    [manager sendRequest:api sucBlock:^(NSDictionary* result) {
        
        [vmodel.hud hiddenLoadingView];
    
        
        NSLog(@"%@",result);
        
    } failBlock:^(NSError *error) {
        
        [vmodel.hud hiddenLoadingView];
        NSLog(@"%@",error);
        
    }];
    
}



@end
