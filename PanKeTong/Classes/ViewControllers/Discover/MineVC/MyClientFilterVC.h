//
//  MyClientFilterVC.h
//  PanKeTong
//
//  Created by 乔书超 on 2017/11/3.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

@protocol MyClientFilterDelegate <NSObject>

- (void)finishFilter:(RemindPersonDetailEntity *)personDetailEntity;

@end

@interface MyClientFilterVC : BaseViewController

@property (nonatomic, weak) id <MyClientFilterDelegate> delegate;

@end
