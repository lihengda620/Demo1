//
//  RegisterViewController.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/2.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : UIViewController

@property (nonatomic,strong) NSString * isWechatLogin;
@property (nonatomic,strong) NSString * openidStr;
@property (nonatomic,strong) NSString * headimgurl;
@property (nonatomic,strong) NSString * nickname;
@property (nonatomic,strong) NSString * sex;

@end

NS_ASSUME_NONNULL_END
