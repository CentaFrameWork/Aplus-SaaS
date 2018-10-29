//
//  ApplyTransferPubEstRemindPersonCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedContactsArraryBlock)(NSArray *contacts);

@interface ApplyTransferPubEstRemindPersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remindPersonVerSepLineWidth;
@property (weak, nonatomic) IBOutlet UIButton *addRemindPersonBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *showRemindListCollectionView;

- (void)setupCellWithViewController:(UIViewController *)vc tableView:(UITableView *)tableView;

- (void)passingSelectedContactsArrBlock:(selectedContactsArraryBlock)block;

@end
