//
//  DealDeatailHeadCell.h
//  PanKeTong
//
//  Created by Admin on 2018/3/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DealDeatailHeadCell;
@protocol DealDeatailHeadCellDelegate <NSObject>

- (void)didSelectHeadCell:(DealDeatailHeadCell *)cell;

@end


@interface DealDeatailHeadCell : UITableViewHeaderFooterView
@property (nonatomic,weak) id<DealDeatailHeadCellDelegate>delegate;
@property (nonatomic,strong) UILabel *headName;
@property (nonatomic,strong) UIImageView *lineView;
@property (nonatomic,strong) NSString *typeString;
@property (nonatomic,assign) BOOL headIsOpen;
@property (nonatomic,assign) BOOL headHaveData;
+ (instancetype)loadDealDetailHeadWithTableView:(UITableView*)tableView;

@end
