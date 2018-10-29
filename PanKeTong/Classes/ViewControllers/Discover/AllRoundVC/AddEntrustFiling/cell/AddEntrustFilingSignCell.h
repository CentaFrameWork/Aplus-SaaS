//
//  AddEntrustFilingSignCell.h
//  PanKeTong
//
//  Created by 张旺 on 2017/7/18.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEntrustFilingSignCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *leftIconLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImg;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightEdgeConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTitleLabelRightCon;


-(void)setCellValueWithIndexPath:(NSIndexPath *)indexPath
                    andSignatory:(NSString *)signatory
                     andSignType:(NSString *)signType
                     andSignTime:(NSString *)signTime
             andIsEditPermission:(BOOL)isEditPermission;

@end
