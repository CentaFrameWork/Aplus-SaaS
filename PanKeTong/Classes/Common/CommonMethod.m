//
//  CommonMethod.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CommonMethod.h"
#import <CommonCrypto/CommonDigest.h>
#import <RongIMKit/RongIMKit.h>
#import "Reachability.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import <objc/runtime.h>

@implementation CommonMethod
/*
 *设置行间距
 *
 */
+ (NSMutableAttributedString *)setLabelParagraphStyleWithString:(NSString *)changeStr andLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:changeStr];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [changeStr length])];
    return attributedString;
}
/*
 *设置不同颜色的字体，UILabel
 *
 */

+ (NSMutableAttributedString *)setLabelMutableColorWithColor:(UIColor *)otherTextColor andStr:(NSString *)changeStr andStarLoc:(NSInteger)starLocation andLength:(NSInteger)length
{
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:changeStr];
    [attriStr addAttribute:NSForegroundColorAttributeName
                     value:otherTextColor
                     range:NSMakeRange(starLocation, length)];
    
    return attriStr;
    
}

/**
 *  存取NSUserDefault
 *
 */
+ (void)setUserdefaultWithValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:value forKey:key];
    [userDefault synchronize];
}

/**
 *  取NSUserDefault
 *
 */
+ (id)getUserdefaultWithKey:(NSString *)key
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
}

/**
 *  转换Hex为UIColor
 *
 *  @param hexStr
 *
 *  @return UIColor
 */
+ (UIColor *)transColorWithHexStr:(NSString *)hexStr
{
    
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =[UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                                     blue:((CGFloat) (hexint & 0xFF))/255
                                    alpha:1.0];
    
    return color;
}

