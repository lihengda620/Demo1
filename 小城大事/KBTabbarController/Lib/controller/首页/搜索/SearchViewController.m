//
//  SearchViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/26.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"

@interface SearchViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UITextField * searchView;
@property (nonatomic, strong) UIButton * searchBtn;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * footerView;

@end

@implementation SearchViewController

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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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
    
    UIView * searchBGView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(41),STATUS_BAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - FitSizeH(30)) / 2, FitSizeW(280), FitSizeH(30)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
    searchBGView.layer.cornerRadius = FitSizeH(15);
    searchBGView.layer.masksToBounds = YES;
    [self.navigationView addSubview:searchBGView];
    
    UIImage * leftImage = [UIImage imageNamed:@"ic_sgiys"];
    UIImageView * leftImageView = [[UIImageView alloc]initWithImage:leftImage];
    self.searchView = [FlanceTools textFieldCreateTextFieldWithFrame:CGRectMake(FitSizeW(5), 0, FitSizeW(270), FitSizeH(30)) placeholder:@"请输入关键字" passWord:NO leftImageView:leftImageView rightImageView:nil Font:14 backgRoundImageName:nil];
    self.searchView.backgroundColor = [UIColor clearColor];
    self.searchView.delegate = self;
    self.searchView.returnKeyType = UIReturnKeySearch;
    self.searchView.keyboardType = UIKeyboardTypeDefault;
    [searchBGView addSubview:self.searchView];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, CGRectGetMidY(searchBGView.frame) - FitSizeH(22), FitSizeW(41), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
    
    
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.frame = CGRectMake(CGRectGetMaxX(searchBGView.frame),CGRectGetMidY(searchBGView.frame) - FitSizeH(22) , SCREEN_WIDTH - CGRectGetMaxX(searchBGView.frame), FitSizeH(44));
    [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.searchBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(click_searchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.searchBtn];
    
    
}

- (void)initView{
    //热门搜索
    self.topView = [FlanceTools viewCreateWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, FitSizeH(130)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.topView];
    
    UILabel * HotTitleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), 0, SCREEN_WIDTH, FitSizeH(40)) Font:15 IsBold:YES Text:@"热门搜索" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.topView addSubview:HotTitleLabel];
    
    UIView * hotLineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(40), FitSizeW(FitSizeW(345)), FitSizeH(0.8)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
    [self.topView addSubview:hotLineView];
    
    NSArray * dataArr = @[@"招聘",@"热门话题",@"胖了呀",@"鸡肉汉堡",@"出租房屋",@"新闻热门头条"];
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = FitSizeH(50);//用来控制button距离父视图的高
    for (int i = 0; i < dataArr.count; i++) {
        
        NSString * buttonTitleStr = dataArr[i];
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
        button.frame = CGRectMake(FitSizeW(15) + w, h, length + FitSizeW(30) , FitSizeH(30));
        button.layer.borderWidth = 1;
        button.layer.borderColor = [RGBA(150, 150, 150, 1)CGColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(FitSizeW(10) + w + length + FitSizeW(25) > SCREEN_WIDTH){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + FitSizeH(10);//距离父视图也变化
            button.frame = CGRectMake(FitSizeW(15) + w, h, length + FitSizeW(30), FitSizeH(30));//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [self.topView addSubview:button];
    }
    
    //历史搜索
    self.footerView = [FlanceTools viewCreateWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) + FitSizeH(10), SCREEN_WIDTH, FitSizeH(120)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.footerView];
    
    UILabel * historyTitleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(FitSizeW(15), 0, SCREEN_WIDTH, FitSizeH(40)) Font:15 IsBold:YES Text:@"历史搜索" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentLeft];
    [self.footerView addSubview:historyTitleLabel];
    
    UIView * historyLineView = [FlanceTools viewCreateWithFrame:CGRectMake(FitSizeW(15), FitSizeH(40), FitSizeW(FitSizeW(345)), FitSizeH(0.8)) BgColor:RGBA(245, 245, 245, 1.0) BgImage:nil];
    [self.footerView addSubview:historyLineView];
    
    UIButton * deleteBtn = [FlanceTools buttonCreateWithFrame:CGRectMake(SCREEN_WIDTH - FitSizeW(60), 0, FitSizeW(50), FitSizeH(29)) Title:@"清空" Font:14 IsBold:NO TitleColor:RGBA(150, 150, 150, 1) TitleSelectColor:RGBA(150, 150, 150, 1) ImageName:@"shanc" Target:self Action:nil];
    [self.footerView addSubview:deleteBtn];
    
    NSArray * historyArr = @[@"招聘",@"热门话题",@"胖了呀",@"鸡肉汉堡"];
    CGFloat historyW = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat historyH = FitSizeH(50);//用来控制button距离父视图的高
    for (int i = 0; i < historyArr.count; i++) {
        
        NSString * buttonTitleStr = dataArr[i];
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
        button.frame = CGRectMake(FitSizeW(15) + historyW, historyH, length + FitSizeW(30) , FitSizeH(30));
        button.layer.borderWidth = 1;
        button.layer.borderColor = [RGBA(150, 150, 150, 1)CGColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(FitSizeW(10) + historyW + length + FitSizeW(25) > SCREEN_WIDTH){
            historyW = 0; //换行时将w置为0
            historyH = historyH + button.frame.size.height + FitSizeH(10);//距离父视图也变化
            button.frame = CGRectMake(FitSizeW(15) + historyW, historyH, length + FitSizeW(30), FitSizeH(30));//重设button的frame
        }
        historyW = button.frame.size.width + button.frame.origin.x;
        [self.footerView addSubview:button];
    }
}

- (void)click_searchBtn
{
    NSLog(@"点击了搜索");
    SearchResultViewController * navc = [[SearchResultViewController alloc]init];
    [self.navigationController pushViewController:navc animated:YES];
}

- (void)click_hotSearchBtn:(UIButton *)sender
{
    
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
