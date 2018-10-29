//
//  PhotoAlbumListCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/15.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAlbumListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoAlbumPosterImageView;
@property (weak, nonatomic) IBOutlet UILabel *photoAlbumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoAlbumCountLabel;


@end
