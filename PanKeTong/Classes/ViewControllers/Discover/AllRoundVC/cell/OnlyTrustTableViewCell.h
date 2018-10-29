//
//  OnlyTrustTableViewCell.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PropOnlyTrustEntity;

@interface OnlyTrustTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *onlyTrustPerson;
@property (weak, nonatomic) IBOutlet UILabel *onlyTrustType;
@property (weak, nonatomic) IBOutlet UILabel *effectiveDate;

@property (nonatomic, strong) PropOnlyTrustEntity *propOnlyTrustEntity;

@end
