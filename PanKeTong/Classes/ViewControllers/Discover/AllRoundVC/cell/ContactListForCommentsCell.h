//
//  ContactListForCommentsCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJContactListModel.h"

@interface ContactListForCommentsCell : UITableViewCell

@property (nonatomic, strong)UIImageView *jiantouImage;     // 箭头图片
@property (nonatomic, strong)UILabel *chakanLabel;          // 箭头文案

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)WJContactListModel *model;

@end
