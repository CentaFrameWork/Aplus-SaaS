//
//  AllRoundViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/25.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

@interface AllRoundVC : BaseViewController

// 是否是“通盘房源”列表，如果不是，则没有下面的更多筛选
@property (nonatomic, assign) BOOL isPropList;
@property (nonatomic, assign) BOOL isHomePageSearch;
@property (nonatomic, assign) BOOL isFromSearchPage;            // 从搜索页进入到房源列表
@property (nonatomic, copy) NSString *propType;                 // 传的房源类型参数
@property (nonatomic, copy) NSString *estateSelectType;         // 搜索状态
@property (nonatomic, copy) NSString *searchKeyWord;            // (导航栏显示)
@property (nonatomic, copy) NSString *realSearchKeyWord;
@property (nonatomic, copy) NSString *houseNo;                  // 房号

@property (nonatomic, assign) NSInteger selectRow;

@end
