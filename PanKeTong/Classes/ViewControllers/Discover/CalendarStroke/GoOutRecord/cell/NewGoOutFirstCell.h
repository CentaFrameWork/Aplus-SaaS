//
//  NewGoOutFirstCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/24.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGoOutFirstCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;


+ (NewGoOutFirstCell *)cellWithTableView:(UITableView *)tableView;

@end
