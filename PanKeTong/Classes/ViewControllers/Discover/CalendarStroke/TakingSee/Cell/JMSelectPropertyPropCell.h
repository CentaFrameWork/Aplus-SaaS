//
//  JMSelectPropertyPropCell.h
//  PanKeTong
//
//  Created by 陈行 on 2018/5/21.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSelectPropertyPropCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unitLabelRightCon;


@end
