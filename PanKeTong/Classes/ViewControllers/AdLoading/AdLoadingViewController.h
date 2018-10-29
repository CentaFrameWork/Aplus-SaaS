//
//  AdLoadingViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "AgencySysParamUtil.h"

@protocol AdLoadingDelegate <NSObject>

-(void)getSysParamSuccessed;

@end

@interface AdLoadingViewController : BaseViewController

@property (nonatomic,assign) id <AdLoadingDelegate> delegate;

@end
