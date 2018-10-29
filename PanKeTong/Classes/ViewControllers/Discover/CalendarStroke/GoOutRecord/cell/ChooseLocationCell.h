//
//  ChooseLocationCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/25.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationEntity.h"

@interface ChooseLocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UILabel *locationDetail;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;

+ (ChooseLocationCell *)cellWithTableView:(UITableView *)tableView;

-(void)setCellValueWithDataArray:(NSArray *)array
                    andIndexPath:(NSIndexPath *)indexPath
               andChooseLocation:(LocationEntity *)chooseLocation;
@end
