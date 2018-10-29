//
//  MultiSelectCell.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/20.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultiSelectCellDelegate <NSObject>

- (void)clickSwithAction:(UISwitch *)Switch;

@end


@interface MultiSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (assign, nonatomic) id<MultiSelectCellDelegate>delegate;

@end
