//
//  PropertyInfoView.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/24.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "PropertyInfoView.h"
#import "PropertyInfoCell.h"

@implementation PropertyInfoView


- (instancetype)initWithFrame:(CGRect)frame
{

    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.minimumLineSpacing = 0;
    flowLayOut.minimumInteritemSpacing = 0;
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayOut]) {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        
        UINib *nib = [UINib nibWithNibName:@"PropertyInfoCell" bundle:[NSBundle mainBundle]];
        [self registerNib:nib forCellWithReuseIdentifier:@"PropertyInfoCell"];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
    }

    return self;
}


- (void)setRightArr:(NSArray *)rightArr {
    
        _rightArr = rightArr;
        [self reloadData];
    

}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _rightArr.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
   
    PropertyInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PropertyInfoCell" forIndexPath:indexPath];
    
    cell.leftLabel.text = _leftArr[indexPath.item];

    if (_rightArr.count > 0) {
        
        NSString *textString = _rightArr[indexPath.item];
        NSString *replace = nil ;
        if ([textString contains:@"元/平"]){
            replace = @"元/平";
            
            textString =  [textString substringToIndex:[textString rangeOfString:replace].location];
           
        }else if ([textString contains:@"平"]) {
            replace = @"平";
            textString =  [textString substringToIndex:[textString rangeOfString:@"平"].location];
        }else if ([textString contains:@"层"]){
            replace = @"层";
            textString =  [textString substringToIndex:[textString rangeOfString:@"层"].location];
        }
        
        cell.CompanyLabel.text = replace;
        cell.CompanyLabel.hidden = replace.length?NO:YES;
        cell.rightLabel.text = textString;
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat Width = (APP_SCREEN_WIDTH - 20) / 2;

    if (indexPath.item < 3) {

         return  CGSizeMake(Width-15, 35);

    }else{

        return  CGSizeMake(Width+15, 35);

    }

}

@end
