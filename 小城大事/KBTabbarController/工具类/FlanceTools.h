//
//  FlanceTools.h
//  FinanceFramework
//
//  Created by lihengda on 2017/12/22.
//  Copyright © 2017年 lihengda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GlobalConfig.h"
#import <MediaPlayer/MediaPlayer.h>

typedef enum direction  //方向
{
    /** 向左 */
    FFDirectionLeft,
    /** 中间 */
    FFDirectionCenter,
    /** 向右 */
    FFDirectionRight,
}Direction;

@interface FlanceTools : NSObject

#pragma mark - 创建Label
/**
 *  创建label
 *
 *  @param frame     frame
 *  @param font      字体
 *  @param weight    字体是否为粗体: YES,是粗体 NO,不是粗体
 *  @param text      文字
 *  @param color     字体颜色
 *  @param direction 文字在label中的位置
 *
 *  @return 返回label
 */
+(UILabel *)labelCreateWithFrame:(CGRect)frame Font:(CGFloat)font IsBold:(BOOL)isBold  Text:(NSString *)text Color:(UIColor *)color Direction:(NSTextAlignment)direction;

#pragma mark --创建View
/**
 *  创建view
 *
 *  @param frame   frame
 *  @param bgcolor view的背景颜色
 *
 *  @return 返回view
 */
+(UIView*)viewCreateWithFrame:(CGRect)frame BgColor:(UIColor *)bgColor BgImage:(UIImage *)bgImage;

#pragma mark -- 创建阴影效果
+(void)ViewCreateShade:(UIView *)View;

#pragma mark 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict;

#pragma mark 数组转json字符串方法
+(NSString *)arrayToJsonData:(NSArray *)array;

+(void)ButtonCreateShade:(UIButton *)btn;
#pragma mark 根据增加的天数、月份、年 换算时间
+ (NSDate *)getLaterDateFromDate:(NSDate *)date withYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

#pragma mark  --生成二维码
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

#pragma mark -- 创建imageView
/**
 *  创建imageView
 *
 *  @param frame     frame
 *  @param imageName imageName
 *
 *  @return 返回UIImageView
 */
+(UIImageView *)imageViewCreateViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;

#pragma mark --创建button
/**
 *  创建button
 *
 *  @param frame   frame
 *  @param bgcolor view的背景颜色
 *
 *  @return 返回button
 */
+(UIButton*)buttonCreateWithFrame:(CGRect)frame Title:(NSString*)title Font:(CGFloat)font IsBold:(BOOL)isBold TitleColor:(UIColor *)titleColor TitleSelectColor:(UIColor *)titleSelectColor ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action;

#pragma mark --创建UITextField
+(UITextField *)textFieldCreateTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName;

//版本号
+ (float)getIOSVersion;

#pragma mark 字符串转double
+ (NSString *)getStringValueForDouble:(double)doubleValue;

/**
 double转string
 */
#pragma mark double类型转string
+(NSString *)DoubleToString:(double)DoubleD;

/**
 判断字典为空
 @param  dic 数组
 @return YES 空 NO
 */
+ (BOOL)isBlankDictionary:(NSDictionary *)dic;

/**
 判断数组为空
 @param  arr 数组
 @return YES 空 NO
 */
+ (BOOL)isBlankNSArray:(NSArray *)arr;

//国际手机号码校验 正则表达式 不规则校验  YES通过  NO不通过
+ (BOOL) isMobileGuoJi:(NSString *)mobileNumbel;

//邮箱
+ (BOOL) validateEmail:(NSString *)email;
//邀请码验证
+ (BOOL) validateInviteCode:(NSString *)mobile;
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;
//电话号码验证
+ (BOOL) validateTelephone:(NSString*)telephone;
//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;
//车型
+ (BOOL) validateCarType:(NSString *)CarType;
//用户名
+ (BOOL) validateUserName:(NSString *)name;
//密码
+ (BOOL) validatePassword:(NSString *)passWord;
//昵称
+ (BOOL) validateNickname:(NSString *)nickname;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//银行卡
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber;
//银行卡后四位
+ (BOOL) validateBankCardLastNumber: (NSString *)bankCardNumber;
//CVN
+ (BOOL) validateCVNCode: (NSString *)cvnCode;
//month
+ (BOOL) validateMonth: (NSString *)month;
//year
+ (BOOL) validateYear: (NSString *)year;
//verifyCode
+ (BOOL) validateVerifyCode: (NSString *)verifyCode;
//金额正则
+ (BOOL) validatePureFloat:(NSString *)string;
#pragma mark -校验生日 18-55岁
+ (NSInteger)caculateAgeWithSelectedBirthday:(NSString*)selectBirthday;
#pragma mark -验证身份证-
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;
//根据身份证号获取生日
+(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr;
//根据身份证号性别
+(NSString *)getIdentityCardSex:(NSString *)numberStr;
#pragma mark  计算两个坐标之间的直线距离
+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;
//语音播报
+(void)doVoice:(NSString *)VoiceTEXT;

+ (void)voiceChange:(float)voiceF;

//退出APP
+ (void)closeApp;

//MD5加密
+ (NSString *)md5:(NSString *)str;

//转换时间
+ (NSString*)changeTimeWithSecond:(float)second;

//图片格式
+ (NSString *)typeForImageData:(NSData *)data;
//识别银行卡号
+ (NSString *)returnBankName:(NSString*) idCard;

//屏幕旋转
+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation;

//添加点击触感
+ (void)AddClickBtnTouch;
@end
