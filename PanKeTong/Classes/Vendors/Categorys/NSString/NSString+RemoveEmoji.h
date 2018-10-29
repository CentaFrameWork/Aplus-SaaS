//
//  NSString+RemoveEmoji.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/6/27.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RemoveEmoji)

- (BOOL)isIncludingEmoji;

- (instancetype)removedEmojiString;

@end
