//
//  EstateListVC.h
//  APlus
//
//  Created by 张旺 on 2017/10/18.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseViewController.h"
typedef enum : NSUInteger {
    HomePageSearch = 1,     // 首页
    AllRoundSearch,         // 房源列表
    CalendarSearch,         // 日历行程
    TrustAuditingSearch,    // 委托审核
} ModuleSearchType;         // 页面搜索类型


@interface EstateListVC : BaseViewController

@property (nonatomic, assign) ModuleSearchType moduleSearchType;
@property (nonatomic, copy) NSString *searchKeyWord;            // (导航栏显示)
@property (nonatomic, copy) NSString *propType;                 // 传的房源类型参数
@property (nonatomic, assign) NSInteger selectRow;
@property (nonatomic, copy) NSString *realSearchKeyWord;
@property (nonatomic, copy) NSString *estateSelectType;

@property (nonatomic, assign) BOOL isPropList;
@property (nonatomic, assign) BOOL isFromSearchPage;            // 从搜索页进入到房源列表
@property (nonatomic, assign) BOOL isNewProInThreeDay;          // 是否是新上房源

@property (nonatomic, copy) NSString *houseNo;                  // 房号
@property (nonatomic, copy) NSString *propNo;                   // 房源编号



@end