+ (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

+ (BOOL)content:(NSString *)content containsWith:(NSString *)child
{
    if([content rangeOfString:child].location != NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 
 根据时间转化为时间戳 并转为具体时间
 
 **/
+ (double)tryTimeNumberWith:(NSString *)time
{
    BOOL haveMM =  [self content:time containsWith:@"."];
    if(!haveMM){
        time = [NSString stringWithFormat:@"%@.000",time];
    }
    
    return [self getTimeNumberWith:time];
}

/**
 
 根据时间转化为时间戳 并转为具体时间
 
 **/
+ (double)getTimeNumberWith:(NSString *)time
{
    time = [time substringToIndex:19];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:DateAndTimeFormat];
    
    //得到系统时间
    NSDate *formatDate = [formatter dateFromString:time];
    
    double timeNumber = [formatDate timeIntervalSince1970];
    
    return timeNumber;
}

// 没有具体时间
+ (NSString*)dateFormat:(CGFloat)timeOld
{
    CGFloat timeTag = [[NSDate date] timeIntervalSince1970];
    CGFloat timebase = 0; // 以当前时间为基准的时刻数
    NSDate *nowDate = [NSDate date];
    static NSDateFormatter *dateFormater = nil;
    if (dateFormater == nil) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    
    [dateFormater setDateFormat:@"H"];
    NSString *hour = [dateFormater stringFromDate:nowDate];
    // 获得比较的基准时间
    timebase = timeTag - timeOld;
    if (timebase < 60 * 2) {
        return @"刚刚";
    } else {
        if (timebase < 60 * 60 ) {
            NSInteger tag = ceil(timebase/60);
            NSString *tagString = [NSString stringWithFormat:@"%@",tag== 59 ? @"1小时前":[NSString stringWithFormat:@"%@分钟前",@(tag+1)]];
            return tagString;
        } else {
            
            if (timebase < 60*60* (hour.intValue))
            {
                NSInteger tag =  ceil(timebase/(60.0*60));
                return [NSString stringWithFormat:@"%@小时前",@(tag-1)];
            }
            else
            {
                
                if (timebase < 60 * 60 * (hour.intValue + 24))
                {
                    return [NSString stringWithFormat:@"昨天"];
                }
                else
                {
                    NSDate * now=[NSDate date];
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
                    NSInteger time= timeOld/60/60/24/365+1970;
                    if (time!=[dateComponent year])
                    {
                        [dateFormater setDateFormat:@"yyyy年M月d日"];
                        
                    }
                    else
                    {
                        [dateFormater setDateFormat:@"M月d日"];
                    }
                    return [dateFormater  stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeOld]];
                }
            }
            
        }
    }
    
}

// 有具体时间
+ (NSString*)dateConcretelyTime:(CGFloat)timeOld andYearNum:(NSInteger)year
{
    /*
    CGFloat timeTag = [[NSDate date] timeIntervalSince1970];
    CGFloat timebase = 0; // 以当前时间为基准的时刻数

    NSDate *nowDate = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *nowDate = [date  dateByAddingTimeInterval: interval];//当前时间
    
    static NSDateFormatter *dateFormater = nil;
    if (dateFormater == nil)
    {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    
    [dateFormater setDateFormat:@"HH"];
    NSString *hour = [dateFormater stringFromDate:nowDate];

    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeOld];


    // 获得比较的基准时间
    timebase = timeTag - timeOld;
    if  (timebase < 60*60* (hour.intValue)&& hour.intValue<24 && timebase >= 0)
    {
        [dateFormater setDateFormat:@"HH:mm"];
    }
    else  if (timebase < 60*60* (hour.intValue +24) && timebase >= 60*60* (hour.intValue))
    {
        [dateFormater setDateFormat:@"昨天 HH:mm"];
    }
    else  if (timebase < 60*60* (hour.intValue + 48 ) && timebase >= 60*60* (hour.intValue + 24))
    {
        [dateFormater setDateFormat:@"前天 HH:mm"];
    }
    else
    {
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        //判断是否为闰年
        NSInteger dayCount;
        if ((year%4==0 && year %100 !=0) || year%400==0) {
            dayCount = 366;
        }else {
            dayCount = 365;
        }

        NSInteger time= timeOld/60/60/24/dayCount  +1970;
        if (time!=[dateComponent year])
        {
            [dateFormater setDateFormat:@"YYYY年M月d日 HH:mm"];
            
        }
        else
        {
            [dateFormater setDateFormat:@"M月d日 HH:mm"];
        }
    }
    return [dateFormater  stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeOld]];
     */
    
    NSDate *date = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *nowDate = [date  dateByAddingTimeInterval: interval];//当前时间
    NSTimeInterval now = [date timeIntervalSince1970]*1;
    NSInteger today = now/(24*3600);
    NSInteger yestoday = timeOld/(24*3600);;
    NSInteger iDiff = today - yestoday;
    NSString *strDiff = nil;
    
    static NSDateFormatter *dateFormater = nil;
    if (dateFormater == nil)
    {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    

    if(iDiff == 0)
    {
        [dateFormater setDateFormat:@"HH:mm"];
    }
    else if (iDiff == 1)
    {
        [dateFormater setDateFormat:@"昨天 HH:mm"];
    }
    else if (iDiff == 2)
    {
        [dateFormater setDateFormat:@"前天 HH:mm"];
    }
    else if (iDiff >= 3 )
    {
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        //判断是否为闰年
        NSInteger dayCount;
        if ((year%4==0 && year %100 !=0) || year%400==0) {
            dayCount = 366;
        }else {
            dayCount = 365;
        }

        NSInteger time= timeOld/60/60/24/dayCount  +1970;
        if (time!=[dateComponent year])
        {
            [dateFormater setDateFormat:@"YYYY年M月d日 HH:mm"];
            
        }
        else
        {
            [dateFormater setDateFormat:@"M月d日 HH:mm"];
        }
    }
    return [dateFormater  stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeOld]];
}


/**
 *  截取时间为年-月-日
 */
+ (NSString *)subTime:(NSString *)time
{
    if (time.length >= 10)
    {
        NSString *subtime = [time substringToIndex:10];
        return subtime;
    }
    
    return time;
}

/**
 *  根据时间格式字符串，转换为年-月-日
 */
+ (NSString *)getFormatDateStrFromTime:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:DateAndTimeFormat];
    
    //得到系统时间
    NSDate *formatDate = [formatter dateFromString:timeStr];
    
