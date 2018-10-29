//
//  HQAllRoundDetailBasicMsgCell.h
//  Calendar module
//
//  Created by 李慧娟 on 16/11/23.
//  Copyright © 2016年 luqinbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQAllRoundDetailBasicMsgCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *propHouseType;

@property (weak, nonatomic) IBOutlet UILabel *propSalePriceLabel;// 人民币
@property (weak, nonatomic) IBOutlet UILabel *propSaleHKPriceLabel; // 港币


@property (weak, nonatomic) IBOutlet UILabel *propHouseTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *propFloorLabel;
@property (weak, nonatomic) IBOutlet UILabel *propRightLabel;

@property (weak, nonatomic) IBOutlet UILabel *propSalePriceUnitLabel; // 平方米
@property (weak, nonatomic) IBOutlet UILabel *propSalePriceUnitFootLabel;  //  呎


@property (weak, nonatomic) IBOutlet UILabel *propHouseSituationLabel;
@property (weak, nonatomic) IBOutlet UILabel *propBringSeeTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *propDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *propSalePriceUnitTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *propFirstPriceTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propSalePriceUnitTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propRentPriceTopHeight;

@property (weak, nonatomic) IBOutlet UILabel *propRentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *propRentValueLabel;// 人民币
@property (weak, nonatomic) IBOutlet UILabel *propRentValueHKLabel; // 港币


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacingWitRentTitleTopHeight;

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;



@end
