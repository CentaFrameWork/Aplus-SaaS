//
//  EstateListCell.h
//  APlus
//
//  Created by 张旺 on 2017/10/18.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertysModelEntty.h"


typedef void(^estateBtnClickBlock)(NSString *btnName);

@interface EstateListCell : UITableViewCell

/// 名字
@property (weak, nonatomic) IBOutlet UILabel *estateName;
/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *estateImage;
/// 价格
@property (weak, nonatomic) IBOutlet UILabel *estatePrice;
/// 均价
@property (weak, nonatomic) IBOutlet UILabel *estateAvgPrice;
/// 面积
@property (weak, nonatomic) IBOutlet UILabel *estateAcreage;
/// 房型跟楼层
@property (weak, nonatomic) IBOutlet UILabel *estateSupport;
/// 朝向跟楼层信息
@property (weak, nonatomic) IBOutlet UILabel *estateDetailMsg;

/// 收藏
@property (weak, nonatomic) IBOutlet UIButton *estateFavoriteBtn;
/// 编辑
@property (weak, nonatomic) IBOutlet UIButton *estateEditBtn;
/// 电话
@property (weak, nonatomic) IBOutlet UIButton *estatePhoneBtn;
/// 实勘
@property (weak, nonatomic) IBOutlet UIButton *estateRealBtn;
/// 分享
@property (weak, nonatomic) IBOutlet UIButton *estateShareBtn;
/// 是否有房源钥匙
@property (weak, nonatomic) IBOutlet UIButton *isPropertyKey;
/// 是否有委托独家
@property (weak, nonatomic) IBOutlet UIButton *isOnlyTrustKey;
/// 是否收藏
@property (weak, nonatomic) IBOutlet UIButton *isCollectionKey;



@property (weak, nonatomic) IBOutlet UIButton *estateFirstTagBtn;
@property (weak, nonatomic) IBOutlet UIButton *estateSecondTagBtn;
@property (weak, nonatomic) IBOutlet UIButton *estateThreeTagBtn;


//@property (weak, nonatomic) IBOutlet UIImageView *estateTypeSignImageView;

@property (weak, nonatomic) IBOutlet UIButton *estateTypeSignBtn;
@property (weak, nonatomic) IBOutlet UILabel *estateImageCntLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *estateFirstTagBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *estateSecondTagBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *estateThreeTagBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *estateTypeSignBtnWidth;

@property (nonatomic, copy) estateBtnClickBlock blcok;

+ (EstateListCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellDataWithDataSource:(PropertysModelEntty *)dataSource;

@end
