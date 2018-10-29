//
//  WJDealProgressController.h
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/22.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

#import "ZYCodeName.h"

@protocol WJDealProgressDelegate <NSObject>

- (void)selectProgressSuccss:(ZYCodeName *)progress;

@end

@interface WJDealProgressController : BaseViewController

@property (nonatomic , assign)id<WJDealProgressDelegate>delegate;

@end
