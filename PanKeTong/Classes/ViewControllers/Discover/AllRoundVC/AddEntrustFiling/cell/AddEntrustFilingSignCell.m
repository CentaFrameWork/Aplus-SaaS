//
//  AddEntrustFilingSignCell.m
//  PanKeTong
//
//  Created by 张旺 on 2017/7/18.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AddEntrustFilingSignCell.h"





#define RightLabelEdgeConstant   15

static NSString * const cellIdentifier = @"AddEntrustFilingSignCell";

@implementation AddEntrustFilingSignCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setCellValueWithIndexPath:(NSIndexPath *)indexPath
                    andSignatory:(NSString *)signatory
                     andSignType:(NSString *)signType
                     andSignTime:(NSString *)signTime
             andIsEditPermission:(BOOL)isEditPermission
{
    
    self.rightTitleLabelRightCon.constant = 31;
    
    if (indexPath.row == 0)
    {
        self.leftTitleLabel.text = @"签署人";
        self.rightTitleLabel.text = signatory;
        if (isEditPermission)
        {
            self.rightArrowImg.hidden = NO;
        }else
        {
            self.rightArrowImg.hidden = YES;
        }
    }
    else if (indexPath.row == 1)
    {
        self.leftTitleLabel.text = @"签署时间";
        self.rightTitleLabel.text = signTime;
    
        if (isEditPermission)
        {
            self.rightArrowImg.hidden = NO;
        }else
        {
            self.rightArrowImg.hidden = YES;
        }
        
    }
    else
    {
        self.leftTitleLabel.text = @"签署类型";
        self.rightArrowImg.hidden = YES;
        self.rightTitleLabelRightCon.constant = 12;
        
        NSString * signTypeStr;
        
        if ([signType integerValue] == SALE)
        {
            signTypeStr = @"售房委托";
        }
        else if ([signType integerValue] == RENT)
        {
            signTypeStr = @"租房委托";
        }else
        {
            signTypeStr = @"租售委托";
        }
        
        self.rightTitleLabel.text = signTypeStr;
    }
}

@end
