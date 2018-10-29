//
//  JMSelectPropertyCell.h
//  PanKeTong
//
//  Created by 陈行 on 2018/5/21.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PropertysModelEntty.h"
#import "PropPageDetailEntity.h"

@interface JMSelectPropertyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;

@property (weak, nonatomic) IBOutlet UIView *saleRentConView;


@property (weak, nonatomic) IBOutlet UIView *saleConView;

@property (weak, nonatomic) IBOutlet UIView *rentConView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleConViewWidthCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rentConViewWidthCon;



@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *rentPriceLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) PropertysModelEntty * entity;

@property (nonatomic, strong) PropPageDetailEntity * detailEntity;

@end
