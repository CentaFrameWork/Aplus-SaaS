//
//  CustomerInfoTableViewCell.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelForKey;
@property (weak, nonatomic) IBOutlet UILabel *labelForValue;
@property (weak, nonatomic) IBOutlet UILabel *labelKey02;
@property (weak, nonatomic) IBOutlet UILabel *labelValue02;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstViewWidth;
@end
