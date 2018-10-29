//
//  TakingSeeCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/7.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubTakingSeeEntity.h"

@interface TakingSeeCell : UITableViewCell

@property (nonatomic, strong)SubTakingSeeEntity *subTakingSeeEntity;
@property (nonatomic, strong)UILabel *customerLabel;    // 约看客户
@property (nonatomic, strong)UILabel *timeLabel;        // 约看时间

@end
