//
//  ContactListContactInformationCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJContactListModel.h"

@interface ContactListContactInformationCell : UITableViewCell

@property (nonatomic, strong)UIImageView *lineImage;        // 分割线图片
@property (nonatomic, strong)UILabel *iphoneLabel;          // 手机号
@property (nonatomic, strong)UILabel *landlineLabel;        // 座机号

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)WJContactListModel *model;

@end
