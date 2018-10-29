//
//  NewTakeLookThirdCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTakeLookThirdCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *remindTextView;
@property (weak, nonatomic) IBOutlet UIButton *voiceInputBtn;
@property (weak, nonatomic) IBOutlet UILabel *mandatoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;


+ (NewTakeLookThirdCell *)cellWithTableView:(UITableView *)tableView;

@end
