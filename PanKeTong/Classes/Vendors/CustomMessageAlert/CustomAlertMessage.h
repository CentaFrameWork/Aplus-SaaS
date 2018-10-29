//
//  CustomAlertMessage.h
//  TestAFProject
//
//  Created by 苏军朋 on 15-3-2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertMessage : UIView
//在主window上的提示
+(void)showAlertMessage:(NSString *)alertMessage
        andButtomHeight:(CGFloat)buttomHeight;
//加到当前window上的提示
+(void)showAlertMessage:(NSString *)alertMessage
        andButtomHeight:(CGFloat)buttomHeight
        andCustomWindow:(UIWindow*)window;
@end
