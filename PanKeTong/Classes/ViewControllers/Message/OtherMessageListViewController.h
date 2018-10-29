//
//  OtherMessageListViewController.h
//  PanKeTong
//
//  Created by wanghx17 on 15/9/23.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

@interface OtherMessageListViewController : BaseViewController

@property(nonatomic,strong)NSString * titleString;
/**
 *  2房源、3客源、4成交、5私信
 */
@property(nonatomic,assign)NSInteger messageType;

@end
