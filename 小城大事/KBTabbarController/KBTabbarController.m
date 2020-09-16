//
//  KBTabbarController.m
//  KBTabbarController
//
//  Created by kangbing on 16/5/31.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "KBTabbarController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "IssueViewController.h"
#import "LoginViewController.h"
#import "KBTabbar.h"

@interface KBTabbarController ()<UITabBarControllerDelegate>

@end

@implementation KBTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    OneViewController *hvc = [[OneViewController alloc] init];
    [self addChildController:hvc title:@"首页" imageName:@"shouye2" selectedImageName:@"shouye" navVc:[UINavigationController class]];
    
    TwoViewController *fvc = [[TwoViewController alloc] init];
    [self addChildController:fvc title:@"婚恋" imageName:@"hunlianteb" selectedImageName:@"hunlian2" navVc:[UINavigationController class]];
    
    ThreeViewController *MoreVc = [[ThreeViewController alloc] init];
    [self addChildController:MoreVc title:@"消息" imageName:@"xiaoxiteb" selectedImageName:@"xiaoxi2" navVc:[UINavigationController class]];
    
    FourViewController *svc = [[FourViewController alloc] init];
    [self addChildController:svc title:@"我的" imageName:@"meteb" selectedImageName:@"meteb2" navVc:[UINavigationController class]];
    
    
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]];
    //  设置tabbar
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    // 设置自定义的tabbar
    [self setCustomtabbar];
    
    self.delegate = self;
    
}

- (void)setCustomtabbar{

    KBTabbar *tabbar = [[KBTabbar alloc]init];
    
    [self setValue:tabbar forKeyPath:@"tabBar"];

    [tabbar.centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];


}

- (void)centerBtnClick:(UIButton *)btn{

    
//    NSLog(@"点击了中间");
//
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"点击了中间按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//
//    [alert show];
    
    IssueViewController *controller = [[IssueViewController alloc] init];
    controller.modalPresentationStyle = 0;
    [self presentViewController:controller animated:YES completion:nil];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc
{
    
    childController.title = title;
    if (@available(iOS 13.0, *)) {
        [[UITabBar appearance] setUnselectedItemTintColor:RGBA(152, 152, 152, 1.0)];
    }
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置一下选中tabbar文字颜色
    
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : RGBA(238, 82, 82, 1) }forState:UIControlStateSelected];
    
    UINavigationController* nav = [[navVc alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}


- (UIImage *)imageWithColor:(UIColor *)color{
    // 一个像素
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    [FlanceTools AddClickBtnTouch];
    if (viewController == self.viewControllers[3] ||viewController == self.viewControllers[2]) {
        NSUserDefaults *userDefaultes = LDUserDefaults;
        NSString * versionStr = [userDefaultes stringForKey:@"versionStr"];
        if (![versionStr isEqualToString:@"1.0"]) {
            LoginViewController *controller = [[LoginViewController alloc] init];
            controller.modalPresentationStyle = 0;
            [self presentViewController:controller animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}


@end
