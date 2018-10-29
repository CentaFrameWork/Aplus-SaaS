//
//  GridCell.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/19.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "GridCell.h"

@implementation GridCell
{
    __weak IBOutlet UIImageView *_imgView;
    __weak IBOutlet UILabel *_titleLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = APP_BACKGROUND_COLOR;
    self.addBtn.userInteractionEnabled = NO;
}


- (void)fillDataWithDataArr:(NSArray *)dataArr andEntity:(APPLocationEntity *)entity
{
    _titleLabel.text = entity.title;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:entity.iconUrl] placeholderImage:[UIImage imageNamed:@"mrt"]];
    self.addBtn.hidden = NO;
    for (APPLocationEntity *entity1 in dataArr)
    {
        if (entity1.configId == entity.configId)
        {
            self.addBtn.hidden = YES;
            break;
        }
    }

}

@end
