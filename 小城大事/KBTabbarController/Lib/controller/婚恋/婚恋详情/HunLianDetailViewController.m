//
//  HunLianDetailViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/2.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "HunLianDetailViewController.h"
#import "PayViewController.h"

@interface HunLianDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) UIButton * rightBtn;
@property (nonatomic, strong) UIView * moreView;
@property (nonatomic, strong) UIButton * shouCangBtn;
@property (nonatomic, strong) UIButton * fenXiangBtn;

@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) UILabel * TypeLabel1;
@property (nonatomic, strong) UILabel * TypeLabel2;
//亮点
@property (nonatomic, strong) UILabel * liangDianLabel;

//房源概况
@property (nonatomic, strong) UILabel * miaoShuLabel;

//个人简介
@property (nonatomic, strong) UITextView * zeyouBiaoZhunTV;

//内心独白
@property (nonatomic, strong) UITextView * jiaoyoujianjieTV;

//兴趣爱好
@property (nonatomic, strong) UITextView * jiaoyouneirongTV;

//择友标准
@property (nonatomic, strong) UITextView * zeyouTV;


@property (nonatomic, strong) UIView * subView;
@property (nonatomic, strong) UIButton * submitBtn;

@property (nonatomic, strong) UIControl * mainControl;
@property (nonatomic, strong) UIView * popView;
@property (nonatomic, strong) UILabel * popDetailLabel;
@property (nonatomic, strong) UILabel * popTitleLabel;

@property (nonatomic, strong) UIView * myImageLineView;

@property (nonatomic, strong) UIView * successView;

//分享
@property (nonatomic, strong) UIControl * shareMainControl;
@property (nonatomic, strong) UIView * shareView;

@end

@implementation HunLianDetailViewController{
    NSDictionary * categoryDic;
    NSString * currentRemain_free_view;
    NSString * currentView_price;
    NSString * currentID;
    NSString * currentIs_view;
    NSString * social_accountStr;
    
    NSMutableArray * mutaImageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    mutaImageArr = [NSMutableArray array];
    [self initNavigationView];
    [self initView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetLiveDetails];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRootViewwController) name:@"click_PWLoginDismiss" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(releshDetailInfo) name:@"releshDetailInfo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrderInfoSuccess) name:@"OrderInfoSuccess" object:nil];
    
}

- (void)getRootViewwController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)releshDetailInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetLiveDetails];
}

- (void)OrderInfoSuccess
{
    [self getPhoneSuccess];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=NO;
}

- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, STATUS_BAR_HEIGHT +((STATUS_BAR_HEIGHT + FitSizeH(8))/2 - FitSizeH(22)), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - FitSizeW(50), STATUS_BAR_HEIGHT +(NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT) / 2 - FitSizeH(20), FitSizeW(40), FitSizeH(40));
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_gengduo"] forState:UIControlStateNormal];
    self.rightBtn.layer.cornerRadius = FitSizeW(5);
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.selected = NO;
    [self.rightBtn addTarget:self action:@selector(click_rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.rightBtn];
    
    
}

- (void)click_rightBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.moreView.hidden = NO;
    }else{
        self.moreView.hidden = YES;
    }
}

