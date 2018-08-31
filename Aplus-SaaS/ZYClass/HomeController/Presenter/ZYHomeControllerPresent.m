//
//  ZYHomeControllerPresent.m
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHomeControllerPresent.h"
#import "ZYHouseRequestApi.h"

#import "ZYHomeMainView.h"

@interface ZYHomeControllerPresent ()

@property (nonatomic, weak) ZYHomeMainView * tableView;

@end

@implementation ZYHomeControllerPresent

- (void)sendRequest{
    
    ZYHouseRequestApi * api = [[ZYHouseRequestApi alloc] init];
    
    [self.manager request:api];
    
}
- (void)setPresentView:(UIView *)view{
    
    _tableView = (ZYHomeMainView *)view;

    _tableView.delegate = self;
    
    self.delegate = self.view;
    
}
#pragma mark - Delegate
- (void)respSuc:(CentaResponse *)resData{
    
    if (resData.code != 200) {
        
        
        
    }else{
        
        [_tableView setViewData:resData.data];
       
        
    }
}

- (void)respFail:(CentaResponse *)error{
    
    NSLog(@"-------->%@", error);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}



@end
