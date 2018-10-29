//
//  ChannelDetailViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/16.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "ChannelDetailTableViewCell.h"
#import "ChannelDetailEntity.h"
#import "ChannelDetailApi.h"


@interface ChannelDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,
AVAudioPlayerDelegate,NSURLConnectionDataDelegate,AppLifeCycleDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic,copy)NSString *phoneNum;
@property (nonatomic,copy)NSString *keyId;

@end