- (void)initView{
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.navigationView.frame))];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.contentSize = CGSizeMake(0, FitSizeH(1900));
     //更多
    self.moreView = [FlanceTools viewCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(50), CGRectGetMaxY(self.navigationView.frame), FitSizeW(40), FitSizeH(90)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.moreView];
    self.moreView.hidden = YES;
    
    self.shouCangBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, 0, FitSizeW(40), FitSizeH(45)) Title:@"收藏" Font:13 IsBold:NO TitleColor:RGBA(15, 15, 15, 1.0) TitleSelectColor:RGBA(15, 15, 15, 1.0) ImageName:@"souchangweixuan" Target:self Action:@selector(doCollectSite:)];
    [self.shouCangBtn setImage:[UIImage imageNamed:@"shoucang_red"] forState:UIControlStateSelected];
    [self.moreView addSubview:self.shouCangBtn];
    CGFloat space = 10.0;
    [self.shouCangBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop
                                      imageTitleSpace:space];
    
    self.fenXiangBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, FitSizeH(45), FitSizeW(40), FitSizeH(45)) Title:@"分享" Font:13 IsBold:NO TitleColor:RGBA(15, 15, 15, 1.0) TitleSelectColor:RGBA(15, 15, 15, 1.0) ImageName:@"fenxiang" Target:self Action:@selector(fenXiangBtn:)];
    [self.moreView addSubview:self.fenXiangBtn];
    [self.fenXiangBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop
                                      imageTitleSpace:space];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), 0, FitSizeW(200), FitSizeH(38)) Font:17.0f IsBold:YES Text:@"杨紫琼" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview: self.titleLabel];
    
    //type1
    self.TypeLabel1 = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.titleLabel.frame), FitSizeW(340), FitSizeH(20)) Font:13 IsBold:NO Text:@"" Color:RGBA(15, 15, 15, 1) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:self.TypeLabel1];
    
    //type
    self.TypeLabel2 = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.TypeLabel1.frame), FitSizeW(340), FitSizeH(20)) Font:14 IsBold:NO Text:@"" Color:RGBA(15, 15, 15, 1) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:self.TypeLabel2];
    
    //发布日期
    self.dateLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.TypeLabel2.frame), FitSizeW(340), FitSizeH(FitSizeH(30))) Font:13 IsBold:NO Text:@"" Color:RGBA(150, 150, 150, 1) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:self.dateLabel];
    
    
    
    //交友宣言
    UILabel * liangdianTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.dateLabel.frame), FitSizeW(200), FitSizeH(55)) Font:15 IsBold:YES Text:@"个人特征" Color:RGBA(80, 80, 80, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:liangdianTextLabel];
    
    UIView * liangdianLineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(liangdianTextLabel.frame), FitSizeW(345), FitSizeH(0.5)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
    [self.mainScrollView addSubview:liangdianLineView];
    
    self.liangDianLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(liangdianLineView.frame), FitSizeW(345), FitSizeH(50)) Font:13 IsBold:NO Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:self.liangDianLabel];
    
    //个人简介
    UILabel * miaoshuTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.liangDianLabel.frame), FitSizeW(200), FitSizeH(55)) Font:15 IsBold:YES Text:@"个人简介" Color:RGBA(80, 80, 80, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:miaoshuTextLabel];
    
    UIView * miaoshuLineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(miaoshuTextLabel.frame), FitSizeW(345), FitSizeH(0.5)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
    [self.mainScrollView addSubview:miaoshuLineView];
    
    self.miaoShuLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(miaoshuLineView.frame) + FitSizeH(5), FitSizeW(345), FitSizeH(60)) Font:14 IsBold:NO Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:self.miaoShuLabel];
    
    //内心独白
    UILabel * gongSiTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.miaoShuLabel.frame), FitSizeW(200), FitSizeH(55)) Font:15 IsBold:YES Text:@"内心独白" Color:RGBA(80, 80, 80, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:gongSiTextLabel];
    
    UIView * gongSiLineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(gongSiTextLabel.frame), FitSizeW(345), FitSizeH(0.5)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
    [self.mainScrollView addSubview:gongSiLineView];
    
    self.zeyouBiaoZhunTV = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(gongSiLineView.frame) + FitSizeH(5), FitSizeW(345), FitSizeH(60))];
    self.zeyouBiaoZhunTV.text = @"";
    self.zeyouBiaoZhunTV.userInteractionEnabled = NO;
    self.zeyouBiaoZhunTV.backgroundColor = [UIColor whiteColor];
    [self.zeyouBiaoZhunTV setFont:[UIFont systemFontOfSize:14]];
    [self.zeyouBiaoZhunTV setTextColor:RGBA(15, 15, 15, 1)];
    [self.mainScrollView addSubview:self.zeyouBiaoZhunTV];
    
    //兴趣爱好
    UILabel * jiaoyoujianjieTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.zeyouBiaoZhunTV.frame), FitSizeW(200), FitSizeH(55)) Font:15 IsBold:YES Text:@"兴趣爱好" Color:RGBA(80, 80, 80, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:jiaoyoujianjieTextLabel];
    
    UIView * jiaoyoujianjieLineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(jiaoyoujianjieTextLabel.frame), FitSizeW(345), FitSizeH(0.5)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
    [self.mainScrollView addSubview:jiaoyoujianjieLineView];
    
    self.jiaoyoujianjieTV = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(jiaoyoujianjieLineView.frame) + FitSizeH(5), FitSizeW(345), FitSizeH(100))];
    self.jiaoyoujianjieTV.text = @"";
    self.jiaoyoujianjieTV.userInteractionEnabled = NO;
    self.jiaoyoujianjieTV.backgroundColor = [UIColor whiteColor];
    [self.jiaoyoujianjieTV setFont:[UIFont systemFontOfSize:14]];
    [self.jiaoyoujianjieTV setTextColor:RGBA(15, 15, 15, 1)];
    [self.mainScrollView addSubview:self.jiaoyoujianjieTV];
    
    //择偶标准
    UILabel * zeyouTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.jiaoyoujianjieTV.frame), FitSizeW(200), FitSizeH(55)) Font:15 IsBold:YES Text:@"择偶标准" Color:RGBA(80, 80, 80, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:zeyouTextLabel];
    
    UIView * zeyouLineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(zeyouTextLabel.frame), FitSizeW(345), FitSizeH(0.5)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
    [self.mainScrollView addSubview:zeyouLineView];
    
    self.zeyouTV = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(zeyouLineView.frame) + FitSizeH(5), FitSizeW(345), FitSizeH(80))];
    self.zeyouTV.text = @"";
    self.zeyouTV.userInteractionEnabled = NO;
    self.zeyouTV.backgroundColor = [UIColor whiteColor];
    [self.zeyouTV setFont:[UIFont systemFontOfSize:14]];
    [self.zeyouTV setTextColor:RGBA(15, 15, 15, 1)];
    [self.mainScrollView addSubview:self.zeyouTV];
    
    
    //我的照片
    UILabel * myImageTextL = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(self.zeyouTV.frame), FitSizeW(200), FitSizeH(55)) Font:15 IsBold:YES Text:@"我的照片" Color:RGBA(80, 80, 80, 1.0) Direction:NSTextAlignmentLeft];
    [self.mainScrollView addSubview:myImageTextL];
    
    self.myImageLineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), CGRectGetMaxY(myImageTextL.frame), FitSizeW(345), FitSizeH(0.5)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
    [self.mainScrollView addSubview:self.myImageLineView];
    
    
    self.subView = [FlanceTools viewCreateWithFrame:CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.subView];
    [FlanceTools ViewCreateShade:self.subView];
    
    self.submitBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(15), (TAB_BAR_HEIGHT - FitSizeH(44)) / 2, FitSizeW(345), FitSizeH(44)) Title:@"联系 ta" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_lookBtn)];
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.subView addSubview:self.submitBtn];
    
    self.mainControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.mainControl];
    self.mainControl.backgroundColor = RGBA(1, 1, 1, 0.5);
    [self.mainControl addTarget:self action:@selector(click_mainCon) forControlEvents:UIControlEventTouchUpInside];
    self.mainControl.hidden = YES;
    
    self.popView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(42), FitSizeH(246), FitSizeW(290), FitSizeH(185)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.popView];
    self.popView.layer.cornerRadius = 5;
    self.popView.layer.masksToBounds = YES;
    self.popView.clipsToBounds = YES;
    self.popView.hidden = YES;
    
    self.popTitleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(0, 0, FitSizeW(290), FitSizeH(55)) Font:17 IsBold:YES Text:@"准备查看信息" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentCenter];
    [self.popView addSubview:self.popTitleLabel];
    
    self.popDetailLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(27), CGRectGetMaxY(self.popTitleLabel.frame), FitSizeW(224), FitSizeH(80)) Font:14 IsBold:NO Text:@"" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.popView addSubview:self.popDetailLabel];
    
    UIButton * cancelBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, FitSizeH(137), FitSizeW(145), FitSizeH(48)) Title:@"取消" Font:15 IsBold:NO TitleColor:RGBA(80, 80, 80, 1.0) TitleSelectColor:RGBA(80, 80, 80, 1.0) ImageName:nil Target:self Action:@selector(click_mainCon)];
    [cancelBtn setBackgroundColor:RGBA(245, 245, 245, 1.0)];
    [self.popView addSubview:cancelBtn];
    
    UIButton * sureBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(145), FitSizeH(137), FitSizeW(145), FitSizeH(48)) Title:@"确认" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_sureBtn)];
    [sureBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.popView addSubview:sureBtn];
    
    
    self.shareMainControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.shareMainControl];
    self.shareMainControl.backgroundColor = RGBA(1, 1, 1, 0.5);
    [self.shareMainControl addTarget:self action:@selector(click_shareMainControl) forControlEvents:UIControlEventTouchUpInside];
    self.shareMainControl.hidden = YES;
    
    self.shareView = [FlanceTools viewCreateWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, FitSizeH(208)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.shareView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.shareView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.shareView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.shareView.layer.mask = maskLayer;
    
    UIButton * wechatUserBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(29), FitSizeW(36), FitSizeW(50), FitSizeH(50)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"denxiang_weixin" Target:self Action:@selector(click_wechatUserBtn)];
    [self.shareView addSubview:wechatUserBtn];
    
    UILabel * wechatText1 = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(29), CGRectGetMaxY(wechatUserBtn.frame), FitSizeW(50), FitSizeH(25)) Font:14 IsBold:NO Text:@"微信" Color:RGBA(50, 50, 50, 1.0) Direction:NSTextAlignmentCenter];
    [self.shareView addSubview:wechatText1];
    
    UIButton * wechatFriendBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(114), FitSizeW(36), FitSizeW(50), FitSizeH(50)) Title:nil Font:12 IsBold:NO TitleColor:nil TitleSelectColor:nil ImageName:@"fenxiang_pengyouquan" Target:self Action:@selector(click_wechatFriendBtn)];
    [self.shareView addSubview:wechatFriendBtn];
    
    UILabel * wechatText2 = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(114), CGRectGetMaxY(wechatFriendBtn.frame), FitSizeW(50), FitSizeH(25)) Font:14 IsBold:NO Text:@"朋友圈" Color:RGBA(50, 50, 50, 1.0) Direction:NSTextAlignmentCenter];
    [self.shareView addSubview:wechatText2];
    
    UIButton * wechatCancelBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(63), FitSizeH(143), FitSizeW(250), FitSizeH(45)) Title:@"取    消" Font:17 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_wechatCancelBtn)];
    wechatCancelBtn.backgroundColor = RGBA(238, 82, 82, 1);
    wechatCancelBtn.layer.cornerRadius = FitSizeH(45) / 2;
    [self.shareView addSubview:wechatCancelBtn];
}

