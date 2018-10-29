//
//  ChooseLocationCell.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/25.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "ChooseLocationCell.h"

@implementation ChooseLocationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (ChooseLocationCell *)cellWithTableView:(UITableView *)tableView{
    
    ChooseLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:NSStringFromClass(self)];
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
        
    }
    return cell;
    
}

-(void)setCellValueWithDataArray:(NSArray *)array
                    andIndexPath:(NSIndexPath *)indexPath
               andChooseLocation:(LocationEntity *)chooseLocation
{
    LocationEntity *locationEntity = array[indexPath.row];
    _locationTitle.text = locationEntity.addressName;
    _locationDetail.text = locationEntity.addressDetail;
    
    //之前选过的位置图片设置为选中状态
    if (chooseLocation.addressDetail) {
        
        if ([locationEntity.addressDetail isEqualToString:chooseLocation.addressDetail]) {
            
            [_chooseImg setImage:[UIImage imageNamed:@"photoAssetsSelect_icon"]];
        }else{
            [_chooseImg setImage:[UIImage imageNamed:@"gray_round_img"]];
        }
        
    }else{
        
        if ([locationEntity.addressName isEqualToString:@"当前位置"]) {
            [_chooseImg setImage:[UIImage imageNamed:@"photoAssetsSelect_icon"]];
        }else{
            [_chooseImg setImage:[UIImage imageNamed:@"gray_round_img"]];
        }
    }
}

@end
