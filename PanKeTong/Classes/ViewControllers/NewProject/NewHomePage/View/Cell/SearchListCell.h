//
//  SearchListCell.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/7.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPropEntity.h"

/// 搜索历史记录cell
@interface SearchListCell : UITableViewCell

@property (nonatomic, strong) SearchPropDetailEntity *entity;

@end
