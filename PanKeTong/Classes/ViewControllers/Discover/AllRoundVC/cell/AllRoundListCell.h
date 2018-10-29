//
//  AllRoundListCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/25.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllRoundListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *propImgView;
@property (weak, nonatomic) IBOutlet UILabel *propTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *propSupportLabel;
@property (weak, nonatomic) IBOutlet UILabel *propPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *propAvgPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *propDetailMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *propAcreage;//面积
@property (weak, nonatomic) IBOutlet UIButton *propFirstTagBtn;
@property (weak, nonatomic) IBOutlet UIButton *propSecondTagBtn;
@property (weak, nonatomic) IBOutlet UIButton *propThreeTagBtn;

@property (weak, nonatomic) IBOutlet UIButton *propImageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *propTypeSignImageView;
@property (weak, nonatomic) IBOutlet UILabel *propImageCntLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propFirstTagBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propSecondTagBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propThreeTagBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propTypeSignImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propImgCntViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *tag1;
@property (weak, nonatomic) IBOutlet UILabel *tag2;

@property (weak, nonatomic) IBOutlet UIImageView *propImageAO;

@end
