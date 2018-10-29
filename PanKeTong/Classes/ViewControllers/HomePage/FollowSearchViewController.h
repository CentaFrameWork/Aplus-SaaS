//
//  FollowSearchViewController.h
//  PanKeTong
//
//  Created by zhwang on 16/4/25.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
@protocol FollowSearchDelegate <NSObject>

-(void)searchResultWithItem:(RemindPersonDetailEntity *)remindItem ;

@end

@interface FollowSearchViewController : BaseViewController

@property (nonatomic, assign) TopSearchTypeEnum searchType;              // 搜索类型：语音、文字
@property (nonatomic, strong) NSMutableArray *selectedSalesmanPerson;    // 已经搜索过的记录
@property (nonatomic, strong) NSString *followDeptKeyId;
@property (nonatomic, assign) BOOL isKeyword;                            // 选择的是否是关键字
@property (nonatomic, weak) id <FollowSearchDelegate> delegate;

@end
