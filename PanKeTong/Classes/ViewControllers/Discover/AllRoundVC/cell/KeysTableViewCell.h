//
//  KeysTableViewCell.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/4/14.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PropKeysEntity;

@interface KeysTableViewCell : UITableViewCell<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *employeeName;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UILabel *countOfKeys;
@property (weak, nonatomic) IBOutlet UILabel *statusOfkeys;
@property (weak, nonatomic) IBOutlet UILabel *expertOfkeys;
@property (weak, nonatomic) IBOutlet UILabel *specificLocation;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specificLocationHeightConstant;

@property (nonatomic, copy) NSString *linkPhone;
@property (nonatomic, copy) NSString *keyLocation;
@property (nonatomic, strong) PropKeysEntity *propKeysEntity;

@end
