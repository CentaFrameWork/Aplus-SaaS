//
//  JMMessage.h
//  PanKeTong
//
//  Created by 陈行 on 2018/5/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JMMessageTypeText = 1001,//文本
    JMMessageTypePhoto,//图片
    JMMessageTypeVideo,//视频
    JMMessageTypeVoice,//语音
} JMMessageType;

@interface JMMessage : NSObject
/**
 *  用户id
 */
@property (nonatomic, copy) NSString * accountId;
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString * accountNickName;
/**
 *  用户头像
 */
@property (nonatomic, copy) NSString * accountImageUrl;
/**
 *  时间
 */
@property (nonatomic, copy) NSString * time;
/**
 *  是否是自己的消息
 */
@property (nonatomic, assign) BOOL isMe;
/**
 *  是否隐藏时间
 */
@property (nonatomic, assign) BOOL isHiddenTime;
/**
 *  消息类型，1文本、2图片、3视频、4语音
 */
@property (nonatomic, assign) JMMessageType messageType;
/**
 *  行高
 */
@property (nonatomic, assign) CGFloat rowHeight;

/**
 *  重新计算高度
 */
- (void)reloadCalculateHeight;

@end

@interface JMMessageText : JMMessage

/**
 *  文本信息
 */
@property (nonatomic, copy) NSString * text;
/**
 *  文本宽度
 */
@property (nonatomic, assign) CGFloat textWidth;
/**
 *  文本高度
 */
@property (nonatomic, assign) CGFloat textHeight;

@end

@interface JMMessageVideo : JMMessage
/**
 *  视频链接地址
 */
@property(nonatomic,copy)NSString * videoUrl;
/**
 *  视频占位图链接
 */
@property (nonatomic, copy) NSString * videoPlaceholderUrl;
/**
 *  视频宽度
 */
@property (nonatomic, assign) CGFloat messageWidth;
/**
 *  视频高度
 */
@property (nonatomic, assign) CGFloat messageHeight;

@end

@interface JMMessagePhoto : JMMessage
/**
 *  图片地址
 */
@property (nonatomic, copy) NSString * imageUrl;
/**
 *  消息宽度
 */
@property (nonatomic, assign) CGFloat messageWidth;
/**
 *  消息高度
 */
@property (nonatomic, assign) CGFloat messageHeight;

@end




