//
//  CheckPermissionAlertDelegate.m
//  PanKeTong
//
//  Created by 燕文强 on 15/12/17.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CheckPermissionAlertDelegate.h"

@implementation CheckPermissionAlertDelegate


static CheckPermissionAlertDelegate *checkPermissionAlertDelegate;

+ (CheckPermissionAlertDelegate *)initWithController:(UIViewController *)viewController
{
    @synchronized (self) {
        
        if (checkPermissionAlertDelegate == nil) {
            
            checkPermissionAlertDelegate = [[self alloc] init];
        }
    }
    checkPermissionAlertDelegate.viewController = viewController;
    return checkPermissionAlertDelegate;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [_viewController.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
    
}

@end
