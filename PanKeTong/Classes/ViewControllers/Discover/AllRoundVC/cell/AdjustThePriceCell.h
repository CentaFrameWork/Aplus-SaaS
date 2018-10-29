//
//  AdjustThePriceCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustThePriceCell : UITableViewCell

@property (nonatomic, strong)UILabel *labelName;
@property (nonatomic, strong)UITextField *textFieldPrice;
@property (nonatomic, strong)UILabel *labelUnit;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, assign)int type;

@end
