//
//  PropertyInfoView.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/24.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyInfoView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *leftArr;

@property (nonatomic, strong) NSArray *rightArr;

@end