//    //把GMT时间转化为北京时区时间
//    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
//    [formatter setTimeZone:timeZone];
//    NSInteger interval = [timeZone secondsFromGMTForDate:formatDate];
//    NSDate *localDate = [formatDate dateByAddingTimeInterval:interval];
    
    [formatter setDateFormat:OnlyDateFormat];
    
    NSString *formatResultTime = [formatter stringFromDate:formatDate];
    
    return formatResultTime;
}

/**
 *  根据时间格式字符串，转换为对应时间格式
 */
+ (NSString *)getFormatDateStrFromTime:(NSString *)timeStr DateFormat:(NSString *)dateFormat
{
    NSString *subTimeStr = @"";
    if ([timeStr rangeOfString:@"."].location !=NSNotFound) {
        NSRange range = [timeStr rangeOfString:@"."];
        
        subTimeStr = [timeStr substringToIndex:range.location];
        
      //  subTimeStr  = [timeStr substringWithRange:NSMakeRange(0, timeStr.length -3)];
    }else{
        subTimeStr = timeStr;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:DateAndTimeFormat];
    
    //得到系统时间
    NSDate *formatDate = [formatter dateFromString:subTimeStr];

    [formatter setDateFormat:dateFormat];
    
    NSString *formatResultTime = [formatter stringFromDate:formatDate];
    
    return formatResultTime?formatResultTime:@"";
}

/**
 *  获取当前日期-时间-星期（新增外出）
 */
+(NSString *)getSystemTime
{
    //获取星期
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    now = [NSDate date];
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSArray * arrWeek=[NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:YearToMinFormat];
    NSString *currentDateStr = [ dateFormatter stringFromDate:now];
    
    return [NSString stringWithFormat:@"%@ %@",currentDateStr,[arrWeek objectAtIndex:[comps weekday]-1]];
  
}

/// 获取当前时间戳
+ (NSInteger)getCurrentTimeInterval
{
    return [[NSDate date] timeIntervalSince1970] * 1000;
}

/**
 *  获取带星期的日期 YYYY-MM-dd 星期
 *
 */
+(NSString *)getFormatWeekDateStrFromTime:(NSString *)timeStr DateFormat:(NSString *)dateFormat
{
    //获取星期
    NSString *subTimeStr = @"";
    if ([timeStr rangeOfString:@"."].location !=NSNotFound) {
        
        NSRange range = [timeStr rangeOfString:@"."];
        
        subTimeStr = [timeStr substringToIndex:range.location];
    
    }else{
        subTimeStr = timeStr;
    }
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:DateAndTimeFormat];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    now = [formatter dateFromString:subTimeStr];
    comps = [calendar components:unitFlags fromDate:[formatter dateFromString:subTimeStr]];
    NSArray * arrWeek=[NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *currentDateStr = [ dateFormatter stringFromDate:now];
    
    return [NSString stringWithFormat:@"%@ %@",currentDateStr,[arrWeek objectAtIndex:[comps weekday]-1]];
}

/*
 *  根据时间格式字符串，转换为年-月-日 时-分-秒
 */
+ (NSString *)getDetailedFormatDateStrFromTime:(NSString *)timeStr
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:DateAndTimeFormat];
    
    //得到系统时间
    NSDate *formatDate = [formatter dateFromString:timeStr];

    [formatter setDateFormat:CompleteFormat];
    
    NSString *formatResultTime = [formatter stringFromDate:formatDate];
    
    return formatResultTime;
}

/**
 *  根据NSDate格式，转成yyyy年MM月dd日(签到记录时间控件)
 */
