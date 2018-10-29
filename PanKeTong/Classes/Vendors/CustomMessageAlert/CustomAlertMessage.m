//
//  CustomAlertMessage.m
//  TestAFProject
//
//  Created by 苏军朋 on 15-3-2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomAlertMessage.h"

#define BoldFontName            @"Helvetica-Bold"

@implementation CustomAlertMessage

-(id)init{
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

+(void)showAlertMessage:(NSString *)alertMessage
        andButtomHeight:(CGFloat)buttomHeight
{
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    
    CustomAlertMessage *customMessageAlert = [[self alloc]init];
    customMessageAlert.backgroundColor = [UIColor blackColor];
    customMessageAlert.alpha = 0;
    customMessageAlert.layer.masksToBounds = YES;
    customMessageAlert.layer.cornerRadius = 5.0;
    customMessageAlert.userInteractionEnabled = NO;
    
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.alpha = 0.5;
    messageLabel.font = [UIFont fontWithName:BoldFontName size:12.0];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.backgroundColor = [UIColor clearColor];
    
    messageLabel.text = alertMessage;
    
    CGFloat messageWidth = [customMessageAlert getStringWidth:[UIFont systemFontOfSize:12.0]
                                Height:15
                                  size:12.0
                             andString:alertMessage];
    
    CGFloat messageHeight = [alertMessage getStringHeight:[UIFont fontWithName:BoldFontName
                                                                          size:12.0]
                                                    width:messageWidth
                                                     size:12.0];
    
    messageLabel.frame = CGRectMake(0, 0, messageWidth+20, messageHeight > 25 ? messageHeight : 25);
    [customMessageAlert setFrame:CGRectMake(window.frame.size.width/2-((messageWidth+20)/2),
                                            window.frame.size.height-50-buttomHeight,
                                            messageWidth+20,
                                            messageHeight > 25 ? messageHeight : 25)];
    
    [customMessageAlert addSubview:messageLabel];

    [window addSubview:customMessageAlert];
    
    __weak typeof(CustomAlertMessage *) weakCustomAlert = customMessageAlert;
    __weak typeof(UILabel *) weakMessageLabel = messageLabel;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         weakCustomAlert.alpha = 0.7;
                         weakMessageLabel.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                         
                         [weakCustomAlert performSelector:@selector(hideAlertMessage)
                                                  withObject:nil
                                                  afterDelay:1.5];
                     }];
    
    
}
+(void)showAlertMessage:(NSString *)alertMessage
        andButtomHeight:(CGFloat)buttomHeight
        andCustomWindow:(UIWindow*)window
{


    CustomAlertMessage *customMessageAlert = [[self alloc]init];
    customMessageAlert.backgroundColor = [UIColor blackColor];
    customMessageAlert.alpha = 0;
    customMessageAlert.layer.masksToBounds = YES;
    customMessageAlert.layer.cornerRadius = 5.0;

    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.alpha = 0.5;
    messageLabel.font = [UIFont fontWithName:BoldFontName size:12.0];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.backgroundColor = [UIColor clearColor];

    messageLabel.text = alertMessage;

    CGFloat messageWidth = [customMessageAlert getStringWidth:[UIFont systemFontOfSize:12.0]
                                                       Height:15
                                                         size:12.0
                                                    andString:alertMessage];

    CGFloat messageHeight = [alertMessage getStringHeight:[UIFont fontWithName:BoldFontName
                                                                          size:12.0]
                                                    width:messageWidth
                                                     size:12.0];

    messageLabel.frame = CGRectMake(0, 0, messageWidth+20, messageHeight > 25 ? messageHeight : 25);
    [customMessageAlert setFrame:CGRectMake(window.frame.size.width/2-((messageWidth+20)/2),
                                            window.frame.size.height-25-buttomHeight,
                                            messageWidth+20,
                                            messageHeight > 25 ? messageHeight : 25)];

    [customMessageAlert addSubview:messageLabel];
    [window addSubview:customMessageAlert];

    __weak typeof(CustomAlertMessage *) weakCustomAlert = customMessageAlert;
    __weak typeof(UILabel *) weakMessageLabel = messageLabel;

    [UIView animateWithDuration:0.5
                     animations:^{

                         weakCustomAlert.alpha = 0.7;
                         weakMessageLabel.alpha = 1.0;

                     } completion:^(BOOL finished) {

                         [weakCustomAlert performSelector:@selector(hideAlertMessage)
                                               withObject:nil
                                               afterDelay:1.5];
                     }];
    
    
}

-(void)hideAlertMessage
{
    
    __weak typeof (self) weakSelf = self;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         weakSelf.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                         if (finished) {
                             
                             [weakSelf removeFromSuperview];
                         }
                     }];
}

-(CGFloat)getStringWidth:(UIFont*)font Height:(CGFloat)height size:(CGFloat)minSize andString:(NSString *)string{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  font, NSFontAttributeName,
                                  nil];
    
    [attributedString addAttributes:attrSyleDict
                              range:NSMakeRange(0, string.length)];
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                         
                                                       context:nil];
    return stringRect.size.width;
}



@end
