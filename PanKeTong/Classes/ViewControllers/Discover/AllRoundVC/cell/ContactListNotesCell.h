//
//  ContactListNotesCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJContactListModel.h"

@interface ContactListNotesCell : UITableViewCell

@property (nonatomic, strong)UILabel *beizhulabel;      // 备注
@property (nonatomic, strong)UILabel *notesLabel;       // 备注内容

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)WJContactListModel *model;

@end