+ (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

/**
 *  获取系统时间根据自定义格式
 */
+ (NSString *)getSysDateStrWithFormat:(NSString *)formatStr
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:formatStr];
    
    NSDate *sysDate = [NSDate date];
    
    NSString *localDateStr = [formatter stringFromDate:sysDate];
    
    return localDateStr;
}

/**
 *  根据NSDate转换为时间格式字符串 YYYY-MM-dd
 */
+ (NSString *)formatDateStrFromDate:(NSDate *)timeDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:OnlyDateFormat];
    NSString *dateString = [dateFormatter stringFromDate:timeDate];
    
    return dateString;
}

/// 计算当前时间差（约/带看不得早于或等于当前时间、 提醒不得早于或等于当前时间）
+ (double)compareCurrentTime:(NSString *)timeStr andFormat:(NSString *)formatter
{
    // 把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSDate *timeDate = [dateFormatter dateFromString:timeStr];
    
    // 得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    return timeInterval;
}

/**
// *  字符串转字典
// *
// *  @param jsonString
// *
// *  @return 转换后的字典
// */
//+ (NSDictionary *)getDicWithJsonString:(NSString *)jsonString
//{
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *jsonDic;
//    
//    if (jsonData) {
//        jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                  options:NSJSONReadingMutableContainers
//                                                    error:nil];
//    }
//    
//    return jsonDic;
//}

/**
 *  实体转为字典对象
 */
+ (NSDictionary *) entityToDictionary:(id)entity
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    
    objc_property_t *props = class_copyPropertyList([entity class], &propsCount);
    
    for(int i = 0;i < propsCount; i++) {
        
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [entity valueForKey:propName];
        if(value == nil) {
            
            value = [NSNull null];
        } else {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    
    return dic;
}

+ (id)getObjectInternal:(id)obj {
    
    if([obj isKindOfClass:[NSString class]]
       ||
       [obj isKindOfClass:[NSNumber class]]
       ||
       [obj isKindOfClass:[NSNull class]]) {
        
        return obj;
        
    }
    if([obj isKindOfClass:[NSArray class]]) {
        
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0; i < objarr.count; i++) {
            
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys) {
            
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self entityToDictionary:obj];
    
}


/**
 压缩图片
 */
+ (NSData *)compressImage:(UIImage *)image
            compressRatio:(CGFloat)ratio
         maxCompressRatio:(CGFloat)maxRatio
            andIsPanorama:(BOOL)isPanorama
{
    
    int MIN_UPLOAD_RESOLUTION = 2000 * 2000;
//    int MAX_UPLOAD_SIZE = 800 * 1024;
    int MAX_UPLOAD_SIZE = 1024 * 1024;

    if (isPanorama) {
        MAX_UPLOAD_SIZE = (3 * 1024) * 1024;
    }
    
    float factor;
    float currentResolution = image.size.height * image.size.width;
    
    NSData *imageData ;
    
    
    if ([CityCodeVersion isTianJin]) {
        // 天津全景图不做尺寸剪裁
        if (!isPanorama){
            if (currentResolution > MIN_UPLOAD_RESOLUTION){
                
                factor = sqrt(currentResolution / MIN_UPLOAD_RESOLUTION) * 2;
                image = [self scaleDown:image withSize:CGSizeMake(image.size.width / factor, image.size.height / factor)];
            }
            
             imageData = UIImagePNGRepresentation(image);
       
        }else{
            
            imageData = UIImageJPEGRepresentation(image, 1);
        }
    
    }else{
        
        imageData = UIImagePNGRepresentation(image);
        
        // 其他城市正常剪裁
        if (currentResolution > MIN_UPLOAD_RESOLUTION) {
            factor = sqrt(currentResolution / MIN_UPLOAD_RESOLUTION) * 2;
            image = [self scaleDown:image withSize:CGSizeMake(image.size.width / factor, image.size.height / factor)];
        }
    }
   

    CGFloat compression = ratio;
    
    while ([imageData length] > MAX_UPLOAD_SIZE && compression > 0) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }

    NSLog(@"last  [imageData length] = %ld compression = %f",[imageData length],compression);

    return imageData;
}

