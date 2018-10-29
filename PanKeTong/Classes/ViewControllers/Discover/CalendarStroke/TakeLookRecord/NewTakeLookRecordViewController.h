//
//  NewTakeLookRecordViewController.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomerEntity.h"

@protocol AddTakeSeeDelegate <NSObject>

/**
 *  新增带看成功
 */
- (void)addTakeSeeSuccess;

@end

@interface NewTakeLookRecordViewController : BaseViewController

@property (nonatomic,assign)id <AddTakeSeeDelegate>delegate;


@property (nonatomic,copy) NSString *nextStepContent;           // 下一步计划
//@property (nonatomic, strong) CustomerEntity *customerEntity;   // 从更多跟进带过来的客户实体

@property (nonatomic, assign) BOOL isFromHomePage;// 是否从首页快捷入口进入

@end
