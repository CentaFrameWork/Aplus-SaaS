//
//  NewPropertyCell.h
//  APlus
//
//  Created by 李慧娟 on 2017/10/15.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMarqueeView.h"

/// 新增房源
@interface NewPropertyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgConView;

@property (weak, nonatomic) IBOutlet LMarqueeView *marqueeView;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;



@property (nonatomic, copy) NSArray *dataArr;

@end
