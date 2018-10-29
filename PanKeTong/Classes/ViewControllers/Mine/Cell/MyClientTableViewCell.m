//
//  MyClientTableViewCell.m
//  PanKeTong
//
//  Created by wanghx17 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyClientTableViewCell.h"
#import "CustomerEntity.h"

@implementation MyClientTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

- (void)setCustomerEntity:(CustomerEntity *)customerEntity {
    _customerEntity = customerEntity;
    
    
    NSString *inquiryTradeType = customerEntity.inquiryTradeType ? customerEntity.inquiryTradeType:@"";
    NSString *districts = [customerEntity.districts isEqualToString:@"-"] ? @"":customerEntity.districts;
    
    self.nameLabel.text = customerEntity.customerName ? customerEntity.customerName:@"";;
    self.estateAddressLabel.text = [NSString stringWithFormat:@"%@   %@",inquiryTradeType,districts];
    
    self.estatePriceLabel.text = customerEntity.salePrice?:@"-";
    self.hireLabel.text = customerEntity.rentPrice?:@"-";
    
    if ([self.estatePriceLabel.text isEqualToString:@"-"]) {
        
        self.estatePriceLabel.textColor = RGBColor(153, 153, 153);
   
    }else{
        
        self.estatePriceLabel.textColor = RGBColor(230, 95, 95);
    }
    
    
    if ([self.hireLabel.text isEqualToString:@"-"]) {
      
        self.hireLabel.textColor = RGBColor(153, 153, 153);
    }else{
        
        self.hireLabel.textColor = RGBColor(229, 137, 9);
        
        
    }
    
    
    
    
}



@end
