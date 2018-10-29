//
//  AutoCompleteTipViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/24.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchViewController.h"
#import <iflyMSC/iflyMSC.h>
#import "DataBaseOperation.h"
#import "AllRoundVC.h"
#import "IFlyUtil.h"
#import "UserAndPublicAccountEntity.h"
#import "UserAndPublicAccountApi.h"


@protocol AutoCompleteChiefOrPublicAccountDelegate <NSObject>

- (void)autoCompleteWithEntity:(RemindPersonDetailEntity *)entity;

@end

@interface AutoCompleteTipViewController : BaseViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,IFlyUtilDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *clearSearchHisBtn;

@property (nonatomic,assign) TopSearchTypeEnum searchType;  //搜索类型：语音、文字
@property (nonatomic,assign) BOOL isFromMainPage;   //是否从首页进入
@property (nonatomic,assign) id <AutoCompleteChiefOrPublicAccountDelegate>delegate;

@end
