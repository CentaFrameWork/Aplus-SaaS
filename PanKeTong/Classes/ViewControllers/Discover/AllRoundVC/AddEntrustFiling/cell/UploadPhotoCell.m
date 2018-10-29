//
//  UploadPhotoCell.m
//  PanKeTong
//
//  Created by 张旺 on 2017/7/19.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "UploadPhotoCell.h"

@implementation UploadPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (UploadPhotoCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    // 每个不同类型设一个Identifier，防止上传图片时蒙层复用问题
    NSString *cellIdentifier = [NSString stringWithFormat:@"UploadPhotoCell%@",@(indexPath.row)];
    
    UploadPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"UploadPhotoCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    return cell;
}

-(void)setCellValueWithIndexPath:(NSIndexPath *)indexPath
                     andPhotoDic:(NSDictionary *)photoAllDic
               andServerPhotoDic:(NSDictionary *)serverPhotoDic
               andPhotoTypeArray:(NSMutableArray *)photoTypeArray
                 andIsSubmission:(BOOL)isSubmission
{
    self.uploadPhotoImage.contentMode =  UIViewContentModeScaleAspectFill;
    self.uploadPhotoImage.clipsToBounds  = YES;
    
    NSString *photoType = [photoTypeArray objectAtIndex:indexPath.row];
    
    self.photoTypeLabel.text = [NSString stringWithFormat:@"%@照片",photoType];
    self.uploadPhotoTypeLabel.text = [NSString stringWithFormat:@"上传%@照片",photoType];
    
    // 有编辑委托照片
    if (serverPhotoDic)
    {
        [self setHavePhotoAndNoPhotoCellWithPhotoArray:[photoAllDic objectForKey:photoType]
                                        andServerPhoto:[serverPhotoDic objectForKey:photoType]
                                       andIsSubmission:isSubmission];
    }
    else
    {
        [self setHavePhotoAndNoPhotoCellWithPhotoArray:[photoAllDic objectForKey:photoType]
                                        andServerPhoto:nil
                                       andIsSubmission:isSubmission];
    }
    
    // 有手动添加的照片，并且正在提交的时候显示上传进度
    if ([[photoAllDic objectForKey:photoType] count] > 0)
    {
        if (isSubmission)
        {
            self.shadowImageView.haveShadow = YES;
        }
        else
        {
            self.shadowImageView.haveShadow = NO;
        }
    }
    else
    {
        self.shadowImageView.haveShadow = NO;
    }
}

/// 设置有照片跟没照片Cell
-(void)setHavePhotoAndNoPhotoCellWithPhotoArray:(NSArray *)photoArray
                                 andServerPhoto:(NSArray *)serverPhotoArray
                                andIsSubmission:(BOOL)isSubmission
{
    
    self.photoTypeLabel.text = [NSString stringWithFormat:@"附件：%@张图片",@(photoArray.count + serverPhotoArray.count)];
    
    if (serverPhotoArray.count > 0)
    {
        
        NSRange range = [[[BaseApiDomainUtil getApiDomain] getImageServerUrl] rangeOfString:@"/image"];
        NSString *pathUrl = [[[BaseApiDomainUtil getApiDomain] getImageServerUrl] substringToIndex:range.location];
        
        // 取第一张
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@%@",pathUrl,serverPhotoArray[0],AllRoundListPhotoWidth];
        [CommonMethod setImageWithImageView:self.uploadPhotoImage andImageUrl:imageUrl andPlaceholderImageName:@"defaultPropBig_bg"];
    }
    else
    {
        if (photoArray.count > 0)
        {
            self.uploadPhotoImage.image = photoArray[0];  // 取第一张
        }
    }
    
    // 有照片
    if (serverPhotoArray.count > 0 || photoArray.count > 0){
        self.uploadPhotoIconSmallBtn.hidden = NO;
        self.uploadPhotoIconImage.hidden = YES;
        self.uploadPhotoTypeLabel.hidden = YES;
        self.viewPhotoButton.hidden = NO;
        self.uploadPhotoBtnTopConstant.constant = 120;
        self.uploadPhotoBtnLeftConstant.constant = 170;
    }else{
        self.photoTypeLabel.hidden = YES;
        self.uploadPhotoImage.image = nil;
        self.uploadPhotoIconSmallBtn.hidden = YES;
        self.uploadPhotoIconImage.hidden = NO;
        self.uploadPhotoTypeLabel.hidden = NO;
        self.viewPhotoButton.hidden = YES;
        self.uploadPhotoBtnTopConstant.constant = 0;
        self.uploadPhotoBtnLeftConstant.constant = 0;
        
        // 提交时
        if (isSubmission)
        {
            self.shadowImageView.haveShadow = NO;
            self.uploadPhotoIconImage.hidden = YES;
            self.uploadPhotoTypeLabel.text = @"未上传该类型照片";
//            self.uploadPhotoLabelTopConstant.constant = 70;
        }
        else
        {
//            self.uploadPhotoLabelTopConstant.constant = 101;
        }
    }
}

@end
