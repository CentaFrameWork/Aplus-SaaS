//
//  JMMessage.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMMessage.h"

@implementation JMMessage

- (instancetype)init{
    
    if (self = [super init]) {
        
        if ([self isKindOfClass:[JMMessageVideo class]]) {
            
            self.messageType = JMMessageTypeVideo;
            
        }else if ([self isKindOfClass:[JMMessagePhoto class]]){
            
            self.messageType = JMMessageTypePhoto;
            
        }else if ([self isKindOfClass:[JMMessageText class]]){
            
            self.messageType = JMMessageTypeText;
            
        }
        
    }
    
    return self;
}

- (void)setIsHiddenTime:(BOOL)isHiddenTime{
    
    _isHiddenTime = isHiddenTime;
    
    [self reloadCalculateHeight];
    
}

- (void)reloadCalculateHeight{
    
    
}

@end


@implementation JMMessageText

- (void)setText:(NSString *)text{
    
    _text = text;
    
    [self reloadCalculateHeight];
}

- (void)reloadCalculateHeight{
    
    CGSize size = CGSizeMake(APP_SCREEN_WIDTH - 12 - 50 - 12 - 24 - 12 - 60, MAXFLOAT);
    
    NSDictionary * dict=@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightLight]};
    
    size = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    self.textWidth = size.width + 12 + 24 + 4;
    
    self.textHeight = size.height + 9 + 9 + 1;
    
    self.textHeight = self.textHeight < 38 ? 38 : self.textHeight;
    
    self.rowHeight = (self.textHeight < 38 ? 50 : (self.textHeight + 6 + 6)) + (self.isHiddenTime ? 12 : 41);
}

@end

@implementation JMMessageVideo

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.rowHeight = 210;
        
    }
    
    return self;
}

-  (void)setMessageWidth:(CGFloat)messageWidth{
    
    _messageWidth = messageWidth;
    
    if (_messageWidth > 0 && _messageHeight > 0) {
        
        [self reloadWH];
        
    }
}

- (void)setMessageHeight:(CGFloat)messageHeight{
    
    _messageHeight = messageHeight;
    
    if (_messageWidth > 0 && _messageHeight > 0) {
        
        [self reloadWH];
        
    }
    
}

- (void)reloadWH{
    
    CGFloat tmpW = 140*_messageWidth/_messageHeight;
    
    if (tmpW > 200) {
        
        _messageHeight = 200*_messageHeight/_messageWidth;
        
        _messageWidth = 200;
        
        self.rowHeight = 210 - 140 + _messageHeight;
        
    }else{
        
        _messageWidth = tmpW;
        
        _messageHeight = 140;
        
        self.rowHeight = 210;
        
    }
    
}

@end


@implementation JMMessagePhoto

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.rowHeight = 210;
        
    }
    
    return self;
}

-  (void)setMessageWidth:(CGFloat)messageWidth{
    
    _messageWidth = messageWidth;
    
    if (_messageWidth > 0 && _messageHeight > 0) {
        
        [self reloadWH];
        
    }
}

- (void)setMessageHeight:(CGFloat)messageHeight{
    
    _messageHeight = messageHeight;
    
    if (_messageWidth > 0 && _messageHeight > 0) {
        
        [self reloadWH];
        
    }
    
}

- (void)reloadWH{
    
    CGFloat tmpW = 140*_messageWidth/_messageHeight;
    
    if (tmpW > 200) {
        
        _messageHeight = 200*_messageHeight/_messageWidth;
        
        _messageWidth = 200;
        
        self.rowHeight = 210 - 140 + _messageHeight;
        
    }else{
        
        _messageWidth = tmpW;
        
        _messageHeight = 140;
        
        self.rowHeight = 210;
        
    }
    
}

@end