+ (UIImage*)scaleDown:(UIImage*)image withSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/**
 *  保存图片到document目录下，为上传图片提供路径
 */
+ (void)saveImageToDoc:(UIImage *)tempImage
             withName:(NSString *)imageName
         andIsPanorama:(BOOL)isPanorama
{
    
    NSData *tempImageData = [CommonMethod compressImage:tempImage
                                          compressRatio:1
                                       maxCompressRatio:0.7
                                          andIsPanorama:isPanorama];
    
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);
    NSString *documentFilePath = [filePaths objectAtIndex:0];
    
    NSString *fullPathOfFile = [NSString stringWithFormat:@"%@/%@",
                                documentFilePath,
                                imageName];
    
    NSDictionary *dic = @{
                          @"imageData":tempImageData
                          };
    
    [dic writeToFile:fullPathOfFile
                    atomically:NO];
    
}

/**
 *  删除document下指定name图片
 */
+ (void)deleteImageFromDocWithName:(NSString *)imageName
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    BOOL isFileExit = [[NSFileManager defaultManager] fileExistsAtPath:imageName];
    
    if (isFileExit) {
    
        [fileManager removeItemAtPath:imageName
                                error:nil];
    }else {
        
        return;
    }
}

/**
 *  获取本地图片路径
 */
+ (NSString *)getImageFromDocWithName:(NSString *)imageName
{
    
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);
    
    NSString *documentFilePath = [filePaths objectAtIndex:0];
    
    NSString *fullPathOfFile = [NSString stringWithFormat:@"%@/%@",
                                documentFilePath,imageName];
    
    return fullPathOfFile;
}


/**
 *   分享房源
 
 *   房源keyid
 *   String keyId;
 
 *   经纪人头像图片
 *   String img;
 
 *   经纪人电话
 *   String tel;
 
 *   经纪人姓名
 *   String user;
 
 *   经纪人所在的部门名称
 *   String dept;
 */
+ (NSString *)getPropDetailShareLinkWithKeyId:(NSString *)propKeyId
{
    
    IdentifyEntity *entity = [AgencyUserPermisstionUtil getIdentify];

    NSString *keyIdStr = [NSString stringWithFormat:@"?keyid=%@",propKeyId];
    
    
    NSString *corporationKeyId = [NSString stringWithFormat:@"&corporationKeyId=%@",FINAL_CORPORATION_KEY_ID];
    
    //经纪人头像
//    NSString *staffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
//    NSString *staffImageStr = [NSString stringWithFormat:@"&img=%@",
//                               [[BaseApiDomainUtil getApiDomain] getStaffPhotoUrlWithStaffNo:staffNo]];
    //陈行修改，此处用户头像链接更换为新的获取方式
    NSString *staffImageStr = [NSString stringWithFormat:@"&img=%@", [CommonMethod getUserdefaultWithKey:APlusUserPhotoPath]];
    
    //经纪人电话
    NSString *staffMobile = [NSString stringWithFormat:@"&tel=%@",
                             [[NSUserDefaults standardUserDefaults]stringForKey:APlusUserMobile]];
    
    //经纪人姓名
    NSString *staffName = [NSString stringWithFormat:@"&user=%@",
                           entity.uName];
    
    //经纪人所在部门
    NSString *deptName = [NSString stringWithFormat:@"&dept=%@",
                          entity.departName];
    
    NSString *SharePropDetailUrl = [NSString stringWithFormat:@"%@/home/share",NewBaseUrl];
    NSString *newSharePropDetailUrl = SharePropDetailUrl;
    
    
    NSString *shareLink = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                           newSharePropDetailUrl,
                           keyIdStr,
                           corporationKeyId,
                           staffImageStr,
                           staffMobile,
                           staffName,
                           deptName];
    
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                     (CFStringRef)shareLink,
                                                                                                     NULL,
                                                                                                     NULL,
                                                                                                     kCFStringEncodingUTF8));
    
    return encodedString;
}

