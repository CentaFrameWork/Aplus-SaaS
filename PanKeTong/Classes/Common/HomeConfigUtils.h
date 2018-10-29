//
//  HomeConfigUtils.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/6/30.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"
#import "Error.h"


@protocol HomeConfigDelegate <NSObject>

- (void)requestSuccess;
- (void)requestFeild:(NSString *)errorMsg;

@end

@interface HomeConfigUtils : NSObject<ResponseDelegate,UIAlertViewDelegate>

@property (nonatomic, strong)RequestManager *manager;
@property (strong, nonatomic) Error *error;
@property (assign, nonatomic)id<HomeConfigDelegate>delegate;
@property (assign, nonatomic) BOOL isShowErrorAlert;//有错误提示时是否显示

+ (HomeConfigUtils *)shareHomeConfigUtils;
- (void)getHomeConfig;


@end
