//
//  NewContactTypeCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewContactModel.h"

@interface NewContactTypeCell : UITableViewCell

@property (nonatomic, strong)UILabel *typeLabel;    // 类型label
@property (nonatomic, strong)UILabel *typeLabelResults;  // 类型结果

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)NewContactModel *model;

@property (nonatomic, strong)NSArray *typeArray;
@property (nonatomic, strong)NSArray *appellationArray;
@property (nonatomic, strong)NSArray *marriageArray;

@end

