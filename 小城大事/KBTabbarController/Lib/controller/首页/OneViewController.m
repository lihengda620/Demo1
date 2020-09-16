//
//  OneViewController.m
//  KBTabbarController
//
//  Created by kangbing on 16/5/31.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "OneViewController.h"
#import "RecommendedCell.h"
#import "RecruitmentCell.h"
#import "HousekeepingCell.h"
#import "RentHouseCell.h"
#import "OnADateCell.h"
#import "BuyingSellingCell.h"
#import "ElseCell.h"
#import "BuyingSellingCollectionCell.h"
#import "CityViewController.h"
#import "SearchViewController.h"
#import "RecruitmentDetailsViewController.h"
#import "HousekeepingDetailViewController.h"
#import "RentHouseDetailViewController.h"
#import "BaySellDetailViewController.h"
#import "FriendDetailViewController.h"
#import "ElseDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SearchResultViewController.h"

@interface OneViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UIButton * searchBGBtn;
@property (nonatomic, strong) UIButton * cityBtn;
@property (nonatomic, strong) UIView * classifyView;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) UIScrollView * searchScrollView;
@property (nonatomic, strong) UIView * classifyLineView;
@property (nonatomic, strong) UIView * radView;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) CLLocationManager *locationManager;


@property (nonatomic, strong) UIView * searchBGView;
@property (nonatomic, strong) UITextField * searchView;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIView * sousuoView;
@property (nonatomic, strong) UIButton * searchBtn;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * footerView;

@property (nonatomic, strong) UIView * noDataView;

@property (nonatomic, strong) UIControl * mainControl;
@property (nonatomic, strong) UIView * mianZeView;

@end

@implementation OneViewController
{
    UIButton * currentBtn;
    NSString * currentCityStr;
    NSString * currentSelectedCityStr;
    
    //推荐列表
    NSMutableArray * mutaRecommendArr;
    NSArray * recommendArr;
    NSInteger  page;
    
    //通告列表
    NSMutableArray * MutaNoticeArr;
    NSArray * noticeArr;
    
    //新闻列表
    NSMutableArray * MutaNewsArr;
    NSArray * newsArr;
    
    //招聘列表
    NSMutableArray * mutaRecruitmentArr;
    NSArray * recruitmentArr;
    
    //家政列表
    NSMutableArray * mutaRecruithousekeepArr;
    NSArray * recruithousekeepArr;
    
    //租房列表
    NSMutableArray * mutaLeaseArr;
    NSArray * leaseArr;
    
    //商品列表
    NSMutableArray * mutaGoodsArr;
    NSArray * goodsArr;
    
    //交友列表
    NSMutableArray * mutaFriendArr;
    NSArray * friendArr;
    
    //其他列表
    NSMutableArray * mutaElseArr;
    NSArray * elseArr;
    
    NSArray * hotDataArr;
    
    NSArray * historyArr;
    NSMutableArray * historyMutaArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    mutaRecommendArr = [NSMutableArray array];
    MutaNoticeArr = [NSMutableArray array];
    MutaNewsArr = [NSMutableArray array];
    mutaRecruitmentArr = [NSMutableArray array];
    mutaRecruithousekeepArr = [NSMutableArray array];
    mutaLeaseArr = [NSMutableArray array];
    mutaGoodsArr = [NSMutableArray array];
    mutaFriendArr = [NSMutableArray array];
    mutaElseArr = [NSMutableArray array];
    historyMutaArr = [NSMutableArray new];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSArray * userHistory = [userDefaultes arrayForKey:@"SearchHistoryArr"];
    if (userHistory.count != 0) {
        historyArr = userHistory;
    }
    [self initNavigationView];
    [self initView];
    self->currentCityStr = @"沈阳";
    self->currentSelectedCityStr = @"沈阳";
    [self startLocation];
    
//    [self doGetCategoryLists];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetIndexHot_search];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    

    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * mianzeStr = [userDefaultes stringForKey:@"mianzeStr"];
    if (![mianzeStr isEqualToString:@"1.0"]) {
        NSLog(@"已查看/未登录");
    }else{
        [self InitMianZeView];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)KeyboardDown
{
    [self.searchView resignFirstResponder];
}


- (void)InitMianZeView{
    [self.mainControl removeFromSuperview];
    [self.mianZeView removeFromSuperview];
    
    self.mainControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.mainControl];
    self.mainControl.backgroundColor = RGBA(1, 1, 1, 0.5);
    [self.mainControl addTarget:self action:@selector(click_mainControl) forControlEvents:UIControlEventTouchUpInside];
    self.mainControl.hidden = NO;
    
    
    self.mianZeView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(40), FitSizeH(150), SCREEN_WIDTH - FitSizeW(80),FitSizeH(450)) BgColor:[UIColor whiteColor] BgImage:nil];
    self.mianZeView.layer.cornerRadius = 5;
    self.mianZeView .layer.masksToBounds = YES;
    [self.view addSubview:self.mianZeView];
    
    UILabel * mianzeTitle = [FlanceTools labelCreateWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.mianZeView.frame), FitSizeH(40)) Font:16 IsBold:YES Text:@"免责声明" Color:RGBA(51, 51, 51, 1.0) Direction:NSTextAlignmentCenter];
    [self.mianZeView addSubview:mianzeTitle];
    
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(FitSizeW(12.5), CGRectGetMaxY(mianzeTitle.frame) , FitSizeW(270),FitSizeH(300))];
    textView.text = @"1.本APP所收集的部分公开资料来源于互联网，转载的目的在于传递更多信息及用于网络分享，并不代表本站赞同其观点和对其真实性负责，也不构成任何其他建议。\n2. 本APP所提供的信息，只供参考之用。本网站不保证信息的准确性、有效性、及时性和完整性。\n3. 任何使用本APP提供的信息作为依据而对第三方造成的各类损失，均由信息使用方负责，本站概不负责，亦不承担任何法律责任。\n4. 任何单位或个人认为通过本APP提供的内容可能涉嫌侵犯其合法权益，应该及时通过有效联系方式向客服反馈，并提供身份证明、权属证明及详细侵权情况证明，我们在收到上述文件后，将会尽快移除被控侵权内容。\n5. 本APP转载及访客投递的文章资讯均不代表本站观点。严禁在本站发布反动、色情、等不良信息。";
    textView.userInteractionEnabled = NO;
    textView.backgroundColor = [UIColor whiteColor];
    [textView setFont:[UIFont systemFontOfSize:14]];
    [textView setTextColor:RGBA(80, 80, 80, 1)];
    [self.mianZeView addSubview:textView];
    
    UIButton * sureBtn = [FlanceTools buttonCreateWithFrame:CGRectMake((CGRectGetWidth(self.mianZeView.frame) - FitSizeW(100)) / 2, CGRectGetMaxY(textView.frame) + FitSizeH(20), FitSizeW(100), FitSizeH(30)) Title:@"确定" Font:15 IsBold:YES TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:nil Target:self Action:@selector(click_mainControl)];
    [sureBtn setBackgroundColor:RGBA(238, 82, 82, 1)];
    sureBtn.layer.cornerRadius = 3;
    sureBtn.layer.masksToBounds = YES;
    [self.mianZeView addSubview:sureBtn];
}

