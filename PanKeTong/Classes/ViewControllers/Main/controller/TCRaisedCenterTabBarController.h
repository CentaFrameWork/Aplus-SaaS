//
//  TCRaisedCenterTabBarController.h
//  TCRaisedCenterTabBar_Demo
//
//  Created by TailC on 16/3/18.
//  Copyright © 2016年 TailC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DascomUtil.h"
#import "CityCodeVersion.h"
#import "RequestManager.h"

@interface TCRaisedCenterTabBarController : UITabBarController<ResponseDelegate>
{
    RequestManager *_manager;
}

@end
