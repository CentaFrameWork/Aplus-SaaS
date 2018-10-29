//
//  JMEntrustUploadPhotoCell.h
//  PanKeTong
//
//  Created by 陈行 on 2018/4/27.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMEntrustUploadPhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *imageConView;

@property (weak, nonatomic) IBOutlet UIImageView *selPhotoImageView;

@property (weak, nonatomic) IBOutlet UIView *hasSelPhotoConView;

@property (weak, nonatomic) IBOutlet UILabel *photoCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;


- (void)setPhotoArray:(NSArray *)photoArray andServerPhotoArray:(NSArray *)serverPhotoArray;

//-(void)setCellValueWithIndexPath:(NSIndexPath *)indexPath andPhotoDic:(NSDictionary *)photoAllDic andServerPhotoDic:(NSDictionary *)serverPhotoDic andPhotoTypeArray:(NSMutableArray *)photoTypeArray andIsSubmission:(BOOL)isSubmission;

@end