- (void)click_mainControl
{
    NSString * mianzeStr = @"2.0";
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:mianzeStr forKey:@"mianzeStr"];
    
    self.mainControl.hidden = YES;
    [self.mianZeView removeFromSuperview];
}


- (void)initNavigationView
{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:RGBA(238, 82, 82, 1) BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    
    self.searchBGBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(FitSizeW(90),STATUS_BAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - FitSizeH(30)) / 2, FitSizeW(270), FitSizeH(30)) Title:@"请输入关键字" Font:14 IsBold:NO TitleColor:RGBA(123, 123, 123, 1.0) TitleSelectColor:RGBA(123, 123, 123, 1.0) ImageName:@"ic_sgiys" Target:self Action:@selector(click_searchBtn:)];
    [self.searchBGBtn setBackgroundColor:[UIColor whiteColor]];
    self.searchBGBtn.layer.cornerRadius = FitSizeH(15);
    self.searchBGBtn.layer.masksToBounds = YES;
    [self.searchBGBtn setImageEdgeInsets:UIEdgeInsetsMake(0, - FitSizeW(160), 0, 0)];
    [self.searchBGBtn setTitleEdgeInsets:UIEdgeInsetsMake(-FitSizeH(1), - FitSizeW(161), 0, 0)];
    [self.navigationView addSubview:self.searchBGBtn];
    
    self.cityBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - FitSizeH(30)) / 2, FitSizeW(90), FitSizeH(30)) Title:@"  沈阳" Font:15 IsBold:NO TitleColor:[UIColor whiteColor] TitleSelectColor:[UIColor whiteColor] ImageName:@"dingweibai" Target:self Action:@selector(click_selectCityBtn:)];
    [self.navigationView addSubview:self.cityBtn];
}

