//
//  AppTools.m
//  Decoration
//
//  Created by 辛凯 on 15/7/21.
//  Copyright (c) 2015年 辛凯. All rights reserved.
//

#import "AppTools.h"

@interface AppTools()

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, weak) id<UIAlertViewDelegate> alertViewDelegate;

@end

@implementation AppTools

+ (AppTools *)SharedManager
{
    static AppTools *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppTools alloc] init];
    });
    return manager;
}

+ (NSDateFormatter*)DateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    return formatter;
}

+ (NSDateFormatter*)DateFormatterOnlyDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    return formatter;
}

+ (NSString *)getDateStringWithFormat:(NSString *)format date:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    return [formatter stringFromDate:date];
}

+ (int)intervalWithStartTime:(NSString *)startTime stopTime:(NSString *)stopTime
{
    NSString *nStartTime = [NSString stringWithFormat:@"%@ %@",[startTime substringToIndex:10], @"00:00:00"];
    NSString *nStopTime = [NSString stringWithFormat:@"%@ %@", [stopTime substringToIndex:10], @"00:00:00"];
    NSTimeInterval timeInterval = [[[AppTools DateFormatter] dateFromString:nStartTime] timeIntervalSinceDate:[[AppTools DateFormatter] dateFromString:nStopTime]];
    int days = ((int)timeInterval)/(3600 * 24);
    return days;
}

+ (NSInteger)geySecondFordays:(NSString *)startTime stopTime:(NSString *)stopTime
{
    NSString *nStartTime = [NSString stringWithFormat:@"%@ %@",[startTime substringToIndex:10], @"00:00:00"];
    NSTimeInterval timeInterval = [[[AppTools DateFormatter] dateFromString:nStartTime] timeIntervalSinceDate:[[AppTools DateFormatter] dateFromString:stopTime]];
    NSInteger second = (NSInteger)timeInterval;
    return second;
}

+ (NSInteger)getAge:(NSDate *)fromDate
{
    if (!fromDate) {
        return 0;
    }
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:fromDate toDate:now options:0];
    return [comps year];
}

+ (NSString*)TimeStamp
{
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

//根据date换算时间戳
+ (NSString*)getTimeStamp:(NSDate *)date
{
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    // *1000,是精确到毫秒；这里是精确到秒;
    NSString *result = [NSString stringWithFormat:@"%.0f",timeInterval];
    return result;
}
//根据时间戳换算时间string
+ (NSString*)getTimeString:(NSString *)timeStamp
{
    NSTimeInterval intDerval = [timeStamp doubleValue];
    NSDate * end_timeDate = [NSDate dateWithTimeIntervalSince1970:intDerval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * end_timedateString = [formatter stringFromDate:end_timeDate];
    return end_timedateString;
}

//根据时间戳换算时间string
+ (NSString*)getZHTimeString:(NSString *)timeStamp
{
    NSTimeInterval intDerval = [timeStamp doubleValue];
    NSDate * end_timeDate = [NSDate dateWithTimeIntervalSince1970:intDerval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString * end_timedateString = [formatter stringFromDate:end_timeDate];
    return end_timedateString;
}

//根据时间戳换算时间string
+ (NSString*)getYMDHMSTimeString:(NSString *)timeStamp
{
    NSTimeInterval intDerval = [timeStamp doubleValue];
    NSDate * end_timeDate = [NSDate dateWithTimeIntervalSince1970:intDerval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * end_timedateString = [formatter stringFromDate:end_timeDate];
    return end_timedateString;
}



+ (CGSize)stringSizeWithText:(NSString *)str font:(UIFont *)font mode:(NSLineBreakMode)mode width:(CGFloat)width
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
    return [str sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:mode];
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    NSDictionary *attribute = @{NSFontAttributeName: font};
    return [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
#endif
}

+ (BOOL)stringContainsEmoji:(NSString *)str
{
    __block BOOL returnValue = NO;
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return  returnValue;
}

+ (BOOL)validatePhone:(NSString *)phone
{
    //手机号以13，15，17，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,5-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

+ (BOOL)verifyIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd     = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year     = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area     = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex    = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    NSInteger summary = ([value substringWithRange:NSMakeRange(0, 1)].intValue + [value substringWithRange:NSMakeRange(10, 1)].intValue) * 7
    + ([value substringWithRange:NSMakeRange(1, 1)].intValue + [value substringWithRange:NSMakeRange(11, 1)].intValue) * 9
    + ([value substringWithRange:NSMakeRange(2, 1)].intValue + [value substringWithRange:NSMakeRange(12, 1)].intValue) * 10
    + ([value substringWithRange:NSMakeRange(3, 1)].intValue + [value substringWithRange:NSMakeRange(13, 1)].intValue) * 5
    + ([value substringWithRange:NSMakeRange(4, 1)].intValue + [value substringWithRange:NSMakeRange(14, 1)].intValue) * 8
    + ([value substringWithRange:NSMakeRange(5, 1)].intValue + [value substringWithRange:NSMakeRange(15, 1)].intValue) * 4
    + ([value substringWithRange:NSMakeRange(6, 1)].intValue + [value substringWithRange:NSMakeRange(16, 1)].intValue) * 2
    + [value substringWithRange:NSMakeRange(7, 1)].intValue * 1 + [value substringWithRange:NSMakeRange(8, 1)].intValue * 6
    + [value substringWithRange:NSMakeRange(9, 1)].intValue * 3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder, 1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17, 1)] uppercaseString]];
}

