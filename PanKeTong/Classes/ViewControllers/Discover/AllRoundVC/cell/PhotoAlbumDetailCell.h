//
//  PhotoAlbumDetailCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/15.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAlbumDetailCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *assetsImageView;
@property (weak, nonatomic) IBOutlet UIView *selectAssetsView;
@property (weak, nonatomic) IBOutlet UIImageView *selectAssetsIcon;
@property (weak, nonatomic) IBOutlet UIButton *selectAssetsBtn;


@end