- (void)initView{
    currentBtn.tag = 1000;
    
    self.classifyView = [FlanceTools viewCreateWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, FitSizeH(48)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.classifyView];
    
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitSizeH(48))];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.classifyView addSubview:self.mainScrollView];
    
    NSArray * classifyArr = @[@"推荐",@"通告",@"招聘",@"新闻",@"家政",@"租房",@"买卖",@"相约",@"其他"];
    self.mainScrollView.contentSize = CGSizeMake(classifyArr.count * (SCREEN_WIDTH / 8), 0);
    for (int i = 0; i < classifyArr.count; i ++) {
        UIButton * classifyBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(i * (SCREEN_WIDTH / 8), 0, SCREEN_WIDTH / 8, FitSizeH(44)) Title:classifyArr[i] Font:15 IsBold:NO TitleColor:RGBA(15, 15, 15, 1.0) TitleSelectColor:RGBA(237, 64, 64, 1) ImageName:nil Target:self Action:@selector(click_classifyBtn:)];
        if (i == 0) {
            classifyBtn.selected = YES;
            classifyBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            currentBtn = classifyBtn;
        }else{
            classifyBtn.selected = NO;
        }
        classifyBtn.tag = 1000 + i;
        [self.mainScrollView addSubview:classifyBtn];
    }
    
    self.classifyLineView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(46), classifyArr.count * (SCREEN_WIDTH / 8), FitSizeH(0.5)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
    [self.mainScrollView addSubview:self.classifyLineView];
    
    self.radView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(10), CGRectGetMidY(self.classifyLineView.frame) - FitSizeH(2), FitSizeW(14), FitSizeH(4)) BgColor:RGBA(237, 64, 64, 1) BgImage:nil];
    self.radView.layer.cornerRadius = FitSizeH(2);
    [self.mainScrollView addSubview:self.radView];
    

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,CGRectGetMaxY(self.classifyView.frame), SCREEN_WIDTH, ScreenSizeHeight - CGRectGetMaxY(self.classifyView.frame) - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    self.tableView.showsVerticalScrollIndicator = NO;
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //cell无数据时，不显示间隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:v];
    [self.view addSubview:_tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self->page = 1;
        
        if (currentBtn.tag == 1006) {
            //买卖
            [self doGetGoodsLists];
            
        }else if (currentBtn.tag == 1000){
            //推荐
            [self doGetRecommendRecommend_lists];

        }else if (currentBtn.tag == 1001){
            //通告
            [self doGetNoticeLists];

        }else if (currentBtn.tag == 1002){
            
            [self doGetRecruitstaffLists];
            
        }else if (currentBtn.tag == 1003){
            
            [self doGetNewslLists];

        }else if (currentBtn.tag == 1004){

            [self doGetRecruithousekeepLists];

        }else if (currentBtn.tag == 1005){

            [self doGetLeaseLists];

        }else if (currentBtn.tag == 1007){

            [self doGetAppointmentLists];

        }else if (currentBtn.tag == 1008){

            [self doGetElsesLists];
            
        }
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadOnceData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadRecommendMoreData)];
    
    self.noDataView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(178), SCREEN_WIDTH, FitSizeH(180)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.noDataView];
    self.noDataView.hidden = YES;
    
    UIImageView * noDataImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake((SCREEN_WIDTH - FitSizeW(130)) / 2, FitSizeH(10), FitSizeW(130), FitSizeH(130)) ImageName:@"wuneir"];
    [self.noDataView addSubview:noDataImageView];
    
    UILabel * noDataLabel = [FlanceTools labelCreateWithFrame:CGRectMake(0, CGRectGetMaxY(noDataImageView.frame), SCREEN_WIDTH, FitSizeH(40)) Font:14 IsBold:NO Text:@"哎呀，这里还没有消息呢？" Color:RGBA(150, 150, 150, 1) Direction:NSTextAlignmentCenter];
    [self.noDataView addSubview:noDataLabel];
    
    
    
    self.searchBGView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) BgColor:RGBA(255, 255, 255, 1.0) BgImage:nil];
    [self.view addSubview:self.searchBGView];
    self.searchBGView.alpha = 0;
    self.searchBGView.hidden = YES;
    UITapGestureRecognizer *keyboardDownTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KeyboardDown)];
    [self.searchBGView addGestureRecognizer:keyboardDownTap];
    
    
    self.sousuoView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(90),STATUS_BAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - FitSizeH(30)) / 2, FitSizeW(270), FitSizeH(30)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
    self.sousuoView.layer.cornerRadius = FitSizeH(15);
    self.sousuoView.layer.masksToBounds = YES;
    [self.searchBGView  addSubview:self.sousuoView];
    
    UIImage * leftImage = [UIImage imageNamed:@"ic_sgiys"];
    UIImageView * leftImageView = [[UIImageView alloc]initWithImage:leftImage];
    self.searchView = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(5), 0, FitSizeW(270), FitSizeH(30)) placeholder:@"请输入关键字" passWord:NO leftImageView:leftImageView rightImageView:nil Font:14 backgRoundImageName:nil];
    self.searchView.backgroundColor = [UIColor clearColor];
    self.searchView.delegate = self;
    self.searchView.returnKeyType = UIReturnKeySearch;
    self.searchView.keyboardType = UIKeyboardTypeDefault;
    [self.sousuoView addSubview:self.searchView];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, CGRectGetMidY(self.sousuoView.frame) - FitSizeH(22), FitSizeW(41), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_searchBackView) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBGView addSubview: self.backBtn];
    
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.frame = CGRectMake(FitSizeW(321),CGRectGetMidY(self.sousuoView.frame) - FitSizeH(22) , FitSizeW(54), FitSizeH(44));
    [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.searchBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(click_goToSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBGView addSubview: self.searchBtn];
    
    
    self.searchScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, SCREENHEIGHT - CGRectGetMaxY(self.navigationView.frame))];
    self.searchScrollView.backgroundColor = [UIColor whiteColor];
    self.searchScrollView.delegate = self;
    self.searchScrollView.showsHorizontalScrollIndicator = NO;
    self.searchScrollView.showsVerticalScrollIndicator = NO;
    [self.searchBGView addSubview:self.searchScrollView];
    
    //热门搜索
    self.topView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitSizeH(130)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.searchScrollView addSubview:self.topView];
    
    UILabel * HotTitleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), 0, SCREEN_WIDTH, FitSizeH(40)) Font:15 IsBold:YES Text:@"热门搜索" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.topView addSubview:HotTitleLabel];
    
    UIView * hotLineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(40), FitSizeW(FitSizeW(345)), FitSizeH(0.8)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
    [self.topView addSubview:hotLineView];
    
    
    
}

-(void)startLocation{
    if ([CLLocationManager locationServicesEnabled]) {//判断定位操作是否被允许
        
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;//遵循代理
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.locationManager.distanceFilter = 10.0f;
        
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8以上版本定位需要）
        
        [self.locationManager startUpdatingLocation];//开始定位
        
    }else{//不能定位用户的位置的情况再次进行判断，并给与用户提示
        
        //1.提醒用户检查当前的网络状况
        
        //2.提醒用户打开定位开关
    }
    
}