#pragma mark UIAlertViewDelegate
- (void)showAlertWithTitle:(NSString*)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelStr otherButtonTitles:(NSString*)otherStr
{
    [self hiddenAlert];
    if(!self.alertView){
        self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelStr otherButtonTitles:otherStr, nil];
    }
    [self.alertView show];
}

- (void)setAlertDelegate:(id)obj
{
    self.alertViewDelegate = obj;
    if (self.alertView) {
        self.alertView.delegate = obj;
    }
}

- (void)setAlertTag:(int)tag
{
    if (self.alertView) {
        self.alertView.tag = tag;
    }
}

- (void)showAlert:(NSString*)message
{
    [self showAlertWithTitle:nil message:message delegate:self.alertViewDelegate cancelButtonTitle:nil otherButtonTitles:@"确定"];
}

- (void)showAlert:(NSString*)message withSigleButton:(NSString*)buttonTitle
{
    [self showAlertWithTitle:nil message:message delegate:self.alertViewDelegate cancelButtonTitle:nil otherButtonTitles:buttonTitle];
}

- (void)showAlertWithoutButtons:(NSString *)message
{
    [self showAlertWithTitle:nil message:message delegate:self.alertViewDelegate cancelButtonTitle:nil otherButtonTitles:nil];
}

- (void)hiddenAlert
{
    if (self.alertView) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
        [self removeAlert];
    }
}

- (void)removeAlert
{
    self.alertView = nil;
}
// 根据颜色生成一张纯色图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
// 判断手机型号
+ (UIDeviceResolution)currentResolution
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            if (result.height <= 480.0f)
                return UIDevice_iPhoneStandardRes;
            return (result.height > 960 ? UIDevice_iPhoneTallerHiRes : UIDevice_iPhoneHiRes);
        } else
            return UIDevice_iPhoneStandardRes;
    } else
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
}

+ (BOOL)isRunningOniPhone5
{
    if ([self currentResolution] == UIDevice_iPhoneTallerHiRes) {
        return YES;
    }
    return NO;
}

+ (BOOL)isRunningOniPhone
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (BOOL)isNewVersionAppFirstRun
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *strVersion = [defaults valueForKey:@"versions"];
    NSLog(@"loginversion : %@", strVersion);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (strVersion == nil || (![strVersion isEqualToString:app_Version])) {
        [defaults setValue:app_Version forKey:@"versions"];
        [defaults synchronize];
        return YES;
    }
    return NO;
}

