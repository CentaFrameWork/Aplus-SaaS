//
//  AllRoundDetailMoreItemCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllRoundDetailMoreItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *takePhotoItemBtn;
@property (weak, nonatomic) IBOutlet UIButton *keyItemBtn;
@property (weak, nonatomic) IBOutlet UIButton *onlySelfItemBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleSepLineHeight;
@property (weak, nonatomic) IBOutlet UIImageView *callPhoneView;

@property (weak, nonatomic) IBOutlet UILabel *signedExclusive;


@end
