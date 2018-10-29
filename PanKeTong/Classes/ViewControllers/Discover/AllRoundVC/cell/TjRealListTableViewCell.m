//
//  TjRealListTableViewCell.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/6/29.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "TjRealListTableViewCell.h"
#import "RealSurveyEntity.h"
#import "APUploadVideo.h"
#import "APUploadFile.h"

@implementation TjRealListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setRealSurveyEntity:(RealSurveyEntity *)realSurveyEntity
{
    self.realsurveyPerson.text = realSurveyEntity.realSurveyPerson;
    self.realsurveyTime.text = realSurveyEntity.realSurveyTime;
    self.realsurveyPhotoCount.text = realSurveyEntity.photoCount;
    
    [self UploadVideoStatus:realSurveyEntity];
}

// 上传视频状态
- (void)UploadVideoStatus:(RealSurveyEntity *)realSurveyEntity
{
    NSMutableArray *uploadVideoArr = [[APUploadVideo sharedUploadVideo]getUploadTaskArr];
    NSInteger arrCount = uploadVideoArr.count;
    
    for (int i = 0; i < arrCount ; i++)
    {
        APUploadFile *uploadFile = uploadVideoArr[i];
        
        if ([uploadFile.realKeyId isEqualToString: realSurveyEntity.keyId])
        {
            self.uploadStatus.text = @"上传中";
            return;
        }
    }
    
    if ([realSurveyEntity.isVideo boolValue])
    {
        self.uploadStatus.text = @"已上传";
    }else
    {
        self.uploadStatus.text = @"未上传";
    }
    
}

@end
