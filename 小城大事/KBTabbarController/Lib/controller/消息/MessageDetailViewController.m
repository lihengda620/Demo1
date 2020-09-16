//
//  MessageDetailViewController.m
//  KBTabbarController
//
//  Created by CHUANGSHENG on 2019/7/26.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) UIScrollView * mainScrollView;

@end

@implementation MessageDetailViewController

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
    self.view.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self initNavigationView];
    [self initView];
}

- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"消息内容" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, CGRectGetMidY(self.titleLabel.frame) - FitSizeH(22), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
    
}

- (void)initView{
    
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, ScreenSizeHeight - CGRectGetMaxY(self.navigationView.frame))];
    self.mainScrollView.backgroundColor = RGBA(245, 245, 245, 1.0);
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    UILabel * type_name = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(10), FitSizeW(300), FitSizeH(20)) Font:14 IsBold:YES Text:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"type_name"]] Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:type_name];
    
    UILabel * timeLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(type_name.frame) + FitSizeH(10), FitSizeW(300), FitSizeH(20)) Font:14 IsBold:NO Text:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"createtime"]] Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:timeLabel];
    
    UILabel * textLabel1 = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(timeLabel.frame) + FitSizeH(10), FitSizeW(300), FitSizeH(20)) Font:14 IsBold:NO Text:@"尊敬的用户" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:textLabel1];
    
    UILabel * textLabel2 = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(textLabel1.frame) + FitSizeH(10), FitSizeW(300), FitSizeH(20)) Font:14 IsBold:NO Text:@"您好！" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:textLabel2];
    
    NSString * detailStr = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"content"]];
    CGSize size = CGSizeMake(FitSizeW(350), MAXFLOAT);
    CGRect rect = [detailStr boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    NSLog(@"%f",rect.size.height);
    self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(490)+ rect.size.height);
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(12.5), CGRectGetMaxY(textLabel2.frame) + FitSizeH(10), FitSizeW(350), rect.size.height + FitSizeH(100))];
    self.textView.text = detailStr;
    self.textView.userInteractionEnabled = NO;
    self.textView.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self.textView setFont:[UIFont systemFontOfSize:14]];
    [self.textView setTextColor:RGBA(80, 80, 80, 1)];
    [self.mainScrollView addSubview:self.textView];
    
    
    
    UILabel * textLabel3 = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(150), CGRectGetMaxY(self.textView.frame) + FitSizeH(30), FitSizeW(135), FitSizeH(20)) Font:14 IsBold:NO Text:@"小城大事App" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentRight];
    [self.mainScrollView addSubview:textLabel3];
    
    UILabel * textLabel4 = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(200), CGRectGetMaxY(textLabel3.frame) + FitSizeH(15), FitSizeW(185), FitSizeH(20)) Font:14 IsBold:NO Text:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"createtime"]] Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentRight];
    [self.mainScrollView addSubview:textLabel4];
    
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
