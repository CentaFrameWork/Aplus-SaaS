//
//  UploadListCell.m
//  AplusVideoUploadDemo
//
//  Created by Liyn on 2017/11/22.
//  Copyright © 2017年 Liyn. All rights reserved.
//

#import "UploadListCell.h"
#import "CycleView.h"


@interface UploadListCell()
@property (nonatomic, strong) APUploadFile *uploadModel;
@property (nonatomic, strong) CycleView *cycleView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation UploadListCell
-(UITapGestureRecognizer *)tap{
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeStatus)];
    }
    return _tap;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.beginDateLabel];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.fileNameLabel];
        [self.contentView addSubview:self.cycleView];
        [self.contentView addSubview:self.sizeLabel];
        [self.contentView addSubview:self.speedLabel];
        [self.contentView addSubview:self.sepLine];
    }
    return self;
}
-(void)setUploadModel:(APUploadFile *)uploadModel{
    _uploadModel = uploadModel;
    [self refreshCellUI];
}

- (void)refreshCellUI{
    self.titleLabel.text = _uploadModel.estateName;

    self.beginDateLabel.text = _uploadModel.startTime;
    self.fileNameLabel.text = _uploadModel.videoName;
    self.sizeLabel.text = [NSString stringWithFormat:@"%@/%.1lfM",_uploadModel.uploadedSize,_uploadModel.videoTotalSize/1024.0/1024.0];
    self.cycleView.uploadStatus = _uploadModel.uploadState;
    self.icon.image = _uploadModel.videoImage;
    
    switch (_uploadModel.uploadState) {
        case UploadStatusPause:
        {
            _speedLabel.text = @"暂停";
        }
            break;

        case UploadStatusWaiting:
        {
            _speedLabel.text = @"等待上传中";
        }
            break;
        case UploadStatusUploading:
        {
            _speedLabel.text = _uploadModel.uploadSpeed;
             self.cycleView.progress = _uploadModel.progress;
        }
            break;
        default:
            break;
    }

}
    ///通过时间戳转换为指定的时间格式
-(NSString *)formatterDateIntervalWithInterval:(NSTimeInterval)dateInterval
                                     andFormat:(NSString *)formatStr
{

    NSDate *formatDate = [NSDate dateWithTimeIntervalSince1970:dateInterval/1000];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:formatStr];

    NSString *curDateStr = [dateFormatter stringFromDate:formatDate];

    return curDateStr;

}

- (void)changeStatus
{    
    if(!self.uploadModel.isTranscoding)
    {
        switch (self.uploadModel.uploadState) {
            case UploadStatusPause:
            {
                self.uploadModel.uploadState = UploadStatusWaiting;
            }
                break;
            case UploadStatusUploading:
            {
                self.uploadModel.uploadState = UploadStatusPause;
            }
                break;
            case UploadStatusWaiting:
            {
                self.uploadModel.uploadState = UploadStatusPause;
            }
                break;
                
            default:
                break;
        }
        if (self.changeSequence) {
            self.changeSequence(self.uploadModel.uploadState);
        }
    }
}
#pragma mark -----------------------  约束布局 -------------------------

-(void)layoutSubviews{
    CGFloat width = self.frame.size.width;

    self.titleLabel.frame = CGRectMake(14, 10, width - 80 -14, 22);

    self.beginDateLabel.frame = CGRectMake( width - 80, 15, 66, 17);

    self.icon.frame = CGRectMake(14, 42, 70, 53);

    self.fileNameLabel.frame = CGRectMake(94, 42,  width - 94 - 45 - 8, 20);

    self.cycleView.frame = CGRectMake(width - 45, 42, 32, 32);

    self.sizeLabel.frame = CGRectMake(94, 78, 78, 17);

    self.speedLabel.frame = CGRectMake(width - 115, 78, 65, 17);

    self.sepLine.frame = CGRectMake(0, 110, width, 1);

}

#pragma mark -----------------------  懒加载  -------------------------
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromHex(0x333333, 1);
        _titleLabel.font = [UIFont fontWithName:FontName size:16];
    }
    return _titleLabel;
}
-(UILabel *)beginDateLabel{
    if (_beginDateLabel == nil) {
        _beginDateLabel = [[UILabel alloc] init];
        _beginDateLabel.textColor = UIColorFromHex(0x999999, 1);
        _beginDateLabel.font = [UIFont fontWithName:FontName size:12];
    }
    return _beginDateLabel;
}
-(UILabel *)fileNameLabel{
    if (_fileNameLabel == nil) {
        _fileNameLabel = [[UILabel alloc] init];
        _fileNameLabel.textColor = UIColorFromHex(0x666666, 1);
        _fileNameLabel.font = [UIFont fontWithName:FontName size:14];
    }
    return _fileNameLabel;
}
-(UILabel *)sizeLabel{
    if (_sizeLabel == nil) {
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.textColor = UIColorFromHex(0x999999, 1);
        _sizeLabel.font = [UIFont fontWithName:FontName size:12];
    }
    return _sizeLabel;
}
-(UILabel *)speedLabel{
    if (_speedLabel == nil) {
        _speedLabel = [[UILabel alloc] init];
        _speedLabel.textColor = UIColorFromHex(0x999999, 1);
        _speedLabel.textAlignment = NSTextAlignmentCenter;
        _speedLabel.font = [UIFont fontWithName:FontName size:12];
    }
    return _speedLabel;
}
-(UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"thumbnail"];
    }
    return _icon;
}
-(UIView *)sepLine{
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = UIColorFromHex(0xeeeeee, 1);
    }
    return _sepLine;
}
-(CycleView *)cycleView{
    if (_cycleView == nil) {
        CGFloat width = self.frame.size.width;
        _cycleView = [[CycleView alloc] initWithFrame:CGRectMake(width - 45, 42, 32, 32)];
        [_cycleView addGestureRecognizer:self.tap];
    }
    return _cycleView;
}
@end
