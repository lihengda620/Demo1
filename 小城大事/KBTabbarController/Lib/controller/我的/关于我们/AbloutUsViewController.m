//
//  AbloutUsViewController.m
//  KBTabbarController
//
//  Created by 李恒达 on 2019/8/1.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "AbloutUsViewController.h"

@interface AbloutUsViewController ()
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIWebView * mainWebView;

@end

@implementation AbloutUsViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationView];
    [self initView];
}


- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"关于我们" Color:[UIColor blackColor] Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, CGRectGetMidY(self.titleLabel.frame) - FitSizeH(22), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
}

- (void)initView{
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RBDom,self.urlStr]];
    CGRect webViewRect = CGRectMake(FitSizeW(17),NAVIGATION_BAR_HEIGHT,ScreenSizeWidth - FitSizeW(34) ,SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT);
    self.mainWebView = [[UIWebView alloc] initWithFrame:webViewRect];
    [self.mainWebView setBackgroundColor:[UIColor whiteColor]];
    self.mainWebView.scrollView.bounces = YES;
    self.mainWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.mainWebView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainWebView];
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:url]];
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
