//
//  LeftTopCell.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/17.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "RankingCell.h"
#import "DDProgressView.h"

@implementation RankingCell {

    __weak IBOutlet UIButton *_rankBtn;
    __weak IBOutlet UILabel *_agencyName;

    __weak IBOutlet DDProgressView *_performView;

    __weak IBOutlet UIButton *_money;


}

- (void)awakeFromNib {
    [super awakeFromNib];

}

//- (void)setTopPerformance:(float)topPerformance
//{
//    if (_topPerformance != topPerformance)
//    {
//        _topPerformance = topPerformance;
//    }
//}


- (void)fillData:(SubPerformanceEntity *)entity
        withRate:(float)rate
withRankingIndex:(NSInteger)index
{

    NSString *title = [NSString stringWithFormat:@"%ld",index];
    if (index < 4)
    {
        NSString *imgName = [NSString stringWithFormat:@"top%@",title];
        [_rankBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    }
    else
    {
        [_rankBtn setImage:nil forState:UIControlStateNormal];
    }
    NSString *nameStr = entity.employeeName.length > 0?entity.employeeName:@"无经理";
    [_rankBtn setTitle:[NSString stringWithFormat:@"  %@",title]  forState:UIControlStateNormal];

    _performView.progress = rate;
    _agencyName.text = nameStr;

    NSString *userNo = [AgencyUserPermisstionUtil getIdentify].userNo;
//    NSString *userNo = @"TJ06062201";

    if ([entity.employeeNo isEqualToString:userNo])
    {
        UIImage *image = [UIImage imageNamed:@"MyRank"];
        [_money setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_money setBackgroundImage:image forState:UIControlStateNormal];
    }
    else
    {
        [_money setTitleColor:YCThemeColorGreen forState:UIControlStateNormal];
        [_money setBackgroundImage:nil forState:UIControlStateNormal];
    }

    [_money setTitle:[NSString stringWithFormat:@"  %.2f万",[entity.performance floatValue] / 10000]
            forState:UIControlStateNormal];

}


@end
