//
//  MessageWebViewController.m
//  KBTabbarController
//
//  Created by 李恒达 on 2019/8/13.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MessageWebViewController.h"

@interface MessageWebViewController ()
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIWebView * mainWebView;
@property (nonatomic, strong) UIButton * rightBtn;

@property (nonatomic, strong) UIView * moreView;
@property (nonatomic, strong) UIButton * shouCangBtn;
@property (nonatomic, strong) UIButton * fenXiangBtn;

@end

@implementation MessageWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //监听UIWindow显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=NO;
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}


-(void)endFullScreen{
    NSLog(@"退出全屏");
    [UIApplication sharedApplication].statusBarHidden = NO;
}

-(void)beginFullScreen{
    NSLog(@"开启全屏");
    [UIApplication sharedApplication].statusBarHidden = YES;
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
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"消息内容" Color:RGBA(51, 51, 51, 1.0) Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, CGRectGetMidY(self.titleLabel.frame) - FitSizeH(22), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
    

}

- (void)initView{
    
    
    CGRect webViewRect = CGRectMake(FitSizeW(17),NAVIGATION_BAR_HEIGHT + FitSizeH(10),ScreenSizeWidth - FitSizeW(34) ,SCREENHEIGHT - FitSizeH(10) - NAVIGATION_BAR_HEIGHT);
    self.mainWebView = [[UIWebView alloc] initWithFrame:webViewRect];
    [self.mainWebView setBackgroundColor:[UIColor whiteColor]];
    self.mainWebView.scrollView.bounces = YES;
    self.mainWebView.scrollView.showsHorizontalScrollIndicator = YES;
    self.mainWebView.allowsInlineMediaPlayback = YES;
    self.mainWebView.mediaPlaybackRequiresUserAction = NO;
    [self.view addSubview:self.mainWebView];
    NSString * urlStr = [NSString stringWithFormat:@"%@/index/Index/message?id=%@",RBDom,self.idStr];
    NSURL * url = [NSURL URLWithString:urlStr];
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
