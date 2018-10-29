//
//  PDPropNameCell.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/22.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 房源详情第二组第二个单元格
@interface PDPropNameCell : UITableViewCell

// 房源名称
@property (weak, nonatomic) IBOutlet UILabel *propInfoLabel;

// 查看房号
@property (weak, nonatomic) IBOutlet UIButton *checkHouseNum;
@property (weak, nonatomic) IBOutlet UIView *viewBtn;
@property (weak, nonatomic) IBOutlet UIView *viewImage;

@end
