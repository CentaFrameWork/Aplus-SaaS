//
//  JMSelectPropertyViewController.h
//  PanKeTong
//
//  Created by 陈行 on 2018/5/21.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

@interface JMSelectPropertyViewController : BaseViewController

@property (nonatomic, copy) NSString *searchText; // 搜索关键字
@property (nonatomic, copy) NSString *extendAttr; // 搜索类型（行政区／楼盘／栋座／单元）
@property (nonatomic, copy) NSString *itemvalue;

@end
