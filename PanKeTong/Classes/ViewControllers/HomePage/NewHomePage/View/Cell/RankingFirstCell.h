//
//  TopFirstCell.h
//  APlus
//
//  Created by 李慧娟 on 2017/10/15.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectBtnView.h"
#import "MyPerformanceEntity.h"

/// 业绩排行榜第一行
@interface RankingFirstCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *employeeImg;

@property (nonatomic, assign) float topPerformance;// 第一名业绩
@property (nonatomic, strong) PerformanceItemEntity *myPerformance;


@end