#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    
    //当前所在城市的坐标值
    CLLocation *currLocation = [locations lastObject];
    
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    
    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *address = [placemark addressDictionary];
            
            //  Country(国家)  State(省)  City（市） SubLocality(区)
            NSLog(@"#####%@",address);
            
            NSLog(@"%@", [address objectForKey:@"Country"]);
            
            NSLog(@"%@", [address objectForKey:@"State"]);
            
            NSLog(@"%@", [address objectForKey:@"City"]);
            
            NSLog(@"%@",[address objectForKey:@"SubLocality"]);
            
            NSString *nowAddressStr = [[NSString stringWithFormat:@"%@",[address objectForKey:@"City"]] stringByReplacingOccurrencesOfString:@"市" withString:@""];
            NSString * SubLocality = [NSString stringWithFormat:@"%@",[address objectForKey:@"SubLocality"]];
            currentCityStr = nowAddressStr;
            if (currentCityStr.length > 0 && ![currentCityStr isEqualToString:@"(null)"]) {
                [self.locationManager stopUpdatingLocation];
                NSLog(@"停止定位");
                [self.cityBtn setTitle:SubLocality forState:UIControlStateNormal];
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                //记录当前城市
                
                [userDefaultes setObject:currentCityStr forKey:@"currentCityStr"];
            }else{
                [self.locationManager stopUpdatingLocation];
                
                [self.cityBtn setTitle:@"沈阳" forState:UIControlStateNormal];
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                //记录当前城市
                
                [userDefaultes setObject:@"沈阳" forKey:@"currentCityStr"];
            }
        }
        
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if ([error code] == kCLErrorDenied){
        NSLog(@"访问被拒绝");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法获取位置信息，请前往设置->小城大事->【位置】进行设置" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];if( [[UIApplication sharedApplication] canOpenURL:url]) {[[UIApplication sharedApplication] openURL:url];}
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法获取位置信息，请前往设置->小城大事->【位置】进行设置" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];if( [[UIApplication sharedApplication] canOpenURL:url]) {[[UIApplication sharedApplication] openURL:url];}
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark 点击顶部分类
- (void)click_classifyBtn:(UIButton *)sender
{
    NSArray * classifyArr = @[@"推荐",@"通告",@"招聘",@"新闻",@"家政",@"租房",@"买卖",@"相约",@"其他"];
    for (int i = 0; i < classifyArr.count; i ++) {
        UIButton * button = (UIButton *)[self.mainScrollView viewWithTag:1000 + i];
        button.selected = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    sender.selected = !sender.selected;
    currentBtn = sender;
    sender.titleLabel.font = [UIFont systemFontOfSize:17];
    
    
    if (sender.tag == 1006) {
        //买卖
        self->page = 1;
        [self doGetGoodsLists];
    }else if (sender.tag == 1000){
        //推荐

        self->page = 1;
        [self doGetRecommendRecommend_lists];
    }else if (sender.tag == 1001){
        //通告
        self->page = 1;
        [self doGetNoticeLists];
    }else if (sender.tag == 1002){
        self->page = 1;
        [self doGetRecruitstaffLists];
    }else if (sender.tag == 1003){
        self->page = 1;
        [self doGetNewslLists];
    }else if (sender.tag == 1004){
        self->page = 1;
        [self doGetRecruithousekeepLists];
    }else if (sender.tag == 1005){
        self->page = 1;
        [self doGetLeaseLists];
    }else if (sender.tag == 1007){
        self->page = 1;
        [self doGetAppointmentLists];
    }else if (sender.tag == 1008){
        self->page = 1;
        [self doGetElsesLists];
    }
    
    [UIView animateWithDuration:0.24 animations:^{
        self.radView.frame = CGRectMake(CGRectGetMinX(sender.frame) + FitSizeW(10),CGRectGetMidY(self.classifyLineView.frame) - FitSizeH(2), FitSizeW(14), FitSizeH(4));
    }];
    [self.tableView reloadData];
}

// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (currentBtn.tag == 1000) {
        return self->mutaRecommendArr.count;
    }else if (currentBtn.tag == 1001) {
        return self->MutaNoticeArr.count;
    }else if (currentBtn.tag == 1002) {
        return self->mutaRecruitmentArr.count;
    }else if (currentBtn.tag == 1003) {
        return self->MutaNewsArr.count;
    }else if (currentBtn.tag == 1004) {
        return self->mutaRecruithousekeepArr.count;
    }else if (currentBtn.tag == 1005) {
        return self->mutaLeaseArr.count;
    }else if (currentBtn.tag == 1006) {
        return self->mutaGoodsArr.count;
    }else if (currentBtn.tag == 1007) {
        return self->mutaFriendArr.count;
    }else{
        return self->mutaElseArr.count;
    }
}
/**
 *  设置行高
 */
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (currentBtn.tag == 1002 ||currentBtn.tag == 1004 ||currentBtn.tag == 1007||currentBtn.tag == 1008||currentBtn.tag == 1006) {
        return FitSizeH(130);
    }else{
        return FitSizeH(120);
    }
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (currentBtn.tag == 1000 ||currentBtn.tag == 1001 ||currentBtn.tag == 1003) {
        //推荐、新闻、通告
        NSString * identifier= @"RecommendedCell";
        RecommendedCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[RecommendedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (currentBtn.tag == 1000) {
           cell.dic = self->mutaRecommendArr[indexPath.row];
        }else if (currentBtn.tag == 1001){
            cell.dic = self->MutaNoticeArr[indexPath.row];
        }else{
            cell.dic = self->MutaNewsArr[indexPath.row];
        }
        
        return cell;
    }else if (currentBtn.tag == 1002){
        NSString * identifier= @"RecruitmentCell";
        RecruitmentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[RecruitmentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dic = self->mutaRecruitmentArr[indexPath.row];
        return cell;
    }else if (currentBtn.tag == 1004){
     
        NSString * identifier= @"HousekeepingCell";
        HousekeepingCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[HousekeepingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dic = self->mutaRecruithousekeepArr[indexPath.row];
        return cell;
    }else if (currentBtn.tag == 1005){
        NSString * identifier= @"RentHouseCell";
        RentHouseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[RentHouseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dic = self->mutaLeaseArr[indexPath.row];
        return cell;
    }else if (currentBtn.tag == 1006){
        NSString * identifier= @"BuyingSellingCell";
        BuyingSellingCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[BuyingSellingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dic = self->mutaGoodsArr[indexPath.row];
        return cell;
    }else if (currentBtn.tag == 1007){
        NSString * identifier= @"OnADateCell";
        OnADateCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[OnADateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dic = self->mutaFriendArr[indexPath.row];
        return cell;
    }else{
     
        NSString * identifier= @"ElseCell";
        ElseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ElseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dic = self->mutaElseArr[indexPath.row];
        return cell;
    }
    
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentBtn.tag == 1000) {
        NSDictionary * dic = self->mutaRecommendArr[indexPath.row];
        WebViewController * navc = [[WebViewController alloc]init];
        navc.type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        navc.isRecommend = @"1";
        navc.type_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type_id"]];
        navc.titleStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
        
    }else if (currentBtn.tag == 1001){
        NSDictionary * dic = self->MutaNoticeArr[indexPath.row];
        WebViewController * navc = [[WebViewController alloc]init];
        navc.type = @"notice";
        navc.titleStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
    }else if (currentBtn.tag == 1002){
        NSDictionary * dic = self->mutaRecruitmentArr[indexPath.row];
        RecruitmentDetailsViewController * navc = [[RecruitmentDetailsViewController alloc]init];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
    }else if (currentBtn.tag == 1003){
        NSDictionary * dic = self->MutaNewsArr[indexPath.row];
        WebViewController * navc = [[WebViewController alloc]init];
        navc.type = @"news";
        navc.titleStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
    }else if (currentBtn.tag == 1004){
        NSDictionary * dic = self->mutaRecruithousekeepArr[indexPath.row];
        HousekeepingDetailViewController * navc = [[HousekeepingDetailViewController alloc]init];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
    }else if (currentBtn.tag == 1005){
        //租房
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary * dic = self->mutaLeaseArr[indexPath.row];
        RentHouseDetailViewController * navc = [[RentHouseDetailViewController alloc]init];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        NSMutableArray * infoImageArr = [NSMutableArray array];
        NSString * imageStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"image"]];
        NSArray *imageArr = [imageStr componentsSeparatedByString:@","];
        for (int i = 0; i < imageArr.count; i ++) {
            NSString * imageUrlStr = [NSString stringWithFormat:@"%@%@",RBDom,imageArr[i]];
            NSURL * imageUrl = [NSURL URLWithString:imageUrlStr];
            SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
            [manager loadImageWithURL:imageUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                [infoImageArr addObject:image];
                if (infoImageArr.count == imageArr.count) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"infoImageArr==============%@",infoImageArr);
                    navc.detailImageArr = infoImageArr;
                    [self.navigationController pushViewController:navc animated:YES];
                }
            }];
        }
        
    }else if (currentBtn.tag == 1006){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary * dic = self->mutaGoodsArr[indexPath.row];
        BaySellDetailViewController * navc = [[BaySellDetailViewController alloc]init];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        NSMutableArray * infoImageArr = [NSMutableArray array];
        NSString * imageStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"image"]];
        NSArray *imageArr = [imageStr componentsSeparatedByString:@","];
        for (int i = 0; i < imageArr.count; i ++) {
            NSString * imageUrlStr = [NSString stringWithFormat:@"%@%@",RBDom,imageArr[i]];
            NSURL * imageUrl = [NSURL URLWithString:imageUrlStr];
            SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
            [manager loadImageWithURL:imageUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                [infoImageArr addObject:image];
                if (infoImageArr.count == imageArr.count) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"infoImageArr==============%@",infoImageArr);
                    navc.detailImageArr = infoImageArr;
                    [self.navigationController pushViewController:navc animated:YES];
                }
            }];
        }
    }else if (currentBtn.tag == 1007){
        NSDictionary * dic = self->mutaFriendArr[indexPath.row];
        FriendDetailViewController * navc = [[FriendDetailViewController alloc]init];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
    }else{
        NSDictionary * dic = self->mutaElseArr[indexPath.row];
        ElseDetailViewController * navc = [[ElseDetailViewController alloc]init];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
    }
}