- (void)fenXiangBtn:(UIButton *)sender{
    self.shareMainControl.hidden = NO;
    [UIView animateWithDuration:0.24 animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT - FitSizeH(208), SCREEN_WIDTH, FitSizeH(208));
    }];
}

- (void)click_shareMainControl
{
    self.shareMainControl.hidden = YES;
    [UIView animateWithDuration:0.24 animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, FitSizeH(208));
    }];
}

#pragma mark 点击分享微信
- (void)click_wechatUserBtn
{
    NSString * titleStr = @"婚恋信息";
    NSString * descriptionStr = @"小城大事，致力于打造最专业的同城信息平台！";
    UIImage * setThumbImage = [UIImage imageNamed:@"tupian_hunlian"];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = titleStr;//标题
    message.description = descriptionStr;//描述
    [message setThumbImage:setThumbImage];//设置预览图
    
    //创建网页数据对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    NSString * urlStr = [NSString stringWithFormat:@"%@/Index/index/share/#/?id=%@&type=live",RBDom,self.idStr];
    webObj.webpageUrl = urlStr;//链接
    message.mediaObject = webObj;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.message = message;
    sendReq.scene = WXSceneSession;//分享到好友会话
    
    [WXApi sendReq:sendReq];//发送对象实例
}

#pragma mark 点击分享朋友圈
- (void)click_wechatFriendBtn
{
    NSString * titleStr = @"婚恋信息";
    NSString * descriptionStr = @"小城大事，致力于打造最专业的同城信息平台！";
    UIImage * setThumbImage = [UIImage imageNamed:@"tupian_hunlian"];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = titleStr;//标题
    message.description = descriptionStr;//描述
    [message setThumbImage:setThumbImage];//设置预览图
    
    //创建网页数据对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    NSString * urlStr = [NSString stringWithFormat:@"%@/Index/index/share/#/?id=%@&type=live",RBDom,self.idStr];
    webObj.webpageUrl = urlStr;//链接
    message.mediaObject = webObj;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.message = message;
    sendReq.scene = WXSceneTimeline;//分享到朋友圈
    
    [WXApi sendReq:sendReq];//发送对象实例
}

