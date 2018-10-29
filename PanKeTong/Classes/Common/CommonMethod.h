//
//  CommonMethod.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface CommonMethod : NSObject

// 设置行间距
+ (NSMutableAttributedString *)setLabelParagraphStyleWithString:(NSString *)changeStr andLineSpacing:(CGFloat)lineSpacing;

/**
 *  设置UILabel不同字体颜色
 */
+ (NSMutableAttributedString *)setLabelMutableColorWithColor:(UIColor *)otherTextColor andStr:(NSString *)changeStr andStarLoc:(NSInteger)starLocation andLength:(NSInteger)length;

+ (void)setUserdefaultWithValue:(id)value forKey:(NSString *)key;

+ (id)getUserdefaultWithKey:(NSString *)key;

// 转换Hex为UIColor
+ (UIColor *)transColorWithHexStr:(NSString *)hexStr;

// 根据时间转化为时间戳 并转为具体时间
+ (double)tryTimeNumberWith:(NSString *)time;
// 根据时间转化为时间戳 并转为具体时间
+ (double)getTimeNumberWith:(NSString *)time;
// 没有具体时间
+ (NSString*)dateFormat:(CGFloat)timeOld;
// 有具体时间
+ (NSString*)dateConcretelyTime:(CGFloat)timeOld andYearNum:(NSInteger)year;

/**
 *  截取时间为年-月-日
 */
+ (NSString *)subTime:(NSString *)time;
/**
 *  根据时间格式字符串，转换为年-月-日 (通盘房源详情)
 */
+ (NSString *)getFormatDateStrFromTime:(NSString *)timeStr;

/*
 *  根据时间格式字符串，转换为对应时间格式
 */
+ (NSString *)getFormatDateStrFromTime:(NSString *)timeStr DateFormat:(NSString *)dateFormat;

/**
 *  获取当前日期-时间-星期（新增外出）
 */
+ (NSString *)getSystemTime;

/// 获取当前时间戳
+ (NSInteger)getCurrentTimeInterval;

/**
 *  获取带星期的日期 YYYY-MM-dd 星期
 *
 */
+(NSString *)getFormatWeekDateStrFromTime:(NSString *)timeStr DateFormat:(NSString *)dateFormat;

/*
 *  根据时间格式字符串，转换为年-月-日 时-分-秒
 */
+ (NSString *)getDetailedFormatDateStrFromTime:(NSString *)timeStr;

/*
 *  根据NSDate格式，转成yyyy年MM月dd日(签到记录时间控件)
 */
+ (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat;

/**
 *  获取系统时间根据自定义格式
 */
+ (NSString *)getSysDateStrWithFormat:(NSString *)formatStr;

/// 计算当前时间差是否大于1分钟（约/带看不得早于或等于当前时间、 提醒不得早于或等于当前时间）
+(double)compareCurrentTime:(NSString *)timeStr andFormat:(NSString *)formatter;

////字符串转字典
//+ (NSDictionary *)getDicWithJsonString:(NSString *)jsonString;

/**
 *  实体转为字典对象
 */
+ (NSDictionary *) entityToDictionary:(id)entity;

/**
 *  根据NSDate转换为时间格式字符串
 */
+ (NSString *)formatDateStrFromDate:(NSDate *)timeDate;


/**
 *  压缩图片
 *
 */
+ (NSData *)compressImage:(UIImage *)image
            compressRatio:(CGFloat)ratio
         maxCompressRatio:(CGFloat)maxRatio
            andIsPanorama:(BOOL)isPanorama;

/**
 *  保存图片到document目录下，为上传图片提供路径
 */
+ (void)saveImageToDoc:(UIImage *)tempImage
              withName:(NSString *)imageName
         andIsPanorama:(BOOL)isPanorama;

/**
 *  删除document下指定name图片
 */
+ (void)deleteImageFromDocWithName:(NSString *)imageName;

/**
 *  获取本地图片路径
 */
+ (NSString *)getImageFromDocWithName:(NSString *)imageName;


/**
 *  获得分享二手房房源的shareLink
 */
+ (NSString *)getPropDetailShareLinkWithKeyId:(NSString *)propKeyId;

/**
 *  判断字符串是否为电话号码格式
 */
+ (BOOL)isMobile:(NSString *)mobile;

/**
 *  验证mobile是否是在7-11位之间
 */
+ (BOOL)mobileHaveProperLength:(NSString *)mobile;


/**
 *  验证是否含有特殊字符
 */
+ (BOOL)isUniqueStr:(NSString *)uniqueStr;

/**
 *  判断字符串是否是数字
 */
+ (BOOL)validateNumber:(NSString *)textString;


/**
 *  对融云 APP Secret、Nonce、Timestamp 进行SHA1哈希计算
 *
 *  @param appSecret 融云secret
 *  @param nonce     随机数
 *  @param timesTamp 时间戳
 *
 *  @return 加密后的字符串
 */
+ (NSString *)getSHA1WithStringWithSecret:(NSString *)appSecret
                                andNonce:(NSString *)nonce
                            andTimestamp:(NSString *)timesTamp;


/**
 *  注册/取消 推送通知
 */
+ (void)registPushWithState:(BOOL)isRegistPush;


/*
 *设置图片（判断是否是只在wifi下显示图片）
 *
 */
+ (void)setImageWithImageView:(UIImageView *)imageView
                 andImageUrl:(NSString *)imageUrl
     andPlaceholderImageName:(NSString *)placeholderImageName;
/**
 *检查访问联系人权限
 */
+ (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block;

/**
 *  计算不同尺寸控件在不同屏幕下的比例
 */
+ (CGFloat)calculateLengthFromMultipleScreenSizeWithLength:(CGFloat)length;

/**
 *  当前设备是否是iPhone6尺寸
 */
+ (BOOL)is4_7InchScreen;

/**
 *  当前设备是否是iPhone6plus尺寸或更大
 */
+ (BOOL)is5InchScreen;


/**
 *  是否包含**内容
 */
+ (BOOL)content:(NSString *)content containsWith:(NSString *)child;


///添加百度统计自定义事件
+ (void)addLogEventWithEventId:(NSString *)eventId
                 andEventDesc:(NSString *)eventDesc;

/// 是否使用新的APi地址
+ (BOOL)isRequestNewApiAddress;

/// 是否使用新的APi地址(最终版)
+ (BOOL)isRequestFinalApiAddress;

// 是否使用2.0界面
+ (BOOL)isLoadNewView;

// 拨打电话
+ (void)callTelWithNumber:(NSString *)number;

/**
 *
 * 键盘收起
 *
 **/
+ (void)resignFirstResponder;

/**
 *
 * 计算行数
 *
 **/
+ (NSInteger)getRowNumWithSunCount:(NSInteger)sumCount
                     andEachRowNum:(NSInteger)eachRowNum;



@end
