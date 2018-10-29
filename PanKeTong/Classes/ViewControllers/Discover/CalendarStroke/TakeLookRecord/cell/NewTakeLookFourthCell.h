//
//  NewTakeLookFourthCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTakeLookFourthCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addPersonBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *reminPersonCollection;

+ (NewTakeLookFourthCell *)cellWithTableView:(UITableView *)tableView;

@end
