//
//  IFlyUtil.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/24.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iflyMSC/iflyMSC.h>
#import <AVFoundation/AVFoundation.h>


@protocol IFlyUtilDelegate <NSObject>

- (void)ifFlyRecognizedResult:(NSString *)result;

@end

@interface IFlyUtil : NSObject<IFlyRecognizerViewDelegate>

@property (nonatomic,assign)id <IFlyUtilDelegate>delegate;


+ (IFlyUtil *)initWithDelegate:(id<IFlyUtilDelegate>)delegate;
- (void)showAtPoint:(CGPoint)point;
- (void)cancel;

@end