#pragma mark 点击分享取消
- (void)click_wechatCancelBtn
{
    self.shareMainControl.hidden = YES;
    [UIView animateWithDuration:0.24 animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, FitSizeH(208));
    }];
}

//WXSceneSession          = 0,   /**< 聊天界面    */
//WXSceneTimeline         = 1,   /**< 朋友圈     */
//WXSceneFavorite         = 2,   /**< 收藏       */
//WXSceneSpecifiedSession = 3,   /**< 指定联系人  */
//好友
- (void)sendMessage {
    WXMediaMessage *message = [WXMediaMessage message];
    
    NSString * titleStr = @"婚恋信息";
    NSString * descriptionStr = @"小城大事，致力于打造最专业的同城信息平台！";
    UIImage * setThumbImage = [UIImage imageNamed:@"tupian_hunlian"];
    
    message.title = titleStr;//标题
    message.description = descriptionStr;//描述
    [message setThumbImage:setThumbImage];//设置预览图
    
    //创建网页数据对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    NSString * urlStr = [NSString stringWithFormat:@"%@/Index/index/share/#/?id=%@&type=live",RBDom,self.idStr];
    webObj.webpageUrl = urlStr;//链接
    message.mediaObject = webObj;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.message = message;
    sendReq.scene = WXSceneSession;//分享到好友会话
    
    [WXApi sendReq:sendReq];//发送对象实例
}

