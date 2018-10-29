//
//  NewContactNamePhoneCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewContactNameTextField.h"
#import "NewContactModel.h"
@interface NewContactNamePhoneCell : UITableViewCell

@property (nonatomic, strong)UILabel *nameLabel;            // 姓名label
@property (nonatomic, strong)NewContactNameTextField *nameTextField;    // 姓名TextField

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)NewContactModel *model;
@property (nonatomic, assign)BOOL isEditor;                 // 是编辑  否添加
@property (nonatomic, assign)BOOL editPhoneNumber;          // 是否编辑过手机号

@end
