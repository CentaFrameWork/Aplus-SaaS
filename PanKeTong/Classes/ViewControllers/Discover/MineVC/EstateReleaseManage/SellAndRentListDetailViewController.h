//
//  SellAndRentListDetailViewController.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/20.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

@interface SellAndRentListDetailViewController : BaseViewController

@property(nonatomic,strong)NSString *titleString;
@property(nonatomic,strong)NSString *advertKeyid;
@property(nonatomic,strong)NSString *postId;
//是否是售房
@property(nonatomic,assign)BOOL isSaleEst;
@end
