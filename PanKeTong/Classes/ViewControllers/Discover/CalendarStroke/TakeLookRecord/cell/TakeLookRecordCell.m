//
//  TakeLookRecordCell.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "TakeLookRecordCell.h"
#import "SubTakingSeeEntity.h"
#import "WJTaskSeeModel.h"
@implementation TakeLookRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setTakeLookRecordListDetailWithListEntity:(NSArray *)takeLookRecordListEntity andIndexPath:(NSIndexPath *)indexPath andIsHiddenNextStep:(BOOL)isHiddenNextStep{

    WJTaskSeeModel *subTakeSeeEntity = [takeLookRecordListEntity objectAtIndex:indexPath.section];
    
    if ([subTakeSeeEntity.seePropertyType isEqualToString:@"看租"]) {
        
        self.typeImageView.image = [UIImage imageNamed:@"icon_jm_take_look_rent"];
        
    }else if ([subTakeSeeEntity.seePropertyType isEqualToString:@"看售"]){
        
        self.typeImageView.image = [UIImage imageNamed:@"icon_jm_take_look_sale"];
        
    }else{
        
        self.typeImageView.image = [UIImage imageNamed:@"icon_jm_take_look_rent_sale"];
        
    }
    
    self.customerLabel.text = subTakeSeeEntity.customerName ? : @"";
    self.timeLabel.text = [CommonMethod getFormatDateStrFromTime:subTakeSeeEntity.takeSeeTime DateFormat:YearToMinFormat];
    self.lookAtPeopleLabel.text = subTakeSeeEntity.lookWithUserName ? : @"无";
    
    if (subTakeSeeEntity.attachmentPath.length > 0) {
        
        [self.seeLinkBtn setTitle:@"有看房单" forState:UIControlStateNormal];
        [self.seeLinkBtn setTitleColor:YCThemeColorGreen forState:UIControlStateNormal];
        
    }else{
        
        [self.seeLinkBtn setTitle:@"无看房单" forState:UIControlStateNormal];
        [self.seeLinkBtn setTitleColor:YCTextColorGray forState:UIControlStateNormal];
        
    }
}

@end
