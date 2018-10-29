//
//  PersonalInfoViewController.h
//  PanKeTong
//
//  Created by zhwang on 16/3/30.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

@protocol PersonalInfoDelegate <NSObject>

- (void)requestPersonalInfo;

@end

@interface PersonalInfoViewController : BaseViewController

@property (nonatomic, assign) id<PersonalInfoDelegate> delegate;


@end
