//
//  KeysTableViewCell.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/4/14.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "KeysTableViewCell.h"
#import "PropKeysEntity.h"

@implementation KeysTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    [_phoneNumberButton addTarget:self action:@selector(callPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    _phoneNumberButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_phoneNumberButton setTitleColor:RGBColor(50, 106, 155) forState:UIControlStateNormal];
    
    if ([CityCodeVersion isChongQing])
    {
        _specificLocation.hidden = NO;
        _phoneNumberButton.hidden = NO;
    }
    else
    {
        _specificLocation.hidden = YES;
        _phoneNumberButton.hidden = YES;
    }
}

- (void)callPhoneAction:(UIButton *)btn
{
    NSString *lastCallTime = [CommonMethod getUserdefaultWithKey:KeyListVCCallTime];
    
    if (lastCallTime)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:CompleteFormat];
        NSDate *destDate= [dateFormatter dateFromString:lastCallTime];
        // 当前日历
        NSCalendar *calendar = [NSCalendar currentCalendar];
        // 需要对比的时间数据
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
        | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        // 对比时间差
        NSDateComponents *dateCom = [calendar components:unit fromDate:destDate toDate:[NSDate date] options:0];
        
        NSLog(@"dateCom.second = %ld",dateCom.second);
        if (dateCom.minute < 1)
        {
            if (dateCom.second < 2)
            {
                // 不超过三秒不让重复点击
                return;
            }
        }
    }
    
    NSString *buttonText = _phoneNumberButton.titleLabel.text;
    if (buttonText.length > 0)
    {
        NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (versionStr.length <= 1) {
            versionStr = [versionStr stringByAppendingString:@"00"];
        } else if (versionStr.length <= 2) {
            versionStr = [versionStr stringByAppendingString:@"0"];
        }
        CGFloat version = versionStr.floatValue;

        if (version < 1020)
        {
            UIAlertView *isCallStaff = [[UIAlertView alloc]initWithTitle:buttonText
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                       otherButtonTitles:@"呼叫", nil];
            [isCallStaff show];
        }
        else
        {
            NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",buttonText];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            [CommonMethod setUserdefaultWithValue:[NSDate stringWithDate:[NSDate date]] forKey:KeyListVCCallTime];
        }
    }
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        // 确认呼叫
        NSString *buttonText = _phoneNumberButton.titleLabel.text;
        NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",buttonText];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        [CommonMethod setUserdefaultWithValue:[NSDate stringWithDate:[NSDate date]] forKey:KeyListVCCallTime];
    }
}

- (void)setPropKeysEntity:(PropKeysEntity *)propKeysEntity
{
    _propKeysEntity = propKeysEntity;
    
    self.employeeName.text = propKeysEntity.receiver;
    self.dateTime.text = propKeysEntity.receivedTime;
    self.countOfKeys.text = [NSString stringWithFormat:@"%ld", (long)propKeysEntity.keyCount ];
    self.statusOfkeys.text = propKeysEntity.type;
    self.expertOfkeys.text = propKeysEntity.propKeyStatus;
}

- (void)setLinkPhone:(NSString *)linkPhone
{
    _linkPhone = linkPhone;
    [self.phoneNumberButton setTitle:linkPhone forState:UIControlStateNormal];
}

- (void)setKeyLocation:(NSString *)keyLocation
{
    _keyLocation = keyLocation;
    self.specificLocation.text = keyLocation;
}

@end
