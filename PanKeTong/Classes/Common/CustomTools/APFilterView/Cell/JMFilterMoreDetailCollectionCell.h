//
//  JMFilterMoreDetailCollectionCell.h
//  PanKeTong
//
//  Created by 陈行 on 2018/5/10.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMFilterMoreDetailCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

- (void)setIsSelect:(BOOL)isSelect;

@end
