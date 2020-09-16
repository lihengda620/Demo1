//
//  AppTools.h
//  Decoration
//
//  Created by 辛凯 on 15/7/21.
//  Copyright (c) 2015年 辛凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 环信define
 */
#ifndef ChatDemo_UI2_0_ChatDemoUIDefine_h
#define ChatDemo_UI2_0_ChatDemoUIDefine_h
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#endif
/**
 判断iOS版本
 */
#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define iOS8_OR_LATER NLSystemVersionGreaterOrEqualThan(8.0)
#define iOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)
#define iOS6_OR_LATER NLSystemVersionGreaterOrEqualThan(6.0)
/**
 根据RGB生成颜色
 */
#define ColorWithRGB(R, G, B, A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]
/**
 自定义颜色
 */
#define m_cyanColor  ColorWithRGB(91, 191, 180, 1)
#define m_grayColor  ColorWithRGB(229, 230, 231, 1)
#define m_greenColor ColorWithRGB(61, 189, 133, 1)
#define m_cellColor  ColorWithRGB(220, 219, 222, 1)
/**
 页面大小
 */
#define VIEW_WIDTH  CGRectGetWidth(self.view.frame)
#define VIEW_HEIGHT CGRectGetHeight(self.view.frame)

#define LOGINSUCCESS  @"LoginSuccess"
#define LOGOUTSUCCESS @"LogoutSuccess"
/**
 font = 18
 */
#define FONT_DEFAULT [UIFont systemFontOfSize:18.f]
/**
 font = 16
 */
#define FONT_MIDDLE [UIFont systemFontOfSize:16.f]
/**
 font = 14
 */
#define FONT_SMALL [UIFont systemFontOfSize:14.f]
/**
 font = 12
 */
#define FONT_MINI [UIFont systemFontOfSize:12.f]

#define KEY_WINDOW [[UIApplication sharedApplication] keyWindow]
#define TOP_VIEW [[UIApplication sharedApplication] keyWindow].rootViewController.view
/**
 友盟KEY
 */
#define UMAPPKEY @"55c36213e0f55a6c8b003991"
/**
 键盘弹出时间
 */
#define KEYBOARDSHOWTIME 0.25f
/**
 无缓存加载图片
 */
#define imageWithNameAndType(name, type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]]
/**
 装修易官网
 */
#define MDDURL @"http://www.zhuangxiue.cn"

typedef NS_ENUM(NSInteger, UIDeviceResolution) {
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes      = 1,
    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneHiRes            = 2,
    // iPhone 5 高清分辨率(640x1136px)
    UIDevice_iPhoneTallerHiRes      = 3,
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes        = 4,
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes              = 5
};

@interface AppTools : NSObject

+ (AppTools *)SharedManager;
/**
 *  日期格式
 *
 *  @return 带时间
 */
+ (NSDateFormatter*)DateFormatter;
/**
 *  日期格式
 *
 *  @return 不带时间
 */
+ (NSDateFormatter*)DateFormatterOnlyDate;
/**
 *  根据日期返回字符串
 *
 *  @param format    时间格式
 *  @param TimeStamp 时间
 *
 *  @return 时间字符串
 */
+ (NSString *)getDateStringWithFormat:(NSString *)format date:(NSDate *)date;
/**
 *  时间戳
 *
 *  @return 时间戳
 */
+ (NSString*)TimeStamp;

//根据date换算时间戳
+ (NSString*)getTimeStamp:(NSDate *)date;
//根据时间戳换算时间string
+ (NSString*)getTimeString:(NSString *)timeStamp;
//根据时间戳换算时间string
+ (NSString*)getZHTimeString:(NSString *)timeStamp;
//根据时间戳换算时间string
+ (NSString*)getYMDHMSTimeString:(NSString *)timeStamp;
/**
 *  两个时间相距天数
 *
 *  @param startTime 开始时间
 *  @param stopTime  结束时间
 *
 *  @return 天数
 */
+ (int)intervalWithStartTime:(NSString *)startTime stopTime:(NSString *)stopTime;

/**
 *  两个时间相距秒数
 *
 *  @param startTime 开始时间
 *  @param stopTime  结束时间
 *
 *  @return 秒数
 */
+ (NSInteger)geySecondFordays:(NSString *)startTime stopTime:(NSString *)stopTime;
/**
 *  文字长和高
 *
 *  @param str   需要计算的文字
 *  @param font  文字大小
 *  @param mode  文字格式
 *  @param width 最大宽度
 *
 *  @return 文字的Size
 */
+ (CGSize)stringSizeWithText:(NSString *)str font:(UIFont *)font mode:(NSLineBreakMode)mode width:(CGFloat)width;
/**
 *  获取年龄
 *
 *  @param fromDate 生日
 *
 *  @return 年龄
 */