#pragma mark 点击选择城市
- (void)click_selectCityBtn:(UIButton *)sender
{
//    __weak typeof(self) weakSelf = self;
    CityViewController *controller = [[CityViewController alloc] init];
    controller.currentCityString = self->currentCityStr;
    controller.selectString = ^(NSString *string){
        self->currentSelectedCityStr = string;
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        [userDefaultes setObject:currentSelectedCityStr forKey:@"currentCityStr"];
        [sender setTitle:[NSString stringWithFormat:@" %@",string] forState:UIControlStateNormal];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self->page = 1;
        
        if (currentBtn.tag == 1006) {
            //买卖
            [self doGetGoodsLists];
            
        }else if (currentBtn.tag == 1000){
            //推荐
            [self doGetRecommendRecommend_lists];
            
        }else if (currentBtn.tag == 1001){
            //通告
            [self doGetNoticeLists];
            
        }else if (currentBtn.tag == 1002){
            
            [self doGetRecruitstaffLists];
            
        }else if (currentBtn.tag == 1003){
            
            [self doGetNewslLists];
            
        }else if (currentBtn.tag == 1004){
            
            [self doGetRecruithousekeepLists];
            
        }else if (currentBtn.tag == 1005){
            
            [self doGetLeaseLists];
            
        }else if (currentBtn.tag == 1007){
            
            [self doGetAppointmentLists];
            
        }else if (currentBtn.tag == 1008){
            
            [self doGetElsesLists];
            
        }

    [self.tableView.mj_header beginRefreshing];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)click_searchBtn:(UIButton *)sender
{
//    SearchViewController * navc = [[SearchViewController alloc]init];
//    [self.navigationController pushViewController:navc animated:YES];
    
    self.searchBGView.hidden = NO;
    self.tabBarController.tabBar.hidden=YES;
    [self.searchView becomeFirstResponder];
    self.footerView = [FlanceTools viewCreateWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) + FitSizeH(7), SCREEN_WIDTH, FitSizeH(114)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.searchScrollView addSubview:self.footerView];
    
    UILabel * historyTextLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(11), 0, FitSizeW(80), FitSizeH(29)) Font:14 IsBold:NO Text:@"历史搜索" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.footerView addSubview:historyTextLabel];
    
    UIView * lineView1 = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(11), CGRectGetMaxY(historyTextLabel.frame), FitSizeW(353), FitSizeH(0.5)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
    [self.footerView addSubview:lineView1];
    
    UIButton * deleteBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(70), 0, FitSizeW(65), FitSizeH(29)) Title:@"清空" Font:14 IsBold:NO TitleColor:RGBA(150, 150, 150, 1.0) TitleSelectColor:RGBA(150, 150, 150, 1.0) ImageName:@"shanc" Target:self Action:@selector(deleteHistory)];
    [self.footerView addSubview:deleteBtn];
    
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSArray * userHistory = [userDefaultes arrayForKey:@"SearchHistoryArr"];
    historyArr = userHistory;
    CGFloat historyW = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat historyH = FitSizeH(10) + CGRectGetMaxY(lineView1.frame);//用来控制button距离父视图的高
    for (int i = 0; i < historyArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 2000 + i;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(click_historyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:RGBA(15, 15, 15, 1) forState:UIControlStateNormal];
        //根据计算文字的大小
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGFloat length = [historyArr[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:historyArr[i] forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(FitSizeW(10) + historyW, historyH, length + FitSizeW(30) , FitSizeH(30));
        button.layer.borderWidth = 1;
        button.layer.borderColor = [RGBA(150, 150, 150, 1)CGColor];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(FitSizeW(10) + historyW + length + FitSizeW(15) > SCREEN_WIDTH){
            historyW = 0; //换行时将w置为0
            historyH = historyH + button.frame.size.height + FitSizeH(10);//距离父视图也变化
            button.frame = CGRectMake(FitSizeW(10) + historyW, historyH, length + FitSizeW(30), FitSizeH(30));//重设button的frame
        }
        historyW = button.frame.size.width + button.frame.origin.x;
        [self.footerView addSubview:button];
    }
    self.searchView.text = @"";
    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame) + FitSizeH(7), SCREEN_WIDTH, historyH + FitSizeH(50));
    [UIView animateWithDuration:0.24 animations:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        self.searchBGView.alpha = 1;
        self.sousuoView.frame = CGRectMake(FitSizeW(41),STATUS_BAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - FitSizeH(30)) / 2, FitSizeW(280), FitSizeH(30));
    }];
    
    self.searchScrollView.contentSize = CGSizeMake(0,CGRectGetMaxY(self.footerView.frame));
}

