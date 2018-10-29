//
//  SelectPropertyVC.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/8.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

/// 选择房源
@interface SelectPropertyVC : BaseViewController

@property (nonatomic, copy) NSString *searchText; // 搜索关键字
@property (nonatomic, copy) NSString *extendAttr; // 搜索类型（行政区／楼盘／栋座／单元）
@property (nonatomic, copy) NSString *itemvalue;

@end