+ (NSString *)nameWithDate
{
    NSDateFormatter *formatter = [AppTools DateFormatter];
    NSDate *date = [NSDate date];
    NSString *dateStr = [[formatter stringFromDate:date] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *fileName = [[dateStr stringByReplacingOccurrencesOfString:@":" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return fileName;
}

#pragma mark documents
+ (NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (void)createFilePathWithName:(NSString *)name
{
    NSString *documentsDirectory = [AppTools documentPath];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:name];
    if (![fileManage fileExistsAtPath:myDirectory]) {
        NSError *error;
        BOOL isOK = [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:NO attributes:nil error:&error];
        if (!isOK) {
            NSLog(@"%@", error);
        }
    }
}
#pragma mark caches
+ (NSString *)cachesPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)filePathCaches:(NSString *)fileName
{
    return [[AppTools cachesPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
}

+ (BOOL)isExistFileInCache:(NSString *)fileName
{
    NSString *filePath = [self filePathCaches:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }else {
        return NO;
    }
}

+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (float)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0 * 1024.0);
}

+ (void)cleanCaches
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager subpathsAtPath:[AppTools cachesPath]];
    NSLog(@"文件列表:%@",files);
    [fileManager changeCurrentDirectoryPath:[[AppTools cachesPath] stringByExpandingTildeInPath]];
    for (int i = 0; i < [files count]; i++) {
        [fileManager removeItemAtPath:[files objectAtIndex:i] error:nil];
    }
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame
                    secureTextEntry:(BOOL)entry
                    backgroundColor:(UIColor *)backgroundColor
                        placeholder:(NSString *)placeholder
                          textColor:(UIColor *)textColor
                           fontSize:(CGFloat)font
                   leftViewIconName:(NSString *)iconName
                      returnKeyType:(UIReturnKeyType)keyType
{
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = frame;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.secureTextEntry = entry;
    textField.backgroundColor = backgroundColor;
    textField.placeholder = placeholder;
    textField.textColor = textColor;
    textField.font = [UIFont systemFontOfSize:font];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = keyType;
    if (iconName) {
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
        icon.frame = CGRectMake(0, 0, 50, frame.size.height);
        icon.contentMode = UIViewContentModeCenter;
        textField.leftView = icon;
        textField.leftViewMode = UITextFieldViewModeAlways;
    } else {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, 10, frame.size.height);
        textField.leftView = view;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return textField;
}

+ (NSString *)verifyDictionaryWithDic:(NSDictionary *)dic key:(NSString *)key
{
    if (![[dic objectForKey:key] isEqual:[NSNull null]]) {
        return [NSString stringWithFormat:@"%@", [dic objectForKey:key]];
    }
    return @"";
}

+ (NSString *)verifyStringWithString:(NSString *)string
{
    if (string.length == 0) {
        return @"暂无";
    }
    return string;
}

+ (NSArray *)sleepUPImage
{
    UIImage * imageDown1 = [UIImage imageNamed:@"sleepDown1"];
    UIImage * imageDown2 = [UIImage imageNamed:@"sleepDown2"];
    UIImage * imageDown3 = [UIImage imageNamed:@"sleepDown3"];
    UIImage * imageDown4 = [UIImage imageNamed:@"sleepDown4"];
    UIImage * imageDown5 = [UIImage imageNamed:@"sleepDown5"];
    UIImage * imageDown6 = [UIImage imageNamed:@"sleepDown6"];
    UIImage * imageDown7 = [UIImage imageNamed:@"sleepDown7"];
    UIImage * imageDown8 = [UIImage imageNamed:@"sleepDown8"];
    UIImage * imageDown9 = [UIImage imageNamed:@"sleepDown9"];
    UIImage * imageDown10 = [UIImage imageNamed:@"sleepDown10"];
    UIImage * imageDown11 = [UIImage imageNamed:@"sleepDown11"];
    UIImage * imageDown12 = [UIImage imageNamed:@"sleepDown12"];
    UIImage * imageDown13 = [UIImage imageNamed:@"sleepDown13"];
    UIImage * imageDown14 = [UIImage imageNamed:@"sleepDown14"];
    UIImage * imageDown15 = [UIImage imageNamed:@"sleepDown15"];
    UIImage * imageDown16 = [UIImage imageNamed:@"sleepDown16"];
    UIImage * imageDown17 = [UIImage imageNamed:@"sleepDown17"];
    UIImage * imageDown18 = [UIImage imageNamed:@"sleepDown18"];
    UIImage * imageDown19 = [UIImage imageNamed:@"sleepDown19"];
    UIImage * imageDown20 = [UIImage imageNamed:@"sleepDown20"];
    UIImage * imageDown21 = [UIImage imageNamed:@"sleepDown21"];
    UIImage * imageDown22 = [UIImage imageNamed:@"sleepDown22"];
    UIImage * imageDown23 = [UIImage imageNamed:@"sleepDown23"];
    UIImage * imageDown24 = [UIImage imageNamed:@"sleepDown24"];
    UIImage * imageDown25 = [UIImage imageNamed:@"sleepDown25"];
    UIImage * imageDown26 = [UIImage imageNamed:@"sleepDown26"];
    UIImage * imageDown27 = [UIImage imageNamed:@"sleepDown27"];
    UIImage * imageDown28 = [UIImage imageNamed:@"sleepDown28"];
    UIImage * imageDown29 = [UIImage imageNamed:@"sleepDown29"];
    UIImage * imageDown30 = [UIImage imageNamed:@"sleepDown30"];
    UIImage * imageDown31 = [UIImage imageNamed:@"sleepDown31"];
    UIImage * imageDown32 = [UIImage imageNamed:@"sleepDown32"];
    UIImage * imageDown33 = [UIImage imageNamed:@"sleepDown33"];
    UIImage * imageDown34 = [UIImage imageNamed:@"sleepDown34"];
    UIImage * imageDown35 = [UIImage imageNamed:@"sleepDown35"];
    UIImage * imageDown36 = [UIImage imageNamed:@"sleepDown36"];
    UIImage * imageDown37 = [UIImage imageNamed:@"sleepDown37"];
    UIImage * imageDown38 = [UIImage imageNamed:@"sleepDown38"];
    UIImage * imageDown39 = [UIImage imageNamed:@"sleepDown39"];
    UIImage * imageDown40 = [UIImage imageNamed:@"sleepDown40"];
    UIImage * imageDown41 = [UIImage imageNamed:@"sleepDown41"];
    UIImage * imageDown42 = [UIImage imageNamed:@"sleepDown42"];
    UIImage * imageDown43 = [UIImage imageNamed:@"sleepDown43"];
    UIImage * imageDown44 = [UIImage imageNamed:@"sleepDown44"];
    UIImage * imageDown45 = [UIImage imageNamed:@"sleepDown45"];
    UIImage * imageDown46 = [UIImage imageNamed:@"sleepDown46"];
    UIImage * imageDown47 = [UIImage imageNamed:@"sleepDown47"];
    UIImage * imageDown48 = [UIImage imageNamed:@"sleepDown48"];
    UIImage * imageDown49 = [UIImage imageNamed:@"sleepDown49"];
    UIImage * imageDown50 = [UIImage imageNamed:@"sleepDown50"];
    NSArray * downImageViewArr = [NSArray arrayWithObjects:imageDown1,imageDown2,imageDown3,imageDown4,imageDown5,imageDown6,imageDown7,imageDown8,imageDown9,imageDown10,imageDown11,imageDown12,imageDown13,imageDown14,imageDown15,imageDown16,imageDown17,imageDown18,imageDown19,imageDown20,imageDown21,imageDown22,imageDown23,imageDown24,imageDown25,imageDown26,imageDown27,imageDown28,imageDown29,imageDown30,imageDown31,imageDown32,imageDown33,imageDown34,imageDown35,imageDown36,imageDown37,imageDown38,imageDown39,imageDown40,imageDown41,imageDown42,imageDown43,imageDown44,imageDown45,imageDown46,imageDown47,imageDown48,imageDown49,imageDown50,nil];
    return downImageViewArr;
}

+ (NSArray *)sleepDownImage
{
    UIImage * image1 = [UIImage imageNamed:@"sleep1"];
    UIImage * image2 = [UIImage imageNamed:@"sleep2"];
    UIImage * image3 = [UIImage imageNamed:@"sleep3"];
    UIImage * image4 = [UIImage imageNamed:@"sleep4"];
    UIImage * image5 = [UIImage imageNamed:@"sleep5"];
    UIImage * image6 = [UIImage imageNamed:@"sleep6"];
    UIImage * image7 = [UIImage imageNamed:@"sleep7"];
    UIImage * image8 = [UIImage imageNamed:@"sleep8"];
    UIImage * image9 = [UIImage imageNamed:@"sleep9"];
    UIImage * image10 = [UIImage imageNamed:@"sleep10"];
    UIImage * image11 = [UIImage imageNamed:@"sleep11"];
    UIImage * image12 = [UIImage imageNamed:@"sleep12"];
    UIImage * image13 = [UIImage imageNamed:@"sleep13"];
    UIImage * image14 = [UIImage imageNamed:@"sleep14"];
    UIImage * image15 = [UIImage imageNamed:@"sleep15"];
    UIImage * image16 = [UIImage imageNamed:@"sleep16"];
    UIImage * image17 = [UIImage imageNamed:@"sleep17"];
    UIImage * image18 = [UIImage imageNamed:@"sleep18"];
    UIImage * image19 = [UIImage imageNamed:@"sleep19"];
    UIImage * image20 = [UIImage imageNamed:@"sleep20"];
    UIImage * image21 = [UIImage imageNamed:@"sleep21"];
    UIImage * image22 = [UIImage imageNamed:@"sleep22"];
    UIImage * image23 = [UIImage imageNamed:@"sleep23"];
    UIImage * image24 = [UIImage imageNamed:@"sleep24"];
    UIImage * image25 = [UIImage imageNamed:@"sleep25"];
    UIImage * image26 = [UIImage imageNamed:@"sleep26"];
    UIImage * image27 = [UIImage imageNamed:@"sleep27"];
    UIImage * image28 = [UIImage imageNamed:@"sleep28"];
    UIImage * image29 = [UIImage imageNamed:@"sleep29"];
    UIImage * image30 = [UIImage imageNamed:@"sleep30"];
    UIImage * image31 = [UIImage imageNamed:@"sleep31"];
    UIImage * image32 = [UIImage imageNamed:@"sleep32"];
    UIImage * image33 = [UIImage imageNamed:@"sleep33"];
    UIImage * image34 = [UIImage imageNamed:@"sleep34"];
    UIImage * image35 = [UIImage imageNamed:@"sleep35"];
    UIImage * image36 = [UIImage imageNamed:@"sleep36"];
    UIImage * image37 = [UIImage imageNamed:@"sleep37"];
    UIImage * image38 = [UIImage imageNamed:@"sleep38"];
    UIImage * image39 = [UIImage imageNamed:@"sleep39"];
    UIImage * image40 = [UIImage imageNamed:@"sleep40"];
    UIImage * image41 = [UIImage imageNamed:@"sleep41"];
    UIImage * image42 = [UIImage imageNamed:@"sleep42"];
    UIImage * image43 = [UIImage imageNamed:@"sleep43"];
    UIImage * image44 = [UIImage imageNamed:@"sleep44"];
    UIImage * image45 = [UIImage imageNamed:@"sleep45"];
    UIImage * image46 = [UIImage imageNamed:@"sleep46"];
    UIImage * image47 = [UIImage imageNamed:@"sleep47"];
    UIImage * image48 = [UIImage imageNamed:@"sleep48"];
    UIImage * image49 = [UIImage imageNamed:@"sleep49"];
    UIImage * image50 = [UIImage imageNamed:@"sleep50"];
    
    NSArray * imageViewArr = [NSArray arrayWithObjects:image1,image2,image3,image4,image5,image6,image7,image8,image9,image10,image11,image12,image13,image14,image15,image16,image17,image18,image19,image20,image21,image22,image23,image24,image25,image26,image27,image28,image29,image30,image31,image32,image33,image34,image35,image36,image37,image38,image39,image40,image41,image42,image43,image44,image45,image46,image47,image48,image49,image50,nil];
    return imageViewArr;
}

//时间戳转字符串
+(NSString *)timeStampConversionNSString:(NSString *)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

//时间转时间戳
+(NSString *)dateConversionTimeStamp:(NSDate *)date
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000];
    return timeSp;
}

//字符串转时间
+(NSDate *)nsstringConversionNSDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}


@end