+ (NSInteger)getAge:(NSDate*)fromDate;
/**
 *  判断当前手机分辨率
 *
 *  @return 分辨率所代表的机型
 */
+ (UIDeviceResolution)currentResolution;
/**
 *  是否在iPhone5上运行
 *
 *  @return 是/否
 */
+ (BOOL)isRunningOniPhone5;
/**
 *  是否在iPhone上运行
 *
 *  @return 是/否
 */
+ (BOOL)isRunningOniPhone;
/**
 *  判断是否存在表情
 *
 *  @param str 需要判断的文字
 *
 *  @return 是/否
 */
+ (BOOL)stringContainsEmoji:(NSString *)str;
/**
 *  判断是否为手机号
 *
 *  @param phone 需要判断的号码
 *
 *  @return 是/否
 */
+ (BOOL)validatePhone:(NSString *)phone;
/**
 *  判断身份证号码
 *
 *  @param value 需要判断的号码
 *
 *  @return 是/否
 */
+ (BOOL)verifyIDCardNumber:(NSString *)value;
/**
 *  自定义弹出框
 *
 *  @param atitle     标题
 *  @param aid        内容
 *  @param acancelStr 按钮1
 *  @param aotherStr  按钮2
 */
- (void)showAlertWithTitle:(NSString*)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelStr otherButtonTitles:(NSString*)otherStr;
- (void)showAlertWithoutButtons:(NSString *)message;
- (void)showAlert:(NSString*)message;
- (void)showAlert:(NSString*)message withSigleButton:(NSString*)buttonTitle;
- (void)hiddenAlert;
- (void)setAlertDelegate:(id)obj;
- (void)setAlertTag:(int)tag;
- (void)removeAlert;
/**
 *  根据颜色生成一张纯色图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+ (UIImage *)buttonImageFromColor:(UIColor *)color;
/**
 *  修改图片尺寸
 *
 *  @param img  需要修改的图片
 *  @param size 修改后大小
 *
 *  @return 新图片
 */
+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size;
/**
 *  判断程序是否第一次运行
 *
 *  @return 是/否
 */
+ (BOOL)isNewVersionAppFirstRun;
/**
 *  根据时间创建名称
 *
 *  @return 名称
 */
+ (NSString *)nameWithDate;
/**
 *  获取Document路径
 *
 *  @return 路径
 */
+ (NSString *)documentPath;
/**
 *  创建Document文件路径
 *
 *  @param name 文件夹名
 */
+ (void)createFilePathWithName:(NSString *)name;
/**
 *  获取Cache路径
 *
 *  @return 路径
 */
+ (NSString *)cachesPath;
/**
 *  获取Cache文件夹下文件路径
 *
 *  @param fileName 文件名
 *
 *  @return 路径
 */
+ (NSString *)filePathCaches:(NSString *)fileName;
/**
 *  Cache文件夹下是否存在文件
 *
 *  @param fileName 文件名
 *
 *  @return 是/否
 */
+ (BOOL)isExistFileInCache:(NSString *)fileName;
/**
 *  计算路径下所有文件大小
 *
 *  @param folderPath 路径
 *
 *  @return 大小
 */
+ (float)folderSizeAtPath:(NSString*)folderPath;
/**
 *  清空Cache文件夹缓存
 */
+ (void)cleanCaches;
/**
 *  创建UITextField
 *
 *  @param frame           大小
 *  @param entry           是否隐藏
 *  @param backgroundColor 背景颜色
 *  @param placeholder     默认文字
 *  @param textColor       文字颜色
 *  @param font            文字大小
 *  @param iconName        左图名称
 *  @param keyType         键盘按钮
 *
 *  @return UITextField
 */
+ (UITextField *)textFieldWithFrame:(CGRect)frame
                    secureTextEntry:(BOOL)entry
                    backgroundColor:(UIColor *)backgroundColor
                        placeholder:(NSString *)placeholder
                          textColor:(UIColor *)textColor
                           fontSize:(CGFloat)font
                   leftViewIconName:(NSString *)iconName
                      returnKeyType:(UIReturnKeyType)keyType;
/**
 *  校验字典
 *
 *  @param dic 字典
 *  @param key 键
 *
 *  @return 值
 */
+ (NSString *)verifyDictionaryWithDic:(NSDictionary *)dic key:(NSString *)key;
/**
 *  校验字符串
 *
 *  @param string 字符串
 *
 *  @return 如果为空 返回暂无
 */
+ (NSString *)verifyStringWithString:(NSString *)string;

+ (NSArray *)sleepUPImage;
+ (NSArray *)sleepDownImage;

//时间戳转字符串
+(NSString *)timeStampConversionNSString:(NSString *)timeStamp;
//时间转时间戳
+(NSString *)dateConversionTimeStamp:(NSDate *)date;
//字符串转时间
+(NSDate *)nsstringConversionNSDate:(NSString *)dateStr;

@end
