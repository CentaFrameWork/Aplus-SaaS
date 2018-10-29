//
//  JMSelectPropertyCell.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/21.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMSelectPropertyCell.h"

#import "JMSelectPropertyPropCell.h"

#import "JMSelectPropertyParam.h"



#import "UICollectionView+Category.h"
#import "CAShapeLayer+Category.h"

#define FINAL_SQUARE_PROP_KEY @"square"
#define FINAL_SALE_PRICE_UNIT_PROP_KEY @"salePriceUnit"

@interface JMSelectPropertyCell()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray * paramArr;

@property (nonatomic, strong) CAShapeLayer * verticalLineShapeLayer;

@end

@implementation JMSelectPropertyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.userInteractionEnabled = NO;
    
    self.saleConView.backgroundColor = [UIColor whiteColor];
    self.rentConView.backgroundColor = [UIColor whiteColor];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer shaperLayerAddLineFromPoint:CGPointMake(0, 64) toPoint:CGPointMake(APP_SCREEN_WIDTH, 64) andColor:YCOtherColorBorder];
    
    shapeLayer.lineDashPattern = @[@(3), @(3)];
    
    [self.saleRentConView.layer addSublayer:shapeLayer];
    
    shapeLayer = [CAShapeLayer shaperLayerAddLineFromPoint:CGPointMake(APP_SCREEN_WIDTH / 2, 8) toPoint:CGPointMake(APP_SCREEN_WIDTH / 2, 64 - 8) andColor:YCOtherColorBorder];
    
    [self.saleRentConView.layer addSublayer:shapeLayer];
    
    self.verticalLineShapeLayer = shapeLayer;
    
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.paramArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"JMSelectPropertyPropCell";
    
    JMSelectPropertyPropCell * cell = [collectionView collectionViewCellByNibWithIdentifier:identifier andIndexPath:indexPath];
    
    JMSelectPropertyParam * param = self.paramArr[indexPath.item];
    
    cell.titleLabel.text = param.title;
    
    cell.valueLabel.text = param.value;
    
    cell.unitLabel.text = param.isShowUnit ? param.unit : @"";
    
    cell.unitLabelRightCon.constant = indexPath.item % 2 == 0 ? 6 : 0;
    
    if ([param.propKey isEqualToString:FINAL_SQUARE_PROP_KEY]) {
        
        CGFloat fontSize = (cell.valueLabel.text.length >= 6 && APP_SCREEN_WIDTH < 375) ? 8 : 14;
        
        cell.valueLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
        
    }else if ([param.propKey isEqualToString:FINAL_SALE_PRICE_UNIT_PROP_KEY]){
        
        CGFloat fontSize = (cell.valueLabel.text.length >= 8 && APP_SCREEN_WIDTH <= 375) ? 8 : 14;
        
        cell.valueLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
        
    }else{
        
        cell.valueLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        
    }
    
    return cell;
}

#pragma mark - collectionView间隔，大小，填充，偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((APP_SCREEN_WIDTH - 24)/2, 26);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - setter
- (void)setEntity:(PropertysModelEntty *)entity{
    
    _entity = entity;
    
    self.houseNameLabel.text = [NSString stringWithFormat:@"%@-%@-%@", entity.estateName, entity.buildingName, entity.houseNo];
    
    self.saleConView.hidden = NO;
    self.rentConView.hidden = NO;
    
    NSInteger trustType = [entity.trustType integerValue];
    
    if (trustType == BOTH) {
        
        self.salePriceLabel.text = entity.salePrice;
        self.rentPriceLabel.text = entity.rentPrice;
        
        self.saleConViewWidthCon.constant = APP_SCREEN_WIDTH / 2;
        self.rentConViewWidthCon.constant = APP_SCREEN_WIDTH / 2;
        
        self.verticalLineShapeLayer.hidden = NO;
        
    }else if (trustType == SALE){
        
        self.salePriceLabel.text = entity.salePrice;
        
        self.rentConView.hidden = YES;
        
        self.saleConViewWidthCon.constant = APP_SCREEN_WIDTH;
        
        
        self.verticalLineShapeLayer.hidden = YES;
        
    }else{
        
        self.rentPriceLabel.text = entity.rentPrice;
        
        self.saleConView.hidden = YES;
        
        self.rentConViewWidthCon.constant = APP_SCREEN_WIDTH;
        
        self.verticalLineShapeLayer.hidden = YES;
        
    }
    
    //避免一边操作后台进行更改数据，一边移动端进行刷新展示会出现问题
    self.paramArr = nil;
    
    NSMutableArray * paramArr = [[NSMutableArray alloc] init];
    
    for (JMSelectPropertyParam * param in self.paramArr) {
        
        NSString * value = [entity valueForKeyPath:param.propKey];
        
        if (value == nil || value.length == 0) {//特殊处理
            
            if (![param.propKey isEqualToString:FINAL_SALE_PRICE_UNIT_PROP_KEY]) {
                
                param.value = @"-";
                
                [paramArr addObject:param];
                
            }
            
            continue;
            
        }
        
        if ([param.propKey isEqualToString:FINAL_SQUARE_PROP_KEY]) {//面积
            
            if ([value doubleValue] > 10000) {
                
                value = [self decimalNumber:[value doubleValue] num2:10000];
                
                value = [self removeZeroZeroWithValue:value];
                
                param.unit = [NSString stringWithFormat:@"万平"];
                
            }else{
                
                param.unit = [NSString stringWithFormat:@"平"];
                
            }
            
        }else{
            
            value = [value stringByAppendingFormat:@"%@", param.unit];
            
        }
        
        param.value = value;
        
        [paramArr addObject:param];
        
    }
    
    self.paramArr = paramArr;
    
    [self.collectionView reloadData];
    
}

- (void)setDetailEntity:(PropPageDetailEntity *)detailEntity{
    
    _detailEntity = detailEntity;
    
    for (JMSelectPropertyParam * param in self.paramArr) {
        
        if ([param.propKey isEqualToString:@"propertyCardClassName"]) {
            
            param.value = detailEntity.propertyCardClassName.length > 0 ? detailEntity.propertyCardClassName : @"-";
            
        }else if ([param.propKey isEqualToString:@"propertySituation"]){
            
            param.value = detailEntity.propertySituation.length > 0 ? detailEntity.propertySituation : @"-";
            
        }
        
    }
    
    [self.collectionView reloadData];
    
}

#pragma mark - getter
- (NSMutableArray *)paramArr{
    
    if (!_paramArr) {
        
        _paramArr = [JMSelectPropertyParam selectPropertyParamArrayFromPlist];
        
    }
    
    return _paramArr;
    
}

#pragma mark - private
- (NSString *)removeZeroZeroWithValue:(NSString *)value{
    
    if ([value containsString:@".000"]) {
        
        value = [value stringByReplacingOccurrencesOfString:@".000" withString:@""];
        
    }else if ([value containsString:@".00"]){
        
        value = [value stringByReplacingOccurrencesOfString:@".00" withString:@""];
        
    }
    
    return value;
    
}

- (NSString *)decimalNumber:(double)num1 num2:(double)num2 {
    
    NSDecimalNumber *n1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",num1]];
    
    NSDecimalNumber *n2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",num2]];
    
    NSDecimalNumber *n3 = [n1 decimalNumberByDividingBy:n2];
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber * roundedOunces = [n3 decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end

