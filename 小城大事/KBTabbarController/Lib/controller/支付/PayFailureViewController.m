//
//  PayFailureViewController.m
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/5.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "PayFailureViewController.h"

@interface PayFailureViewController ()
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;

@end

@implementation PayFailureViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self initNavigationView];
    [self initView];
}

- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"支付失败" Color:[UIColor blackColor] Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, CGRectGetMidY(self.titleLabel.frame) - FitSizeH(22), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
}

- (void)initView{
    UIImageView * imageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(143), CGRectGetMaxY(self.navigationView.frame) + FitSizeH(49), FitSizeW(90), FitSizeH(90)) ImageName:@"shibai"];
    [self.view addSubview:imageView];
    
    UILabel * TextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(0, CGRectGetMaxX(imageView.frame) + FitSizeH(30), SCREEN_WIDTH, FitSizeH(30)) Font:15 IsBold:NO Text:@"然而，您支付失败了！" Color:RGBA(153, 153, 153, 1.0) Direction:NSTextAlignmentCenter];
    [self.view addSubview:TextLabel];
    
    
    UIButton * lookBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(43), FitSizeH(267) + CGRectGetMaxY(self.navigationView.frame), FitSizeW(290), FitSizeH(44)) Title:@"继续支付" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_ContinueBtn)];
    lookBtn.layer.masksToBounds = YES;
    lookBtn.layer.cornerRadius = 5;
    [lookBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.view addSubview:lookBtn];
}

- (void)click_ContinueBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)click_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
