//
//  TheEditorCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheEditorCell : UITableViewCell

@property (nonatomic, strong)UIButton *editorBtn;       // 编辑
@property (nonatomic, strong)UIButton *deleateBtn;      // 删除
@property (nonatomic, strong)NSIndexPath *indexPath;    // 
@property (nonatomic, copy) void(^indexPathSectionEditorBtn)(NSInteger integer);   // 编辑回调
@property (nonatomic, copy) void(^indexPathSectionDeleateBtn)(NSInteger integer);   // 编辑回调
@end
