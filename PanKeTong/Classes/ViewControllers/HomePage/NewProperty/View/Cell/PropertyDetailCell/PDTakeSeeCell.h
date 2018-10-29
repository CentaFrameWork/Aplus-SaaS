//
//  PDTakeSeeCell.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/22.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 房源详情房源带看量cell
@interface PDTakeSeeCell : UITableViewCell

// 近七天带看量
@property (weak, nonatomic) IBOutlet UILabel *oneWeekLabel;

// 累计带看量
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;



@end
