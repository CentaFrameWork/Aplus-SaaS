//
//  CheckVersonUtils.h
//  PanKeTong
//
//  Created by 中原管家 on 2016/10/9.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"
#import "Error.h"

@protocol CheckVersonDelegate <NSObject>

- (void)requestSuccess;
- (void)requestFeild:(NSString *)errorMsg;

@end


@interface CheckVersonUtils : NSObject<ResponseDelegate,UIAlertViewDelegate>

@property (nonatomic, strong)RequestManager *manager;
@property (strong, nonatomic) Error *error;
@property (assign, nonatomic)id<CheckVersonDelegate>delegate;
@property (assign, nonatomic) BOOL isShowErrorAlert;//有错误提示时是否显示

+ (CheckVersonUtils *)shareCheckVersonUtils;
- (void)checkAppVerson;

@end
