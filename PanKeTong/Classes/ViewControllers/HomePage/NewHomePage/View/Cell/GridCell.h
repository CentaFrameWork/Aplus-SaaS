//
//  GridCell.h
//  APlus
//
//  Created by 李慧娟 on 2017/10/19.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPConfigEntity.h"

@interface GridCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

- (void)fillDataWithDataArr:(NSArray *)dataArr andEntity:(APPLocationEntity *)entity;

@end
