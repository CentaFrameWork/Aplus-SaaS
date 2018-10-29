//
//  JMMoreFollowListCell.m
//  PanKeTong
//
//  Created by 陈行 on 2018/6/12.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMMoreFollowListCell.h"

#import "NSString+StringSize.h"

@interface JMMoreFollowListCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followCntLabelRightCon;


@end

@implementation JMMoreFollowListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setEntity:(PropFollowRecordDetailEntity *)entity{
    _entity = entity;
    
    // 权限判断
    BOOL isCanAdd = [AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_TOP_ALL];
    
    if (isCanAdd) {
        
        self.buttonPlacedTop.hidden = NO;
        
        self.followCntLabelRightCon.constant = 50;
        
    }else{
        
        self.buttonPlacedTop.hidden = YES;
        
        self.followCntLabelRightCon.constant = 12;
        
    }
    
    
    
    self.labelFollowUp.text = entity.followContent;
    self.labelName.text = entity.follower;
    self.labelFang.text = entity.followType;
    self.labelTime.text = [NSString formattingYMdHmHTimeStr:entity.followTime];
    
    if (entity.topFlag) {
        // 已经置顶
        [self.buttonPlacedTop setImage:[UIImage imageNamed:@"置顶-1"] forState:UIControlStateNormal];
        
        self.greenImageView.image = [UIImage imageNamed:@"icon_jm_follow_orange"];
        
        self.greenView.backgroundColor =  YCThemeColorOrange;
        
    } else {
        
        [self.buttonPlacedTop setImage:[UIImage imageNamed:@"取消置顶"] forState:UIControlStateNormal];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yyyy-MM-dd HH:mm";
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDate *date = [formater dateFromString:self.labelTime.text];
        
        if ([cal isDateInToday:date]) {
            
            self.greenImageView.image = [UIImage imageNamed:@"icon_jm_follow_green"];
            self.greenView.backgroundColor = YCThemeColorGreen;
            
        }else{
            
            self.greenImageView.image = [UIImage imageNamed:@"icon_jm_follow_light_gray"];
            self.greenView.backgroundColor = YCHeaderViewBGColor;
        }
        
    }
    
}

- (void)setCustomerEntity:(CustomerFollowItemEntity *)customerEntity{
    
    _customerEntity = customerEntity;
    
    //隐藏置顶按钮
    self.buttonPlacedTop.hidden = YES;
    
    self.followCntLabelRightCon.constant = 12;
    
    
    
    self.labelFollowUp.text = customerEntity.followContent;
    self.labelName.text = customerEntity.followPerson;
    self.labelFang.text = customerEntity.followType;
    self.labelTime.text = [NSString formattingYMdHmHTimeStr:customerEntity.followDate];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm";
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *date = [formater dateFromString:self.labelTime.text];
    
    if ([cal isDateInToday:date]) {
        
        self.greenImageView.image = [UIImage imageNamed:@"icon_jm_follow_green"];
        self.greenView.backgroundColor = YCThemeColorGreen;
        
    }else{
        
        self.greenImageView.image = [UIImage imageNamed:@"icon_jm_follow_light_gray"];
        self.greenView.backgroundColor = YCHeaderViewBGColor;
    }
    
}

+ (CGFloat)getHeight:(NSString*)string {
    
    // 权限判断
    BOOL isCanAdd = [AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_TOP_ALL];
    
    CGFloat width = 0;
    
    if (isCanAdd) {
        
        width = APP_SCREEN_WIDTH - 26 - 50;
        
    }else {
        
        width = APP_SCREEN_WIDTH - 26 - 12;
        
    }
    
    return [string heightWithLabelFont:[UIFont systemFontOfSize:14 weight:UIFontWeightLight] withLabelWidth:width];
    
}



@end
