
//
//  GlobalConfig.h
//  CoachDriving
//
//  Created by 李恒达 on 15/12/7.
//  Copyright © 2015年 李恒达. All rights reserved.
//#import "GlobalConfig.h"

#ifndef KugouMusic_GlobalConfig_h
#define KugouMusic_GlobalConfig_h

#define PI 3.1415926

#define APIKey   @"9b95bb04546141cafad3de42796e685e"
#define WeChatAppSecret  @"95196fdb9fcde812f30ad5152387a2d3"
#define WeChatAPIKey   @"wx4d2786e5384460e4"
#define ALiPayAppID @""


#define workingTime  3600

//NSUserDefaults
#define LDUserDefaults  [NSUserDefaults standardUserDefaults]
//NSUserDefaults 取值
#define getKeyForMyUserDefault(A) [[NSUserDefaults standardUserDefaults] objectForKey:A]

#define LDcurrentLanguage [NSString stringWithFormat:@"%@",[LDUserDefaults stringForKey:@"currentLanguage"]]

#define LDcurrentLanguageForNet [NSString stringWithFormat:@"%@",[LDUserDefaults stringForKey:@"languageForNet"]]

#define LDcurrentregistrationID [NSString stringWithFormat:@"%@",[LDUserDefaults stringForKey:@"registrationID"]]


// 字符串是否为空
#define StrIsEmpty(str) [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]||!str
//！str 是判断是否为nil
//去空格
#define trimstr(str) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
#endif
#define  _J_Versions   @"JyJVersion"


#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >=8.0 ? YES : NO)


#define ScreenSize   [UIScreen mainScreen].bounds.size

#define ScreenSizeWidth   [UIScreen mainScreen].bounds.size.width

#define ScreenSizeHeight   [UIScreen mainScreen].bounds.size.height

#define SCREEN_WIDTH                        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                       [UIScreen mainScreen].bounds.size.height
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define WITCH   [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X (Is_Iphone && SCREEN_HEIGHT == 812.0)
#define Is_Iphone_XR ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
// 状态栏高度
#define STATUS_BAR_HEIGHT (Is_Iphone_X ? 44.f : Is_Iphone_XR ?  44.0f : 20.f)
#define Banner_STATUS_BAR_HEIGHT (Is_Iphone_X ? 34.f : 0.f)
#define HairCurtains_HEIGHT 34.f
#define  SCREEN_TOP_START_Y (Is_Iphone_X ?  : 0.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (Is_Iphone_X ? 88.f : Is_Iphone_XR ?  88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (Is_Iphone_X ? (49.f+34.f) : Is_Iphone_XR ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (Is_Iphone_X ? 34.f : 0.f)
#define kSCREEN_HIGHT_ADJUST (Is_Iphone_X ? kScreenH - TAB_BAR_HEIGHT - HOME_INDICATOR_HEIGHT : kScreenH)

#define FitSizeW(n) (n*(WITCH/375.0))
#define FitSizeH(n) ((n)*((Is_Iphone_X?HEIGHT -88-34-20 : Is_Iphone_XR ? HEIGHT -88-34-20 : HEIGHT)/667.0))
#define Fit3XSizeW(n) ((n)*(WITCH/1242.0))
#define Fit3XSizeH(n) ((n)*((Is_Iphone_X?HEIGHT -88-34-20 :HEIGHT)/2208.0))
#define kScreenWith 1242.0
#define kScreenHeight 2208.0
#define FitWidthPercent(n)   WITCH*n*0.01
#define FitHeightPercent(n)   HEIGHT*n*0.01

#define kFontStr @"PingFang-SC-Regular"

#define KEY_WINDOW [[UIApplication sharedApplication] keyWindow]


//定时器
#define TimerScore  5.0f

/**
 *  屏幕宽度
 */
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

/**
 *  屏幕高度
 */

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

/**
 *  SideBar偏移量
 */
#define ContentOffset SCREENWIDTH / 6 * 5 - 10

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 *  背景色
 */
#define bgViewColor UIColorFromRGB(0xf5f5f5)

#define customerBgColor [UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1]

#define customerBlue [UIColor colorWithRed:2.0/255.0f green:188.0/255.0f blue:250.0/255.0f alpha:1]

//RGB颜色
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define kTextPlaceholderColor COLOR_WITH_HEX(0x9d9d9d)//PJColor(209, 24, 72)
#define PJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0f]
#define kTextInputColor COLOR_WITH_HEX(0x343434)//PJColor(209, 24, 72)
#define kMyUserTextLabelColor PJColor(132, 132, 132)
