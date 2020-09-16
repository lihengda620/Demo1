//
//  SeeBigImageViewController.m
//  KBTabbarController
//
//  Created by 李恒达 on 2020/9/12.
//  Copyright © 2020 kangbing. All rights reserved.
//

#import "SeeBigImageViewController.h"




@interface SeeBigImageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;

@end

@implementation SeeBigImageViewController
{
    NSMutableArray *_ljImageArray;
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
    self.view.backgroundColor = [UIColor blackColor];
    [self initNavigationView];
    [self initView];
}

- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"查看大图" Color:RGBA(51, 51, 51, 1.0) Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, CGRectGetMidY(self.titleLabel.frame) - FitSizeH(22), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
}

- (void)initView{
    
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
