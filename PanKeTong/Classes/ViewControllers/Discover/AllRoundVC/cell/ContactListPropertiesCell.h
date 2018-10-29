//
//  ContactListPropertiesCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJContactListModel.h"

@interface ContactListPropertiesCell : UITableViewCell

@property (nonatomic, strong)UIImageView *yuanImage;    // 圆点图片
@property (nonatomic, strong)UILabel *nameLabel;        // 名字label
@property (nonatomic, strong)UIButton *deleteButton;    // 删除button
@property (nonatomic, strong)UIButton *editorButton;    // 编辑button
@property (nonatomic, strong)UILabel *attributeLabel;   // 属性label

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)WJContactListModel *model;

@property (nonatomic, copy) void(^deleteClickEvent)(NSIndexPath *indexPath);     // 删除
@property (nonatomic, copy) void(^editClickEvent)(NSIndexPath *indexPath);       // 编辑


@end
