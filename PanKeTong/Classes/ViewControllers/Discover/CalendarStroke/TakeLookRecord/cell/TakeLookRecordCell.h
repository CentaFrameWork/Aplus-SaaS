//
//  TakeLookRecordCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakeLookRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookAtPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeLinkBtn;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;


-(void)setTakeLookRecordListDetailWithListEntity:(NSArray *)takeLookRecordListEntity
                                    andIndexPath:(NSIndexPath *)indexPath
                             andIsHiddenNextStep:(BOOL)isHiddenNextStep;
@end
