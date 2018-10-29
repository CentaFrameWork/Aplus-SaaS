//
//  JMEntrustUploadPhotoCell.m
//  PanKeTong
//
//  Created by 陈行 on 2018/4/27.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMEntrustUploadPhotoCell.h"


@implementation JMEntrustUploadPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.imageConView setLayerCornerRadius:5];
    
    self.imageConView.layer.borderColor = YCOtherColorDivider.CGColor;
    self.imageConView.layer.borderWidth = SINGLE_LINE_WIDTH;
    
    self.selPhotoImageView.userInteractionEnabled = YES;
    
    self.imageConView.backgroundColor = YCEntrustAttachmentBGColor;
    
}


//- (void)setCellValueWithIndexPath:(NSIndexPath *)indexPath andPhotoDic:(NSDictionary *)photoAllDic andServerPhotoDic:(NSDictionary *)serverPhotoDic andPhotoTypeArray:(NSMutableArray *)photoTypeArray andIsSubmission:(BOOL)isSubmission{

- (void)setPhotoArray:(NSArray *)photoArray andServerPhotoArray:(NSArray *)serverPhotoArray{

//    NSString * photoType = [photoTypeArray objectAtIndex:indexPath.row];
//
//    NSArray * photoArray = [photoAllDic objectForKey:photoType];
//
//    NSArray * serverPhotoArray = [serverPhotoDic objectForKey:photoType];
    
    self.hasSelPhotoConView.hidden = (photoArray.count + serverPhotoArray.count) == 0;
    
    self.selPhotoImageView.hidden = NO;
    
    self.photoCountLabel.text = [NSString stringWithFormat:@"附件：%@张图片", @(photoArray.count + serverPhotoArray.count)];
    
    if (serverPhotoArray.count > 0){
        
        NSRange range = [[[BaseApiDomainUtil getApiDomain] getImageServerUrl] rangeOfString:@"/image"];
        NSString *pathUrl = [[[BaseApiDomainUtil getApiDomain] getImageServerUrl] substringToIndex:range.location];
        
        // 取第一张
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@%@",pathUrl,serverPhotoArray[0],AllRoundListPhotoWidth];
        
        [CommonMethod setImageWithImageView:self.selPhotoImageView andImageUrl:imageUrl andPlaceholderImageName:@"defaultPropBig_bg"];
        
    } else if (photoArray.count > 0){
        
        self.selPhotoImageView.image = photoArray[0];  // 取第一张
        
    }else{
        
        self.selPhotoImageView.hidden = YES;
        
        self.selPhotoImageView.image = nil;
        
    }
    
}

@end
