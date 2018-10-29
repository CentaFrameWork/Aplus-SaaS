//
//  AllRoundDetailBasicMsgCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllRoundDetailBasicMsgCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *propHouseType;

@property (weak, nonatomic) IBOutlet UILabel *propSalePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *propHouseTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *propFloorLabel;
@property (weak, nonatomic) IBOutlet UILabel *propRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *propSalePriceUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *propHouseSituationLabel;
@property (weak, nonatomic) IBOutlet UILabel *propBringSeeTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *propDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *propSalePriceUnitTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *propFirstPriceTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propRentPriceTitleTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propRentPriceValueTopHeight;
@property (weak, nonatomic) IBOutlet UILabel *propRentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *propRentValueTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *buildingAreaName;     // 建筑面积name
@property (weak, nonatomic) IBOutlet UILabel *buildingAreaValue;    // 建筑面积value
@property (weak, nonatomic) IBOutlet UILabel *practicalAreaName;    // 实用面积name
@property (weak, nonatomic) IBOutlet UILabel *practicalAreaValue;   // 实用面积value
@property (weak, nonatomic) IBOutlet UILabel *decorationSituationName;  // 装修情况name
@property (weak, nonatomic) IBOutlet UILabel *decorationSituationValue; // 装修情况value
@property (weak, nonatomic) IBOutlet UILabel *houseUseingName;          // 房屋用途name
@property (weak, nonatomic) IBOutlet UILabel *houseUseingValue;         // 房屋用途value



@end
