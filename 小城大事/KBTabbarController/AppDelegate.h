//
//  AppDelegate.h
//  KBTabbarController
//
//  Created by kangbing on 16/5/31.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "CodeLoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController * logNAVC;
@property (strong, nonatomic) CodeLoginViewController * codeLogNAVC;

@end