//朋友圈
- (void)sendMessageForWXSceneTimeline {
    //    if([WXApi isWXAppInstalled]){//判断当前设备是否安装微信客户端
    //
    //
    //    }else{
    //
    //        //未安装微信应用或版本过低
    //        NSLog(@"11");
    //    }
    
    //创建多媒体消息结构体
    WXMediaMessage *message = [WXMediaMessage message];
    
    NSString * titleStr = @"婚恋信息";
    NSString * descriptionStr = @"小城大事，致力于打造最专业的同城信息平台！";
    UIImage * setThumbImage = [UIImage imageNamed:@"tupian_hunlian"];
    
    message.title = titleStr;//标题
    message.description = descriptionStr;//描述
    [message setThumbImage:setThumbImage];//设置预览图
    
    //创建网页数据对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    NSString * urlStr = [NSString stringWithFormat:@"%@/Index/index/share/#/?id=%@&type=live",RBDom,self.idStr];
    webObj.webpageUrl = urlStr;//链接
    message.mediaObject = webObj;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.message = message;
    sendReq.scene = WXSceneTimeline;//分享到朋友圈
    
    [WXApi sendReq:sendReq];//发送对象实例
}

- (void)click_sureBtn
{
    self.mainControl.hidden = YES;
    self.popView.hidden = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doOrderCreate:self->currentView_price type_id:self->currentID];
}

