//
//  UploadPhotoCell.h
//  PanKeTong
//
//  Created by 张旺 on 2017/7/19.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEntrustFilingVC.h"
#import "ShadowImageView.h"

@interface UploadPhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *photoTypeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *photoNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadPhotoTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *uploadPhotoImage;
@property (weak, nonatomic) IBOutlet UIImageView *uploadPhotoIconImage;
//@property (weak, nonatomic) IBOutlet UIImageView *uploadPhotoIconSmallImage;
@property (weak, nonatomic) IBOutlet UIButton *uploadPhotoIconSmallBtn;

@property (weak, nonatomic) IBOutlet UIButton *uploadPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *viewPhotoButton;
@property (weak, nonatomic) IBOutlet ShadowImageView *shadowImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadPhotoBtnTopConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadPhotoBtnLeftConstant;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadPhotoLabelTopConstant;


+ (UploadPhotoCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

-(void)setCellValueWithIndexPath:(NSIndexPath *)indexPath
                     andPhotoDic:(NSDictionary *)photoAllDic
               andServerPhotoDic:(NSDictionary *)serverPhotoDic
               andPhotoTypeArray:(NSMutableArray *)photoTypeArray
                 andIsSubmission:(BOOL)isSubmission;



@end
