//
//  DecorationTypeCell.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/3/13.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecorationTypeCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *decorationTpyeLabel;

- (void)setLabelValue:(NSString *)decorationTpye;
- (void)selectItme:(NSInteger)itemTag;
- (void)recoverItem;

@end
