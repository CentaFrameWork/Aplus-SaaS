//
//  PDFitstCell.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/21.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 房源详情第一组cell
@interface PDOneCell : UITableViewCell

@property (nonatomic, assign) NSInteger trustType;

@property (nonatomic, strong) NSArray *dataArr;// @[售价，租价，房型]

@end
