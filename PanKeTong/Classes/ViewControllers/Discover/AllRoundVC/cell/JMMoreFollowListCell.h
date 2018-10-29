//
//  JMMoreFollowListCell.h
//  PanKeTong
//
//  Created by 陈行 on 2018/6/12.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PropFollowRecordDetailEntity.h"
#import "CustomerFollowItemEntity.h"

@interface JMMoreFollowListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *greenImageView;

@property (weak, nonatomic) IBOutlet UIView *greenView;

@property (weak, nonatomic) IBOutlet UILabel *labelFollowUp;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelFang;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UIButton *buttonPlacedTop;
//客源跟进类型
@property (nonatomic, strong) PropFollowRecordDetailEntity *entity;
//房源跟进类型，很奇怪，跟进难道不是同一个对象吗。。。。
@property (nonatomic, strong) CustomerFollowItemEntity * customerEntity;

+ (CGFloat)getHeight:(NSString*)string;

@end