- (void)click_lookBtn
{
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * versionStr = [userDefaultes stringForKey:@"versionStr"];
    if (![versionStr isEqualToString:@"1.0"]) {
        NSLog(@"未登录");
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.label.text = @"请登录后进行查看";
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        }completionBlock:^{
            [HUD removeFromSuperview];
            LoginViewController *controller = [[LoginViewController alloc] init];
            controller.modalPresentationStyle = 0;
            [self presentViewController:controller animated:YES completion:nil];
        }];
    }else{
        if ([currentIs_view isEqualToString:@"0"]) {
            self.mainControl.hidden = NO;
            self.popView.hidden = NO;
        }else if ([currentIs_view isEqualToString:@"1"]){
            ;
            NSString *phone = [NSString stringWithFormat:@"tel://%@",social_accountStr];
            NSURL *url = [NSURL URLWithString:phone];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                NSLog(@"phone success");
            }];
        }
    }
}

- (void)click_mainCon
{
    self.mainControl.hidden = YES;
    self.popView.hidden = YES;
    [self.successView removeFromSuperview];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetLiveDetails];
}

- (void)getPhoneSuccess{
    
    self.mainControl.hidden = NO;
    
    self.successView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(42), FitSizeH(246), FitSizeW(290), FitSizeH(185)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.mainControl addSubview:self.successView];
    self.successView.layer.cornerRadius = 5;
    self.successView.layer.masksToBounds = YES;
    self.successView.clipsToBounds = YES;
    
    UILabel * popTitleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(0, 0, FitSizeW(290), FitSizeH(55)) Font:17 IsBold:YES Text:@"成功获取联系方式" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentCenter];
    [self.successView addSubview:popTitleLabel];
    
    UILabel * popDetailLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(27), CGRectGetMaxY(popTitleLabel.frame), FitSizeW(224), FitSizeH(55)) Font:15 IsBold:NO Text:@"您的联络方式，已经发送对方的消息中心，同时您也可以通过电话主动与对方取得联系！" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.successView addSubview:popDetailLabel];
    
    
    UIButton * sureBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, FitSizeH(137), FitSizeW(290), FitSizeH(48)) Title:@"确认" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_successSureBtn)];
    [sureBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    [self.successView addSubview:sureBtn];
}

- (void)click_successSureBtn{
    self.mainControl.hidden = YES;
    [self.successView removeFromSuperview];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetLiveDetails];
}


