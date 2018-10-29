//
//  NewReminRecordViewController.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/30.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

@protocol AddAlertDelegate <NSObject>

/**
 *  新增提醒成功
 */
- (void)addAlertSuccess;

@end

@interface NewReminRecordViewController : BaseViewController

@property (nonatomic,assign)id <AddAlertDelegate>delegate;

@end
