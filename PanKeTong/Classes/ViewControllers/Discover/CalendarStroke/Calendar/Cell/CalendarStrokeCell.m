//
//  CalendarStrokeCell.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/24.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "CalendarStrokeCell.h"
#import "SubGoOutListEntity.h"
#import "SubTakingSeeEntity.h"
#import "SubAlertEventEntity.h"
#import "NSDate+Format.h"
enum EventTypeEnum{
    ASkLook = 0,
    daiLook = 1,
    
    
};
@implementation CalendarStrokeCell{
    NSString *_phoneStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _contenLabel.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setEventType:(NSString *)eventType{
    if (_eventType != eventType)
    {
        _eventType = eventType;
        [self setNeedsLayout];
    }
}

- (void)setDataEntity:(id)dataEntity{
    if (_dataEntity != dataEntity)
    {
        _dataEntity = dataEntity;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

    UIControl *phoneControl = [_contenLabel viewWithTag:1234];
    if (phoneControl != nil){
        [phoneControl removeFromSuperview];
        phoneControl = nil;
    }

    NSString *timeStr;  // 时间
    NSString *eventStr; // 事件类型

    if ([self.eventType isEqualToString:HasComplentEvent]){
        // 已完成
        _timeLabel.textColor = [UIColor grayColor];
        _eventLabel.textColor = [UIColor grayColor];
        _contenLabel.textColor = [UIColor grayColor];

        NSDictionary *dataDic = (NSDictionary *)_dataEntity;
        NSString *keyStr = [dataDic allKeys][0];
        id entity2D = [dataDic objectForKey:keyStr];
        eventStr = keyStr;

        if ([eventStr isEqualToString:TakingSeeEvent]){
            // 约看
            SubTakingSeeEntity *entity = (SubTakingSeeEntity *)entity2D;
            timeStr = (entity.reserveTime.length > 0)?entity.reserveTime:entity.takeSeeTime;
            _contenLabel.text = [NSString stringWithFormat:@"客户%@%@",entity.customerName,entity.mobile ?: @""];
        }else if ([eventStr isEqualToString:TakeSeeEvent]){
            // 带看
            SubTakingSeeEntity *entity = (SubTakingSeeEntity *)entity2D;
            
            NSString * propertyInfo = @"";
            
            if (entity.propertyList.count > 0) {
                
                NSDictionary * dict = [entity.propertyList firstObject];
                
                propertyInfo = dict[@"PropertyInfo"];
                
            }
            
            timeStr = (entity.reserveTime.length > 0)?entity.reserveTime:entity.takeSeeTime;
            _contenLabel.text = [NSString stringWithFormat:@"客户%@%@%@%@",entity.customerName,entity.mobile ?: @"",entity.seePropertyType ? : @"",propertyInfo];
        }else if ([eventStr isEqualToString:GoOutEvent]){
            // 外出
            SubGoOutListEntity *entity = (SubGoOutListEntity *)entity2D;
            timeStr = entity.goOutTime;
            _contenLabel.text = entity.remark;
        }

//        else if ([entity2D isKindOfClass:[SubAlertEventEntity class]]){
//            //提醒
//            SubAlertEventEntity *entity = (SubAlertEventEntity *)entity2D;
//            timeStr = entity.alertEventTimes;
//            _contenLabel.text = entity.remark;
//
//
//        }
    }else{
        eventStr = _eventType;
        // 约看／带看／外出／提醒
        _timeLabel.textColor = [UIColor blackColor];
        _eventLabel.textColor = [UIColor orangeColor];
        _contenLabel.textColor = [UIColor blackColor];

        // 赋值
        if ([self.eventType isEqualToString:TakingSeeEvent]) {
            // 约看
            SubTakingSeeEntity *entity = (SubTakingSeeEntity *)_dataEntity;
            timeStr = entity.reserveTime;
            NSString *contentStr = [NSString stringWithFormat:@"客户%@%@",entity.customerName,entity.mobile ?: @""];
            _contenLabel.text = contentStr;
            _phoneStr = entity.mobile ?: @"";

            // 手机号处理
            if (_phoneStr.length > 0) {
                [self validPhoneStrWithContentStr:contentStr];
            }
        }else if ([self.eventType isEqualToString:GoOutEvent]){
            // 外出
            SubGoOutListEntity *entity = (SubGoOutListEntity *)_dataEntity;
            timeStr = entity.goOutTime;
            _contenLabel.text = entity.remark;
        }
//        else if ([self.eventType isEqualToString:AlertEvent]){
//            //提醒
//            SubAlertEventEntity *entity = (SubAlertEventEntity *)_dataEntity;
//            timeStr = entity.alertEventTimes;
//            _contenLabel.text = entity.remark;
//        }
    }

    _eventLabel.text = eventStr;
    if (timeStr.length > 0) {
        NSArray *timeArr = [timeStr componentsSeparatedByString:@"T"];
        NSString *dateStr1 = [timeArr[0] substringFromIndex:5];
        NSString *timeStr2 = [timeArr[1] substringToIndex:5];
        _timeLabel.text = [NSString stringWithFormat:@"%@ %@",dateStr1,timeStr2];
    }
}

#pragma mark - 设置文本中的手机号属性

- (void)validPhoneStrWithContentStr:(NSString *)contenStr{
    NSRange phoneRange = [contenStr rangeOfString:_phoneStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contenStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:phoneRange];
    _contenLabel.attributedText = str;

    // 点击拨打电话
    UIControl *phoneControl = [_contenLabel viewWithTag:1234];
    if (phoneControl == nil)
    {
        UIControl *phoneControl = [[UIControl alloc] initWithFrame:[self boundingRectForCharacterRange:phoneRange andContentStr:contenStr]];
        phoneControl.tag = 1234;
        [phoneControl addTarget:self action:@selector(phoneLink) forControlEvents:UIControlEventTouchUpInside];
        [_contenLabel addSubview:phoneControl];
    }
}

#pragma mark - 获取电话号码的坐标

- (CGRect)boundingRectForCharacterRange:(NSRange)range andContentStr:(NSString *)contentStr
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSDictionary *attrs =@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
    [attributeString setAttributes:attrs range:NSMakeRange(0, contentStr.length)];

    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributeString];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self bounds].size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];

    NSRange glyphRange;
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    CGRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
    CGFloat yOfset =  rect.origin.y;
    rect.origin.y = yOfset + 4;
    rect.size.height = 40;
    return rect;
}

#pragma mark - 点击拨打电话

- (void)phoneLink{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要拨打电话吗?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];

}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1)
    {
        // 确定
        [self callPhone];
    }
}

#pragma mark - 确定拨打电话

- (void)callPhone{
    [CommonMethod addLogEventWithEventId:@"C stroke_dial_Click"  andEventDesc:@"日历行程页拨打电话量"];
    // 确定
    [CommonMethod callTelWithNumber:_phoneStr];
}

@end
