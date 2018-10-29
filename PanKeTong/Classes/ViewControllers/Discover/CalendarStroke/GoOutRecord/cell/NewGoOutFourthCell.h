//
//  NewGoOutFourthCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/24.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGoOutFourthCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UIButton *voiceInputBtn;


+ (NewGoOutFourthCell *)cellWithTableView:(UITableView *)tableView;

@end