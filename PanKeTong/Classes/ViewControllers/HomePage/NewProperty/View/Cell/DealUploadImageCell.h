//
//  DealUploadImageCell.h
//  PanKeTong
//
//  Created by Admin on 2018/3/26.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DealUploadImageDelegate <NSObject>

- (void)didClickBtn:(UIButton*)btn;

@end
@interface DealUploadImageCell : UICollectionViewCell

@property (assign, nonatomic) CGFloat progress;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic,weak) id<DealUploadImageDelegate>delegate;

@end
