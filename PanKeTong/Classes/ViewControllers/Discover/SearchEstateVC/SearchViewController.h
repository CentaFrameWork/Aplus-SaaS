//
//  SearchViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/24.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

#define From_Calendar       @"fromCalendar"
#define From_TrustAuditing  @"fromTrustAuditing"

@protocol SearchResultDelegate <NSObject>

- (void)searchResultWithKeyword:(NSString *)keyword andExtendAttr:(NSString *)extendAttr andItemValue:(NSString *)itemvalue andHouseNum:(NSString *)houseNum;

@end

@interface SearchViewController : BaseViewController

@property (nonatomic, assign) TopSearchTypeEnum searchType;       // 搜索类型：语音、文字
@property (nonatomic, assign) BOOL isFromMainPage;                // 是否从首页进入
@property (nonatomic, assign) id <SearchResultDelegate> delegate;
@property (nonatomic, copy) NSString *fromModuleStr;              // 从日历/委托审核等其他模块进来的

@end