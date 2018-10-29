//
//  OpeningPersonCell.h
//  PanKeTong
//
//  Created by zhwang on 16/4/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpeningPersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addOpeningPersonBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftPersonLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *showRemindListCollectionView;


@end
