//
//  EstateListCell.m
//  APlus
//
//  Created by 张旺 on 2017/10/18.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "EstateListCell.h"

static NSString * const cellIdentifier = @"EstateListCell";

@implementation EstateListCell

+ (EstateListCell *)cellWithTableView:(UITableView *)tableView {
    
    EstateListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"EstateListCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)setCellDataWithDataSource:(PropertysModelEntty *)dataSource {
   
    //名字
    self.estateName.text = [NSString stringWithFormat:@"%@  %@",dataSource.estateName,dataSource.buildingName];
    self.estateName.textColor = dataSource.isRead ? YCTextColorAuxiliary : YCTextColorBlack;
  
    
     NSString *imagePath = [NSString stringWithFormat:@"%@%@",dataSource.photoPath,AllRoundListPhotoWidth];

     [CommonMethod setImageWithImageView:self.estateImage andImageUrl:imagePath andPlaceholderImageName:@"defaultEstate"];
    

    
    //面积
    self.estateAcreage.text = [NSString stringWithFormat:@"%@平",dataSource.square];
    

    
   
    
    NSString *priceStrig;
    NSInteger rangeLenth = 0;
    if (dataSource.trustType.integerValue == SALE ||
        dataSource.trustType.integerValue == BOTH) {
        
        rangeLenth = 1;
        priceStrig = dataSource.salePrice;
        
    }else{
        
        rangeLenth = 1;
        priceStrig = dataSource.rentPrice;

    }


    
    if ([priceStrig isEqualToString:@"-"]) {
        
        self.estatePrice.hidden = YES;
        
    }else{
        
        self.estatePrice.hidden = NO;
        
       
        
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:priceStrig];
        
        
        [attrStr addAttributes:@{
                                 NSFontAttributeName : [UIFont systemFontOfSize:priceStrig.length >7?12:18 weight:UIFontWeightSemibold],
                                 } range:NSMakeRange(0, priceStrig.length-rangeLenth)];
        
        [attrStr addAttributes:@{
                                 NSFontAttributeName : [UIFont systemFontOfSize:12]
                                 } range:NSMakeRange(priceStrig.length-rangeLenth, rangeLenth)];
        
        //价格
        self.estatePrice.attributedText = attrStr;
        
    }
    
    
   //平均价格
    self.estateAvgPrice.text = [self getSring:dataSource.salePriceUnit];
    

    
    
    self.estateSupport.text = [NSString stringWithFormat:@"%@  %@",
                                              dataSource.houseType?:@"",
                                              dataSource.floor?:@""];
    
    self.estateDetailMsg.text = [NSString stringWithFormat:@"%@  %@",
                                  dataSource.houseDirection?:@"",
                                     dataSource.propertyType?:@""];
    
    
    
    
    
    
    self.estateTypeSignBtn.hidden = NO;
    
    switch (dataSource.trustType.integerValue) {
        case 1:
        {
            // 出售
            self.estateTypeSignBtnWidth.constant = 20;
            [self.estateTypeSignBtn setBackgroundImage:[UIImage imageNamed:@"售"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            // 出租
            self.estateTypeSignBtnWidth.constant = 20;
            [self.estateTypeSignBtn setBackgroundImage:[UIImage imageNamed:@"租"] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            // 租售
            self.estateTypeSignBtnWidth.constant = 40;
            [self.estateTypeSignBtn setBackgroundImage:[UIImage imageNamed:@"租售"] forState:UIControlStateNormal];
        }
            break;
            
        default:
        {
            self.estateTypeSignBtn.hidden = YES;
        }
            break;
    }
    
    // 设置列表中的标签的值
    NSInteger TagsCount = dataSource.propertyTags.count;
    self.estateFirstTagBtn.hidden = YES;
    self.estateSecondTagBtn.hidden = YES;
    self.estateThreeTagBtn.hidden = YES;
    for (int i = 0; i < TagsCount; i++) {
        PropertyTagEntity *firstTagEntity = [dataSource.propertyTags objectAtIndex:i];
        if (i == 0)
        {
            self.estateFirstTagBtn.hidden = NO;
            [self.estateFirstTagBtn setTitle:firstTagEntity.tagName
                                    forState:UIControlStateNormal];
            CGFloat firstBtnWidth = [firstTagEntity.tagName getStringWidth:[UIFont fontWithName:FontName size:11.0]
                                                                    Height:15
                                                                      size:11.0];
            self.estateFirstTagBtnWidth.constant = firstBtnWidth + 8 ;
        }
        else if (i == 1)
        {
            self.estateSecondTagBtn.hidden = NO;
            [self.estateSecondTagBtn setTitle:firstTagEntity.tagName
                                     forState:UIControlStateNormal];
            CGFloat secondBtnWidth = [firstTagEntity.tagName getStringWidth:[UIFont fontWithName:FontName size:11.0]
                                                                     Height:15
                                                                       size:11.0];
            self.estateSecondTagBtnWidth.constant = secondBtnWidth + 8 ;
        }
        else if (i == 2)
        {
            self.estateThreeTagBtn.hidden = NO;
            [self.estateThreeTagBtn setTitle:firstTagEntity.tagName
                                    forState:UIControlStateNormal];
            CGFloat threeBtnWidth = [firstTagEntity.tagName getStringWidth:[UIFont fontWithName:FontName size:11.0]
                                                                    Height:15
                                                                      size:11.0];
            self.estateThreeTagBtnWidth.constant = threeBtnWidth + 8 ;
        }
    }
    
    // 是否收藏
    self.isCollectionKey.hidden = !(dataSource.favoriteFlag);
    // 是否有房源钥匙
    self.isPropertyKey.hidden = !(dataSource.propertyKeyEnum);
    // 是否有委托独家
    self.isOnlyTrustKey.hidden = !(dataSource.isOnlyTrust);
    
    

    
    
}

// 收藏
- (IBAction)collectClick:(id)sender
{
    if (_blcok)
    {
        _blcok(@"收藏");
    }
}

/// 编辑
- (IBAction)estateEditClick:(id)sender
{
    if (_blcok)
    {
        _blcok(@"跟进");
    }
}

/// 电话
- (IBAction)estatePhoneClick:(id)sender
{
    if (_blcok)
    {
        _blcok(@"电话");
    }
}

/// 实勘
- (IBAction)estateRealClick:(id)sender
{
    if (_blcok)
    {
        _blcok(@"实勘");
    }
}

/// 分享
- (IBAction)estateShareClick:(id)sender
{
    if (_blcok)
    {
        _blcok(@"分享");
    }
}

///
- (IBAction)estateImageClick:(id)sender
{
    if (_blcok)
    {
        _blcok(@"图片");
    }
}

- (NSString *)removeZeroZeroWithValue:(NSString *)value{
    
    if ([value containsString:@".000"]) {
        
        value = [value stringByReplacingOccurrencesOfString:@".000" withString:@""];
        
    }else if ([value containsString:@".00"]){
        
        value = [value stringByReplacingOccurrencesOfString:@".00" withString:@""];
        
    }
    
    return value;
    
}

- (NSString*)getSring:(NSString*)string {
    
    
    if ([string isEqualToString:@"-"]) {
       
        return @"";
    }else{
        
        return string;
    }
    
}

@end