- (void)click_searchBackView
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIView animateWithDuration:0.24 animations:^{
        self.sousuoView.frame = CGRectMake(FitSizeW(90),STATUS_BAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - FitSizeH(30)) / 2, FitSizeW(270), FitSizeH(30));
        [self.searchView resignFirstResponder];
        self.searchBGView.alpha = 0;
    } completion:^(BOOL finished) {
        self.searchBGView.hidden = YES;
        self.tabBarController.tabBar.hidden=NO;
        [self.footerView removeFromSuperview];
    }];
}




- (void)loadRecommendMoreData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self->page ++;
    if (currentBtn.tag == 1006) {
        //买卖
        [self doGetGoodsLists];
        
    }else if (currentBtn.tag == 1000){
        //推荐
        [self doGetRecommendRecommend_lists];
        
    }else if (currentBtn.tag == 1001){
        //通告
        [self doGetNoticeLists];
        
    }else if (currentBtn.tag == 1002){
        
        [self doGetRecruitstaffLists];
        
    }else if (currentBtn.tag == 1003){
        
        [self doGetNewslLists];
        
    }else if (currentBtn.tag == 1004){
        
        [self doGetRecruithousekeepLists];
        
    }else if (currentBtn.tag == 1005){
        
        [self doGetLeaseLists];
        
    }else if (currentBtn.tag == 1007){
        
        [self doGetAppointmentLists];
        
    }else if (currentBtn.tag == 1008){
        
        [self doGetElsesLists];
        
    }
}