+ (BOOL)isMobile:(NSString *)mobile
{
//    NSString *regex = @"^[1][34578][0-9]{9}$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isMatch = [pred evaluateWithObject:mobile];
//    return isMatch;
    
    NSString *mobileRegex = @"^1[3-9][0-9]\\d{8}$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [regextestcm evaluateWithObject:mobile];
}


+ (BOOL)mobileHaveProperLength:(NSString *)mobile
{
    if (mobile.length < 7 || mobile.length > 11) {
        return NO;
    }
    return YES;
}



//验证是否含有特殊字符
+ (BOOL)isUniqueStr:(NSString *)uniqueStr{
    NSString *regex = @"[^%&',;=?$\x22]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:uniqueStr];
    return isMatch;

}

+ (BOOL)validateNumber:(NSString *)textString
{
    NSString* number=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}


#pragma mark - 对融云 APP Secret、Nonce、Timestamp 进行SHA1哈希计算

+ (NSString *)getSHA1WithStringWithSecret:(NSString *)appSecret
                                andNonce:(NSString *)nonce
                            andTimestamp:(NSString *)timesTamp
{
    NSString *resultStr = [NSString stringWithFormat:@"%@%@%@",appSecret,nonce,timesTamp];
    
    const char *cstr = [resultStr cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:resultStr.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_LONG dataLength = (CC_LONG)data.length;
    
    CC_SHA1(data.bytes, dataLength, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

#pragma mark - 注册/取消 推送通知
+ (void)registPushWithState:(BOOL)isRegistPush
{
    
    if (isRegistPush) {
        
        /**
         *  接收融云消息推送
         */
        [[RCIM sharedRCIM] setDisableMessageAlertSound:NO];
        [[RCIM sharedRCIM] setDisableMessageNotificaiton:NO];
        
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |
                                                        UIUserNotificationTypeAlert)
                                                  categories:nil];
       
        
    }else{
        
        /**
         *  关闭远程推送
         */
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        /*
         *  关闭jpush推送
         */
        [JPUSHService clearAllLocalNotifications];
        
        NSLog(@"关闭jpush推送");
        
        /**
         *  关闭融云本地、远程推送
         */
        [[RCIM sharedRCIM] setDisableMessageAlertSound:YES];
        [[RCIM sharedRCIM] setDisableMessageNotificaiton:YES];
    }
}


/*
 *设置图片（判断是否是只在wifi下显示图片）
 *
 */
+ (void)setImageWithImageView:(UIImageView *)imageView
                 andImageUrl:(NSString *)imageUrl
     andPlaceholderImageName:(NSString *)placeholderImageName
{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    int curNetworkStatus = appDelegate.currentNetworkStatus;
    
    SDWebImageManager *sdImageManager = [SDWebImageManager sharedManager];
    
    /**
     *  检查当前图片有没有缓存
     */
//    BOOL isExistCurImg = [sdImageManager cachedImageExistsForURL:[NSURL URLWithString:imageUrl]];
    
    __block BOOL isExistCurImg;
    [sdImageManager cachedImageExistsForURL:[NSURL URLWithString:imageUrl] completion:^(BOOL isInCache) {
        isExistCurImg = isInCache;
    }];
    
    
    /**
     *  是否开启了“只在wifi显示图片”开关
     */
    BOOL onlyWifiShowImg = [[NSUserDefaults standardUserDefaults]boolForKey:ShowImageOnlyWIFI];
    
    
    switch (curNetworkStatus) {
        case NotReachable:
        {
            //无网络
            
            if (isExistCurImg) {
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                             placeholderImage:[UIImage imageNamed:placeholderImageName]];
            }else{
                
                [imageView setImage:[UIImage imageNamed:placeholderImageName]];
            }
        }
            break;
        case ReachableViaWiFi:
        {
            //wifi网络
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                         placeholderImage:[UIImage imageNamed:placeholderImageName]];
        }
            break;
        case ReachableViaWWAN:
        {
            //蜂窝数据
            
            if (isExistCurImg) {
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                             placeholderImage:[UIImage imageNamed:placeholderImageName]];
            }else{
                
                if (!onlyWifiShowImg) {
                    
                    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                                 placeholderImage:[UIImage imageNamed:placeholderImageName]];
                }else{
                    
                    [imageView setImage:[UIImage imageNamed:placeholderImageName]];
                }
            }
        }
            break;
            
        default:
        {
            
            [imageView setImage:[UIImage imageNamed:placeholderImageName]];
        }
            break;
    }
    
}

