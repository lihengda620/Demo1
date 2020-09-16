//
//  LoginViewController.h
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/2.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

- (void)getWechatLogin:(NSString*)code;

@end

NS_ASSUME_NONNULL_END
