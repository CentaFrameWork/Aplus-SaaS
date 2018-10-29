//
//  AddCustomerSelectionTableViewCell.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCustomerSelectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelForKey;
@property (weak, nonatomic) IBOutlet UILabel *labelForValue;

- (void)setupLeftTitleWithString:(NSString *)title;
@end