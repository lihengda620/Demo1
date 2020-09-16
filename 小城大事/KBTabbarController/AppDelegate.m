//
//  AppDelegate.m
//  KBTabbarController
//
//  Created by kangbing on 16/5/31.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "AppDelegate.h"
#import "KBTabbarController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[KBTabbarController alloc]init];
    [self.window makeKeyAndVisible];
    
    //微信登录
    [WXApi registerApp:WeChatAPIKey];
    
//    NSMutableArray *arrShortcutItem = (NSMutableArray *)[UIApplication sharedApplication].shortcutItems;
//    
//    UIApplicationShortcutItem *shoreItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"cn.damon.DM3DTouchDemo.openSearch" localizedTitle:@"搜索" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch] userInfo:nil];
//    [arrShortcutItem addObject:shoreItem1];
//    
//    UIApplicationShortcutItem *shoreItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"cn.damon.DM3DTouchDemo.openCompose" localizedTitle:@"新消息" localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose] userInfo:nil];
//    [arrShortcutItem addObject:shoreItem2];
//    
//    [UIApplication sharedApplication].shortcutItems = arrShortcutItem;
//
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRootViewwController) name:@"click_LoginDismiss" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogOutChangeRootViewwController) name:@"logout" object:nil];
    
    SDWebImageDownloader *imgDownloader = SDWebImageManager.sharedManager.imageDownloader;
    imgDownloader.headersFilter  = ^NSDictionary *(NSURL *url, NSDictionary *headers) {
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
        NSString *imgPath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgKey];
        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];
        
        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
        
        NSDate *lastModifiedDate = nil;
        
        if (fileAttr.count > 0) {
            if (fileAttr.count > 0) {
                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
            }
            
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
        
        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
        [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
        
        return mutableHeaders;
    };
    
    
    return YES;
}

- (void)getRootViewwController
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[KBTabbarController alloc]init];
    [self.window makeKeyAndVisible];
}

- (void)LogOutChangeRootViewwController
{
    LoginViewController * loginNavc = [[LoginViewController alloc]init];
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    CATransition *transtition = [CATransition animation];
    transtition.duration = 0.5;
    transtition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginNavc;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transtition forKey:@"animation"];
}

//- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {

//    //不管APP在后台还是进程被杀死，只要通过主屏快捷操作进来的，都会调用这个方法
//    NSLog(@"name:%@\ntype:%@", shortcutItem.localizedTitle, shortcutItem.type);
//    if ([shortcutItem.localizedTitle isEqualToString:@"怎么样小老弟"]) {
//        UIWindow * alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        alertWindow.rootViewController = [[UIViewController alloc] init];
//        alertWindow.windowLevel = UIWindowLevelAlert + 1;
//        [alertWindow makeKeyAndVisible];
//        //初始化弹窗口控制器
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"怎么样小老弟" message:@"牛逼不" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"你最牛逼了" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:cancelAction];
//        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//    }else if ([shortcutItem.localizedTitle isEqualToString:@"收藏"]){
//
//        UIWindow * alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        alertWindow.rootViewController = [[UIViewController alloc] init];
//        alertWindow.windowLevel = UIWindowLevelAlert + 1;
//        [alertWindow makeKeyAndVisible];
//        //初始化弹窗口控制器
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你点击了收藏" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"真牛逼" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:cancelAction];
//        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//    }else if ([shortcutItem.localizedTitle isEqualToString:@"搜索"]){
//        UIWindow * alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        alertWindow.rootViewController = [[UIViewController alloc] init];
//        alertWindow.windowLevel = UIWindowLevelAlert + 1;
//        [alertWindow makeKeyAndVisible];
//        //初始化弹窗口控制器
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你点击了搜索" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"真牛逼" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:cancelAction];
//        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//
//    }else if ([shortcutItem.localizedTitle isEqualToString:@"新消息"]){
//
//        UIWindow * alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        alertWindow.rootViewController = [[UIViewController alloc] init];
//        alertWindow.windowLevel = UIWindowLevelAlert + 1;
//        [alertWindow makeKeyAndVisible];
//        //初始化弹窗口控制器
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你点击了新消息" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"真牛逼" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:cancelAction];
//        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//    }
//}

//微信登录回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result2222222222 = %@",resultDic);
        }];
    }
    return [WXApi handleOpenURL:url delegate:self];
    
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result11111111111 = %@",resultDic);
            
            NSString * memo = resultDic[@"memo"];
            NSLog(@"===memo:%@", memo);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"])
            {
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ALiPaySuccess" object:nil];
                
            }else{
                NSLog(@"支付失败%@",memo);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ALiPayFailure" object:nil];
            }
        }];
        return YES;
    }else{
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    
}

-(void) onResp:(BaseResp*)resp{
    NSLog(@"resp %d",resp.errCode);
    
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            //            if ([_wxDelegate respondsToSelector:@selector(loginSuccessByCode:)]) {
            //                SendAuthResp *resp2 = (SendAuthResp *)resp;
            //                [_wxDelegate loginSuccessByCode:resp2.code];
            //            }
            SendAuthResp *resp2 = (SendAuthResp *)resp;
            NSLog(@"微信code===========%@",resp2.code);
            [self.logNAVC getWechatLogin:resp2.code];
            [self.codeLogNAVC getWechatLogin:resp2.code];
            
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"WechatPaySuccess" object:nil];
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                NSLog(@"支付失败");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"WechatPayFailure" object:nil];
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                NSLog(@"用户已经退出支付！");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"WechatPayFailure" object:nil];
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"支付失败");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"WechatPayFailure" object:nil];
                break;
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //从后台进入前台
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSLog(@"%@",pasteboard.string);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