#pragma mark 获取推荐列表
- (void)doGetRecommendRecommend_lists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",RecommendRecommend_lists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * cityStr = [NSString stringWithFormat:@"%@市",[userDefaultes stringForKey:@"currentCityStr"]];
    NSDictionary *parameters = @{@"num":@"10",@"page":pageNum,@"city":cityStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"RecommendRecommend_lists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->recommendArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                mutaRecommendArr = [NSMutableArray array];
                self->mutaRecommendArr  = [NSMutableArray arrayWithArray:self->recommendArr];
                NSLog(@"mutaRecommendArr ====%@",self->mutaRecommendArr);
            }else{
                [self->mutaRecommendArr addObjectsFromArray:self->recommendArr];
                NSLog(@"mutaRecommendArr ====%@",self->mutaRecommendArr);
            }
            if (self->mutaRecommendArr.count != 0) {
                self.noDataView.hidden = YES;
            }else{
                self.noDataView.hidden = NO;
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            // 隐藏当前的上拉刷新控件
            int allpage = [[dataDic valueForKey:@"allpage"]intValue];
            if (self->page == allpage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
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

#pragma mark 通告列表
- (void)doGetNoticeLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",NoticeLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * cityStr = [NSString stringWithFormat:@"%@市",[userDefaultes stringForKey:@"currentCityStr"]];
    NSDictionary *parameters = @{@"num":@"10",@"page":pageNum,@"city":cityStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"NoticeLists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->noticeArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                MutaNoticeArr = [NSMutableArray array];
                self->MutaNoticeArr  = [NSMutableArray arrayWithArray:self->noticeArr];
                NSLog(@"MutaNoticeArr ====%@",self->MutaNoticeArr);
            }else{
                [self->MutaNoticeArr addObjectsFromArray:self->noticeArr];
                NSLog(@"MutaNoticeArr ====%@",self->MutaNoticeArr);
            }
            if (self->MutaNoticeArr.count != 0) {
                self.noDataView.hidden = YES;
            }else{
                self.noDataView.hidden = NO;
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            // 隐藏当前的上拉刷新控件
            int allpage = [[dataDic valueForKey:@"allpage"]intValue];
            if (self->page == allpage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
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

#pragma mark 新闻列表
- (void)doGetNewslLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",NewslLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * cityStr = [NSString stringWithFormat:@"%@市",[userDefaultes stringForKey:@"currentCityStr"]];
    NSDictionary *parameters = @{@"num":@"10",@"page":pageNum,@"city":cityStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"NewslLists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->newsArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                MutaNewsArr = [NSMutableArray array];
                
                self->MutaNewsArr  = [NSMutableArray arrayWithArray:self->newsArr];
                NSLog(@"MutaNewsArr ====%@",self->MutaNewsArr);
            }else{
                [self->MutaNewsArr addObjectsFromArray:self->newsArr];
                NSLog(@"MutaNewsArr ====%@",self->MutaNewsArr);
            }
            [self.tableView reloadData];
            if (self->MutaNewsArr.count != 0) {
                self.noDataView.hidden = YES;
            }else{
                self.noDataView.hidden = NO;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            // 隐藏当前的上拉刷新控件
            int allpage = [[dataDic valueForKey:@"allpage"]intValue];
            if (self->page == allpage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
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

#pragma mark 招聘列表
- (void)doGetRecruitstaffLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",RecruitstaffLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * cityStr = [NSString stringWithFormat:@"%@市",[userDefaultes stringForKey:@"currentCityStr"]];
    NSDictionary *parameters = @{@"num":@"10",@"page":pageNum,@"user":@"0",@"token":@"",@"city":cityStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"NewslLists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->recruitmentArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                mutaRecruitmentArr = [NSMutableArray array];
                
                self->mutaRecruitmentArr  = [NSMutableArray arrayWithArray:self->recruitmentArr];
                NSLog(@"mutaRecruitmentArr ====%@",self->mutaRecruitmentArr);
            }else{
                [self->mutaRecruitmentArr addObjectsFromArray:self->recruitmentArr];
                NSLog(@"mutaRecruitmentArr ====%@",self->mutaRecruitmentArr);
            }
            [self.tableView reloadData];
            if (self->mutaRecruitmentArr.count != 0) {
                self.noDataView.hidden = YES;
            }else{
                self.noDataView.hidden = NO;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            // 隐藏当前的上拉刷新控件
            int allpage = [[dataDic valueForKey:@"allpage"]intValue];
            if (self->page == allpage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
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

#pragma mark 家政列表
- (void)doGetRecruithousekeepLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",RecruithousekeepLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * cityStr = [NSString stringWithFormat:@"%@市",[userDefaultes stringForKey:@"currentCityStr"]];
    NSDictionary *parameters = @{@"num":@"10",@"page":pageNum,@"user":@"0",@"token":@"",@"city":cityStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"NewslLists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->recruithousekeepArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                
                mutaRecruithousekeepArr = [NSMutableArray array];
                
                self->mutaRecruithousekeepArr  = [NSMutableArray arrayWithArray:self->recruithousekeepArr];
                NSLog(@"mutaRecruithousekeepArr ====%@",self->mutaRecruithousekeepArr);
            }else{
                [self->mutaRecruitmentArr addObjectsFromArray:self->recruithousekeepArr];
                NSLog(@"mutaRecruithousekeepArr ====%@",self->mutaRecruithousekeepArr);
            }
            [self.tableView reloadData];
            if (self->mutaRecruithousekeepArr.count != 0) {
                self.noDataView.hidden = YES;
            }else{
                self.noDataView.hidden = NO;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            // 隐藏当前的上拉刷新控件
            int allpage = [[dataDic valueForKey:@"allpage"]intValue];
            if (self->page == allpage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
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


#pragma mark 租房列表
- (void)doGetLeaseLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",LeaseLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * cityStr = [NSString stringWithFormat:@"%@市",[userDefaultes stringForKey:@"currentCityStr"]];
    NSDictionary *parameters = @{@"num":@"10",@"page":pageNum,@"user":@"0",@"token":@"",@"city":cityStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"NewslLists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->leaseArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                mutaLeaseArr = [NSMutableArray array];
                self->mutaLeaseArr  = [NSMutableArray arrayWithArray:self->leaseArr];
                NSLog(@"mutaLeaseArr ====%@",self->mutaLeaseArr);
            }else{
                [self->mutaLeaseArr addObjectsFromArray:self->leaseArr];
                NSLog(@"mutaLeaseArr ====%@",self->mutaLeaseArr);
            }
            [self.tableView reloadData];
            if (self->mutaLeaseArr.count != 0) {
                self.noDataView.hidden = YES;
            }else{
                self.noDataView.hidden = NO;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            // 隐藏当前的上拉刷新控件
            int allpage = [[dataDic valueForKey:@"allpage"]intValue];
            if (self->page == allpage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
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

#pragma mark 商品列表
- (void)doGetGoodsLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",GoodsLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * cityStr = [NSString stringWithFormat:@"%@市",[userDefaultes stringForKey:@"currentCityStr"]];
    NSDictionary *parameters = @{@"num":@"10",@"page":pageNum,@"user":@"0",@"token":@"",@"city":cityStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"NewslLists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->goodsArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                mutaGoodsArr = [NSMutableArray array];
                
                self->mutaGoodsArr  = [NSMutableArray arrayWithArray:self->goodsArr];
                NSLog(@"mutaGoodsArr ====%@",self->mutaGoodsArr);
            }else{
                [self->mutaGoodsArr addObjectsFromArray:self->goodsArr];
                NSLog(@"mutaGoodsArr ====%@",self->mutaGoodsArr);
            }
            [self.tableView reloadData];
            if (self->mutaGoodsArr.count != 0) {
                self.noDataView.hidden = YES;
            }else{
                self.noDataView.hidden = NO;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            // 隐藏当前的上拉刷新控件
            int allpage = [[dataDic valueForKey:@"allpage"]intValue];
            if (self->page == allpage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
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


#pragma mark 交友列表
- (void)doGetAppointmentLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",AppointmentLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * cityStr = [NSString stringWithFormat:@"%@市",[userDefaultes stringForKey:@"currentCityStr"]];
    NSDictionary *parameters = @{@"num":@"10",@"page":pageNum,@"user":@"0",@"token":@"",@"city":cityStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"NewslLists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->friendArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                mutaFriendArr = [NSMutableArray array];
                
                self->mutaFriendArr  = [NSMutableArray arrayWithArray:self->friendArr];
                NSLog(@"mutaGoodsArr ====%@",self->mutaFriendArr);
            }else{
                [self->mutaFriendArr addObjectsFromArray:self->friendArr];
                NSLog(@"mutaGoodsArr ====%@",self->mutaFriendArr);
            }
            [self.tableView reloadData];
            if (self->mutaFriendArr.count != 0) {
                self.noDataView.hidden = YES;
            }else{
                self.noDataView.hidden = NO;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            // 隐藏当前的上拉刷新控件
            int allpage = [[dataDic valueForKey:@"allpage"]intValue];
            if (self->page == allpage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
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

#pragma mark 其他
- (void)doGetElsesLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",ElsesLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSString * cityStr = [NSString stringWithFormat:@"%@市",[userDefaultes stringForKey:@"currentCityStr"]];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"num":@"10",@"page":pageNum,@"user":@"0",@"token":tokenStr,@"city":cityStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"ElsesLists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->elseArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                mutaElseArr = [NSMutableArray array];
                self->mutaElseArr  = [NSMutableArray arrayWithArray:self->elseArr];
                NSLog(@"mutaElseArr ====%@",self->mutaElseArr);
            }else{
                [self->mutaElseArr addObjectsFromArray:self->elseArr];
                NSLog(@"mutaElseArr ====%@",self->mutaElseArr);
            }
            [self.tableView reloadData];
            if (self->mutaElseArr.count != 0) {
                self.noDataView.hidden = YES;
            }else{
                self.noDataView.hidden = NO;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            // 隐藏当前的上拉刷新控件
            int allpage = [[dataDic valueForKey:@"allpage"]intValue];
            if (self->page == allpage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
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


#pragma mark 热门搜索
- (void)doGetIndexHot_search
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",IndexHot_search];
    //构造参数
    
    NSDictionary *parameters = @{@"num":@"10",@"page":@"1"};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"IndexHot_search responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary * dic = [responseObject objectForKey:@"data"];
            self->hotDataArr = [dic objectForKey:@"data"];
            [self valueForTopView:self->hotDataArr];
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

- (void)valueForTopView:(NSArray *)dataArr
{
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = FitSizeH(50);//用来控制button距离父视图的高
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary * dataDic = dataArr[i];
        NSString * buttonTitleStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"title"]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 1000 + i;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(click_hotSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:RGBA(15, 15, 15, 1) forState:UIControlStateNormal];
        //根据计算文字的大小
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGFloat length = [buttonTitleStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:buttonTitleStr forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(FitSizeW(10) + w, h, length + FitSizeW(30) , FitSizeH(30));
        button.layer.borderWidth = 1;
        button.layer.borderColor = [RGBA(150, 150, 150, 1)CGColor];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(FitSizeW(10) + w + length + FitSizeW(25) > SCREEN_WIDTH){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + FitSizeH(10);//距离父视图也变化
            button.frame = CGRectMake(FitSizeW(10) + w, h, length + FitSizeW(30), FitSizeH(30));//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [self.topView addSubview:button];
    }
    
    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, h + FitSizeH(40));
    
}

#pragma mark 点击键盘搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if (self.searchView.text.length > 0) {
        [self click_searchBackView];
        NSUserDefaults *userDefaultes = LDUserDefaults;
        NSArray * userHistory = [userDefaultes arrayForKey:@"SearchHistoryArr"];
        if (self.searchView.text.length > 0) {
            [historyMutaArr addObject:self.searchView.text];
        }
        [self->historyMutaArr addObjectsFromArray:userHistory];
        historyArr = historyMutaArr;
        NSArray *resultArr = [historyArr valueForKeyPath:@"@distinctUnionOfObjects.self"];
        [userDefaultes setObject:resultArr forKey:@"SearchHistoryArr"];
        
        SearchResultViewController * navc = [[SearchResultViewController alloc]init];
        navc.currentSearchStr = self.searchView.text;
        [self.navigationController pushViewController:navc animated:YES];
        return YES;
    }else{
        [self showAlert:@"输入搜索内容"];
        [self.searchView becomeFirstResponder];
        return NO;
    }
}

- (void)click_historyBtn:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    NSString * titleStr = sender.titleLabel.text;
    
    self.searchView.text = titleStr;
}

#pragma mark 删除历史
- (void)deleteHistory{
    NSArray * clearArr = [NSArray new];
    NSLog(@"%lu",(unsigned long)historyArr.count);
    NSLog(@"%lu",(unsigned long)historyMutaArr.count);
    
    NSUserDefaults *userDefaultes = LDUserDefaults;
    [userDefaultes setObject:clearArr forKey:@"SearchHistoryArr"];
    
    UIButton * button = (UIButton *)[self.footerView viewWithTag:2000];
    
    if (historyArr.count>0) {
        if (button == nil) {
            [self showAlert:@"无历史数据"];
        }else{
            [self showAlert:@"已清空历史"];
        }
    }else{
        [self showAlert:@"无历史数据"];
    }
    
    for (int i = 0; i < historyArr.count; i ++) {
        UIButton * button = (UIButton *)[self.footerView viewWithTag:2000 + i];
        [button removeFromSuperview];
    }
    [historyMutaArr removeAllObjects];
    historyArr = clearArr;
}

- (void)click_goToSearchBtn
{
    NSLog(@"点击了搜索");
    
    if (self.searchView.text.length > 0) {
        [self click_searchBackView];
        SearchResultViewController * navc = [[SearchResultViewController alloc]init];
        navc.currentSearchStr = self.searchView.text;
        [self.navigationController pushViewController:navc animated:YES];
    }else{
        [self showAlert:@"输入搜索内容"];
        [self.searchView becomeFirstResponder];
        return;
    }
    [self.searchView resignFirstResponder];
    NSUserDefaults *userDefaultes = LDUserDefaults;
    NSArray * userHistory = [userDefaultes arrayForKey:@"SearchHistoryArr"];
    [historyMutaArr addObject:self.searchView.text];
    [self->historyMutaArr addObjectsFromArray:userHistory];
    historyArr = historyMutaArr;
    NSArray *resultArr = [historyArr valueForKeyPath:@"@distinctUnionOfObjects.self"];
    [userDefaultes setObject:resultArr forKey:@"SearchHistoryArr"];
}

- (void)click_hotSearchBtn:(UIButton *)sender
{
    [self click_searchBackView];
    NSDictionary * dic = self->hotDataArr[sender.tag - 1000];
    self.searchView.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    SearchResultViewController * navc = [[SearchResultViewController alloc]init];
    navc.currentSearchStr = self.searchView.text;
    [self.navigationController pushViewController:navc animated:YES];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
