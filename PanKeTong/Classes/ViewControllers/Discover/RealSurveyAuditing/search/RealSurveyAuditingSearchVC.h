//
//  RealSurveyAuditingVC.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

@protocol RealSurveySearchDelegate <NSObject>

- (void)realSurveySearchWithKey:(NSString *)key andValue:(NSString *)value andSearchType:(NSInteger)searchType;

@end

@interface RealSurveyAuditingSearchVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (assign, nonatomic)NSInteger searchType;
@property (assign, nonatomic)NSInteger searchBuildingType;

@property (nonatomic, copy)NSString *estateBuildingName;//搜索栋座单元传递的楼盘名称

@property (nonatomic,copy)NSString *searchKeyWordsStr;//搜索关键字

//是否不显示历史记录，因为在原来基础上新增，为避免影响其他界面
@property (nonatomic, assign) BOOL isNoShowHistoryRecord;

@property (assign, nonatomic)id <RealSurveySearchDelegate>delegate;

@end
