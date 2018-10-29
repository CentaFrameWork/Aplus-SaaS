//
//  NormalCell.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/5.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *starLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLabelConstraint;

@end
