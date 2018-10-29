//
//  JMTakeLookPropertyDetailCell.h
//  PanKeTong
//
//  Created by 陈行 on 2018/4/27.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WJTaskSeeModel.h"

@interface JMTakeLookPropertyDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;

@property (nonatomic, strong) PropertyList * property;

@end
