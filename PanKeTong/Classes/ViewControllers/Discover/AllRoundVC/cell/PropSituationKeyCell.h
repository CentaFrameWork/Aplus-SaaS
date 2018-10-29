//
//  PropSituationKeyCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/15.
//  Copyright © 2018年 中原集团. All rights reserved.
//
// 钥匙情况
#import <UIKit/UIKit.h>
#import "PropKeyModel.h"

@interface PropSituationKeyCell : UITableViewCell

@property (nonatomic, strong)UILabel *labelName;
@property (nonatomic, strong)UILabel *labelResults;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)PropKeyModel *model;

@end