#pragma mark 创建订单
- (void)doOrderCreate:(NSString *)total_fee type_id:(NSString *)type_id
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",OrderCreate];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"total_fee":total_fee,@"type":@"live",@"type_id":type_id,@"channel":@"1"};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"UserLogin responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSDictionary * dic = [responseObject objectForKey:@"data"];
            NSString * is_pay = [NSString stringWithFormat:@"%@",[dic objectForKey:@"is_pay"]];
            NSString * order_no = [NSString stringWithFormat:@"%@",[dic objectForKey:@"order_no"]];
            if ([is_pay isEqualToString:@"0"]) {
                //无需支付
                [self getPhoneSuccess];
            }else{
                //需支付
                PayViewController * navc = [[PayViewController alloc]init];
                
                navc.order_noStr = order_no;
                navc.total_feeStr = total_fee;
                navc.payType = @"0";
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                    NSLog(@"微信安装了");
                    navc.isWechartOK = @"1";
                }else{
                    NSLog(@"微信没安装");
                    navc.isWechartOK = @"0";
                }
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
                    NSLog(@"支付宝安装了");
                    navc.isALiPayOK = @"1";
                }else{
                    NSLog(@"支付宝没安装");
                    navc.isALiPayOK = @"0";
                }
                if ([navc.isWechartOK isEqualToString:@"0"]&&[navc.isALiPayOK isEqualToString:@"0"]) {
                    [self showAlert:@"检测您并未安装微信与支付宝,请安装后再进行支付"];
                }else{
                    [self.navigationController pushViewController:navc animated:YES];
                }
                
            }
            
        }else if (code == 99){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"请登录后进行查看";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            }completionBlock:^{
                [HUD removeFromSuperview];
                LoginViewController *controller = [[LoginViewController alloc] init];
                controller.modalPresentationStyle = 0;
                [self presentViewController:controller animated:YES completion:nil];
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString * messageStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
            [self showAlert:messageStr];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark 查询次数
- (void)dogGetUserIndex
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserIndex];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"type":@"live"};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"UserLogin responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->categoryDic = [dataDic objectForKey:@"category"][0];
            [self.submitBtn setTitle:@"联系 ta" forState:UIControlStateNormal];
            //查看价格
            self->currentView_price = [NSString stringWithFormat:@"%@",[self->categoryDic objectForKey:@"view_price"]];
            //剩余查看次数
            self->currentRemain_free_view = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"remain_free_view"]];
            
            int free_viewInt = [self-> currentRemain_free_view intValue];
            if (free_viewInt > 0) {
                //免费查看 查看信息后，您可以获取对方的联系方式，一旦查看则无法退款，请确认
                self.popDetailLabel.text = [NSString stringWithFormat:@"查看信息后，您可以获取对方的联系方式，一旦查看则无法退款，请确认\n(当前剩余免费查看婚恋次数%d次)",free_viewInt];
            }else{
                //付费查看
                self.popDetailLabel.text = self.popDetailLabel.text = [NSString stringWithFormat:@"查看信息后，您可以获取对方的联系方式，一旦查看则无法退款，请确认\n(查看信息 %@元 / 条)",self->currentView_price];
            }
        }else if (code == 99){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"请登录后进行查看";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            }completionBlock:^{
                [HUD removeFromSuperview];
                LoginViewController *controller = [[LoginViewController alloc] init];
                controller.modalPresentationStyle = 0;
                [self presentViewController:controller animated:YES completion:nil];
            }];
        }else if (code == 99){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"请登录后进行查看";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            }completionBlock:^{
                [HUD removeFromSuperview];
                LoginViewController *controller = [[LoginViewController alloc] init];
                controller.modalPresentationStyle = 0;
                [self presentViewController:controller animated:YES completion:nil];
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString * messageStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
            [self showAlert:messageStr];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark 获取婚恋详情
- (void)doGetLiveDetails
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",LiveDetails];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"id":self.idStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"RecruitstaffDetails responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            NSString * nameStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]];
            self->currentID = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"id"]];
            self.titleLabel.text = nameStr;
            
            NSString * genderStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"gender"]];
            NSString * sexStr = @"";
            if ([genderStr isEqualToString:@"2"]) {
                sexStr = @"女";
            }else{
                sexStr = @"男";
            }
            NSString * typeStr = [NSString stringWithFormat:@"%@  |  %@  |  %@岁",[dataDic objectForKey:@"city"],[dataDic objectForKey:@"education_name"],[dataDic objectForKey:@"age"]];
            self.TypeLabel1.text = typeStr;
            
            NSString * type2Str = [NSString stringWithFormat:@"%@cm  |  %@  |  %@",[dataDic objectForKey:@"height"],[dataDic objectForKey:@"vocation"],[dataDic objectForKey:@"marital_status_name"]];
            self.TypeLabel2.text = type2Str;
            
            NSString * timeStr = [NSString stringWithFormat:@"%@发布",[dataDic objectForKey:@"createtime"]];
            self.dateLabel.text = timeStr;
            
            //交友宣言
            NSString * configureStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"declaration"]];
            self.liangDianLabel.text = configureStr;
            //个人简介
            NSString * personal_profileStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"personal_profile"]];
            self.miaoShuLabel.text = personal_profileStr;
            //内心独白
            NSString * soliloquyStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"soliloquy"]];
            self.zeyouBiaoZhunTV.text = soliloquyStr;
            //兴趣爱好
            NSString * hobbyStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"hobby"]];
            self.jiaoyoujianjieTV.text = hobbyStr;
            //择偶标准
            NSString * standardStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"standard"]];
            self.zeyouTV.text = standardStr;

            
            CGFloat h = FitSizeH(10) + CGRectGetMaxY(self.myImageLineView.frame);
            for (int i = 0; i < self.detailImageArr.count; i ++) {
                UIImageView * houseImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake(FitSizeW(15), FitSizeH(10) + CGRectGetMaxY(self.myImageLineView.frame) + FitSizeH(210) * i, FitSizeW(345), FitSizeH(200)) ImageName:@""];
                houseImageView.image = self.detailImageArr[i];
                CGFloat imageScale = houseImageView.image.size.height/houseImageView.image.size.width;
                CGFloat newImageWidth = FitSizeW(345);
                CGFloat newImageHeight = imageScale * newImageWidth;
                houseImageView.frame = CGRectMake(FitSizeW(15), h, FitSizeW(345), newImageHeight);
                h = h + newImageHeight + FitSizeH(10);
                if (i == self.detailImageArr.count - 1) {
                    self.mainScrollView.contentSize = CGSizeMake(0,FitSizeH(300) + h);
                }
                [self.mainScrollView addSubview:houseImageView];
                
            }
            
            NSString * is_collectStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"is_collect"]];
            if ([is_collectStr isEqualToString:@"0"]) {
                self.shouCangBtn.selected = NO;
            }else{
                self.shouCangBtn.selected = YES;
            }
            NSUserDefaults *userDefaultes = LDUserDefaults;
            NSString * versionStr = [userDefaultes stringForKey:@"versionStr"];
            if (![versionStr isEqualToString:@"1.0"]) {
                NSLog(@"未登录");
            }else{
                //是否查看过联系方式
                currentIs_view = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"is_view"]];
                if ([currentIs_view isEqualToString:@"0"]) {
                    //没看过
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self dogGetUserIndex];
                }else{
                    //看过
                    social_accountStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"social_account"]];
                    
                    [self.submitBtn setTitle:[NSString stringWithFormat:@"联系方式：%@",social_accountStr] forState:UIControlStateNormal];
                }
            }
            
        }else if (code == 99){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"请登录后进行查看";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            }completionBlock:^{
                [HUD removeFromSuperview];
                LoginViewController *controller = [[LoginViewController alloc] init];
                controller.modalPresentationStyle = 0;
                [self presentViewController:controller animated:YES completion:nil];
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString * messageStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
            [self showAlert:messageStr];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark 收藏与取消收藏
- (void)doCollectSite:(UIButton *)sender
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",CollectSite];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"type_id":self.idStr,@"type":@"live"};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"GoodsSiteCollectGoods responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            sender.selected = !sender.selected;
            if (sender.selected == YES) {
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.label.text = @"收藏成功";
                HUD.mode = MBProgressHUDModeText;
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                }completionBlock:^{
                    [HUD removeFromSuperview];
                    
                }];
            }else{
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.label.text = @"取消收藏成功";
                HUD.mode = MBProgressHUDModeText;
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                }completionBlock:^{
                    [HUD removeFromSuperview];
                    
                }];
            }
        }else if (code == 99){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"请登录后进行查看";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            }completionBlock:^{
                [HUD removeFromSuperview];
                LoginViewController *controller = [[LoginViewController alloc] init];
                controller.modalPresentationStyle = 0;
                [self presentViewController:controller animated:YES completion:nil];
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString * messageStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
            [self showAlert:messageStr];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error-->%@",error);
    }];
}

-(AFHTTPSessionManager *)sharedManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //最大请求并发任务数
    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30.0f;
    // 设置请求头
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    // 设置接收的Content-Type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
    //设置返回C的ontent-type
    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    return manager;
}

- (void)showAlert:(NSString *)text
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert ];
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
