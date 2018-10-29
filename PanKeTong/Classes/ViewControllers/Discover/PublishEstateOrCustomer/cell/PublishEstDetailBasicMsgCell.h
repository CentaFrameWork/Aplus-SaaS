//
//  PublishEstDetailBasicMsgCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublishCusDetailPageMsgEntity;

@interface PublishEstDetailBasicMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightValueLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSArray *publishCusTitleArray;
@property (nonatomic, strong) PublishCusDetailPageMsgEntity *publishCusDetailPageMsgEntity;

@end
