//
//  UploadSeeEstateListCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/12/9.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadSeeEstateListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *uploadSeeEstateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *uploadSeeImage;   //上传看房单照片
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

+ (UploadSeeEstateListCell *)cellWithTableView:(UITableView *)tableView;

@end
