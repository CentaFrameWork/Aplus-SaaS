//
//  DealCell.m
//  PanKeTong
//
//  Created by Admin on 2018/3/21.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "DealCell.h"
#import "WJAllDealModel.h"

@interface DealCell ()

@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nodeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customerLabelWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nodeLabelWidthCon;


@end
@implementation DealCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.typeView setLayerCornerRadius:1.5];
    
    self.customerLabelWidthCon.constant *= APP_SCREEN_WIDTH/WIDTH_UI_DESIGN_SCREEN;
    self.timeLabelWidthCon.constant *= APP_SCREEN_WIDTH/WIDTH_UI_DESIGN_SCREEN;
    self.nodeLabelWidthCon.constant *= APP_SCREEN_WIDTH/WIDTH_UI_DESIGN_SCREEN;
}

- (void)setWjModel:(WJAllDealModel *)wjModel {
    _wjModel = wjModel;
    _customerLabel.text = wjModel.CustomerName;
    _timeLabel.text = wjModel.CreateTime;
    _typeLabel.text = wjModel.TransactionType;
    _nodeLabel.text = wjModel.TransactionNode;
    _typeView.backgroundColor = [wjModel.TransactionType isEqualToString:@"售"] ? YCTextColorSaleRed : YCTextColorRentOrange;
}


@end
