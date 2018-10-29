//
//  ChannelCallFilterViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/18.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "RemindPersonDetailEntity.h"
#import "ChannelDetailTableViewCell.h"
#import "ChannelCallTimeTableViewCell.h"
#import "ChannelStaffFilterTableViewCell.h"
#import "ChannelFilterTableViewCell.h"
#import "DateTimePickerDialog.h"
#import "SearchRemindPersonViewController.h"
#import "ChannelFilterEntity.h"

@protocol ChannelFilterDelegate <NSObject>

/**
 * 筛选结果
 */
- (void)channelFilterResult:(ChannelFilterEntity *)result;

@end

@interface ChannelCallFilterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,
DatePickDelegate,DateTimeSelected,TextFeildPressedDelegate,SearchRemindPersonDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *confirmView;

@property (nonatomic,strong)NSDictionary *dataDic;

@property (nonatomic,assign)BOOL isShowStaff;

@property (nonatomic,assign)id <ChannelFilterDelegate>delegate;
//@property (nonatomic,strong)ChannelFilterEntity *channelFilterEntity;//筛选结果

@end
