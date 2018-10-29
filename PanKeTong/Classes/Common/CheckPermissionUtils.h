//
//  CheckPermissionUtils.h
//  PanKeTong
//
//  Created by 乔书超 on 2017/11/1.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"

@interface CheckPermissionUtils : NSObject<ResponseDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) RequestManager *manager;

+ (CheckPermissionUtils *)sharedCheckPermissionUtils;

- (void)checkUserPermission;

@end
