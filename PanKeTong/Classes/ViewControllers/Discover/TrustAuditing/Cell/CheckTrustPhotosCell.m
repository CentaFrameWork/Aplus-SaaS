//
//  CheckTrustPhotosCell.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/23.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CheckTrustPhotosCell.h"
#import "SubCheckTrustEntity.h"

@implementation CheckTrustPhotosCell{
    
    __weak IBOutlet UIImageView *_photoImgView;
    __weak IBOutlet UILabel *_photoTypeLabel;
    __weak IBOutlet UILabel *_photoCountLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _photoImgView.layer.cornerRadius = 10;
    _photoImgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setDataDic:(NSDictionary *)dataDic
{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    NSString *typeStr = [[_dataDic allKeys] lastObject];
    _photoTypeLabel.text = [NSString stringWithFormat:@"%@照片",typeStr];

    NSArray *dataArr = [[_dataDic allValues] lastObject];
    _photoCountLabel.text = [NSString stringWithFormat:@"%ld张",dataArr.count];

    SubCheckTrustEntity *entity = [dataArr objectAtIndex:0];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",entity.attachmentPath,AllRoundListPhotoWidth,TrustWaterMark];
    [_photoImgView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
}

@end