+ (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if (error)
                                                         {
                                                             NSLog(@"Error: %@", (__bridge NSError *)error);
                                                         }
                                                         else if (!granted)
                                                         {
                                                             block(NO);
                                                         }
                                                         else
                                                         {
                                                             block(YES);
                                                         }
                                                     });
                                                 });
    }
    else
    {
        block(YES);
    }
    
}

/**
 *  计算不同尺寸控件在不同屏幕下的比例
 */
+ (CGFloat)calculateLengthFromMultipleScreenSizeWithLength:(CGFloat)length
{
    
    //不同屏幕下的比例
    CGFloat multipleRate = (APP_SCREEN_WIDTH-320)/320;
    
    //不同屏幕尺寸下相差的大小
    CGFloat multipleDifferLength = (multipleRate * length)/2;
    
    return length + multipleDifferLength;
}

/**
 *  当前设备是否是iPhone6尺寸
 */
+ (BOOL)is4_7InchScreen
{
    
    CGFloat screenWidth = [[UIScreen mainScreen]bounds].size.width;
    
    if (screenWidth == 375) {
        
        return YES;
    }
    
    return NO;
}

/**
 *  当前设备是否是iPhone6plus尺寸或更大
 */
+ (BOOL)is5InchScreen
{
    
    CGFloat screenWidth = [[UIScreen mainScreen]bounds].size.width;
    
    if (screenWidth >= 414) {
        
        return YES;
    }
    
    return NO;
}

/// 添加百度统计自定义事件
+(void)addLogEventWithEventId:(NSString *)eventId
                 andEventDesc:(NSString *)eventDesc
{
    BaiduMobStat *baiduMobStat;
    if (!baiduMobStat) {
        baiduMobStat = [BaiduMobStat defaultStat];
    }


    [baiduMobStat logEvent:eventId eventLabel:eventDesc];
}

/// 是否使用新的APi地址(第二版)
+ (BOOL)isRequestNewApiAddress
{
     return YES; // LJS
    
    if ([CityCodeVersion isGuangZhou]
        || [CityCodeVersion isChangSha]
        || [CityCodeVersion isHangZhou]

        || [self isRequestFinalApiAddress])
    {
        return YES;
    }
    return NO;
}

/// 是否使用新的APi地址(最终版)
+ (BOOL)isRequestFinalApiAddress
{
    return YES; // LJS
    
    
}

// 是否使用2.0界面
+ (BOOL)isLoadNewView
{
    if ([CityCodeVersion isTianJin])
    {
        return YES;
    }

    return NO;
}

// 拨打电话
+ (void)callTelWithNumber:(NSString *)number
{
    NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

/**
 *
 * 键盘收起
 *
 **/
+ (void)resignFirstResponder{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}

/**
 *
 * 计算行数
 *
 **/
+ (NSInteger)getRowNumWithSunCount:(NSInteger)sumCount
                     andEachRowNum:(NSInteger)eachRowNum
{
    NSInteger result1 = sumCount % eachRowNum;
    NSInteger result2 = sumCount / eachRowNum;
    NSInteger rowCount = (result1 == 0 ) ? result2 : result2 + 1;

    return rowCount;
}



@end
