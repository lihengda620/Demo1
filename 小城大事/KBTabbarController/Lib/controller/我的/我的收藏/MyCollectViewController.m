//
//  MyCollectViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/7/1.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MyCollectViewController.h"
#import "MyCollectRecommendedCell.h"
#import "MyCollectRecruitmentCell.h"
#import "MyCollectHousekeepingCell.h"
#import "MyCollectRentHouseCell.h"
#import "MyCollectOnADateCell.h"
#import "MyCollectElseCell.h"
#import "BuyingSellingCollectionCell.h"
#import "MyCollecBaySellCell.h"
#import "MyCollectLivesCell.h"

#import "RecruitmentDetailsViewController.h"
#import "HousekeepingDetailViewController.h"
#import "RentHouseDetailViewController.h"
#import "BaySellDetailViewController.h"
#import "FriendDetailViewController.h"
#import "ElseDetailViewController.h"
#import "HunLianDetailViewController.h"

@interface MyCollectViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MyCollectRecommendedCellDelegate,MyCollectRecruitmentCellDelegate,MyCollectHousekeepingCellDelegate,MyCollectRentHouseCellDelegate,MyCollecBaySellCellDelegate,MyCollectOnADateCellCellDelegate,MyCollectElseCellDelegate,MyCollectLivesCellDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;


@property (nonatomic, strong) UIView * classifyView;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) UIView * classifyLineView;
@property (nonatomic, strong) UIView * radView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIView * noDataView;

@end

@implementation MyCollectViewController
{
    UIButton * currentBtn;
    
    NSIndexPath *cellIndex;
    
    //推荐列表
    NSMutableArray * mutaRecommendArr;
    NSArray * recommendArr;
    NSInteger  page;
    
    //通告列表
    NSMutableArray * MutaNoticeArr;
    NSArray * noticeArr;
    
    //通告列表
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
    
    //婚恋列表
    NSMutableArray * mutaLivesArr;
    NSArray * LivesArr;
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
    mutaRecommendArr = [NSMutableArray array];
    MutaNoticeArr = [NSMutableArray array];
    MutaNewsArr = [NSMutableArray array];
    mutaRecruitmentArr = [NSMutableArray array];
    mutaRecruithousekeepArr = [NSMutableArray array];
    mutaLeaseArr = [NSMutableArray array];
    mutaGoodsArr = [NSMutableArray array];
    mutaFriendArr = [NSMutableArray array];
    mutaElseArr = [NSMutableArray array];
    mutaLivesArr = [NSMutableArray array];
    currentBtn.tag = 1000;
    [self initNavigationView];
    [self initView];
}

- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"我的收藏" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, CGRectGetMidY(self.titleLabel.frame) - FitSizeH(22), FitSizeW(40), FitSizeH(44));
    [self.backBtn setImage:[UIImage imageNamed:@"fanhuio"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview: self.backBtn];
    
}

- (void)initView{
    self.classifyView = [FlanceTools viewCreateWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, FitSizeH(48)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.classifyView];
    
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitSizeH(48))];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.classifyView addSubview:self.mainScrollView];
    
    NSArray * classifyArr = @[@"推荐",@"通告",@"招聘",@"新闻",@"家政",@"租房",@"买卖",@"相约",@"其他",@"婚恋"];
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
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,CGRectGetMaxY(self.classifyView.frame), SCREEN_WIDTH, ScreenSizeHeight - CGRectGetMaxY(self.classifyView.frame)) style:UITableViewStylePlain];
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
    
    self.noDataView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(200), SCREEN_WIDTH, FitSizeH(180)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.noDataView];
    self.noDataView.hidden = YES;
    
    UIImageView * noDataImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake((SCREEN_WIDTH - FitSizeW(130)) / 2, FitSizeH(10), FitSizeW(130), FitSizeH(130)) ImageName:@"wuneir"];
    [self.noDataView addSubview:noDataImageView];
    
    UILabel * noDataLabel = [FlanceTools labelCreateWithFrame:CGRectMake(0, CGRectGetMaxY(noDataImageView.frame), SCREEN_WIDTH, FitSizeH(40)) Font:14 IsBold:NO Text:@"哎呀，这里还没有消息呢？" Color:RGBA(150, 150, 150, 1) Direction:NSTextAlignmentCenter];
    [self.noDataView addSubview:noDataLabel];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self->page = 1;
        if (currentBtn.tag == 1006) {
            //买卖
            [self doGetCollectLists:@"goods"];
        }else if (currentBtn.tag == 1000){
            //推荐
            [self doGetCollectLists:@"recommend"];
        }else if (currentBtn.tag == 1001){
            //通告
            [self doGetCollectLists:@"notice"];
        }else if (currentBtn.tag == 1002){
            [self doGetCollectLists:@"staff"];
        }else if (currentBtn.tag == 1003){
            [self doGetCollectLists:@"news"];
        }else if (currentBtn.tag == 1004){
            [self doGetCollectLists:@"housekeep"];
        }else if (currentBtn.tag == 1005){
            [self doGetCollectLists:@"lease"];
        }else if (currentBtn.tag == 1007){
            [self doGetCollectLists:@"appointment"];
        }else if (currentBtn.tag == 1008){
            [self doGetCollectLists:@"else"];
        }else if (currentBtn.tag == 1009){
            [self doGetCollectLists:@"live"];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadOnceData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadRecommendMoreData)];

}

- (void)loadRecommendMoreData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self->page ++;
    if (currentBtn.tag == 1006) {
        //买卖
        [self doGetCollectLists:@"goods"];
    }else if (currentBtn.tag == 1000){
        //推荐
        [self doGetCollectLists:@"recommend"];
    }else if (currentBtn.tag == 1001){
        //通告
        [self doGetCollectLists:@"notice"];
    }else if (currentBtn.tag == 1002){
        [self doGetCollectLists:@"staff"];
    }else if (currentBtn.tag == 1003){
        [self doGetCollectLists:@"news"];
    }else if (currentBtn.tag == 1004){
        [self doGetCollectLists:@"housekeep"];
    }else if (currentBtn.tag == 1005){
        [self doGetCollectLists:@"lease"];
    }else if (currentBtn.tag == 1007){
        [self doGetCollectLists:@"appointment"];
    }else if (currentBtn.tag == 1008){
        [self doGetCollectLists:@"else"];
    }else if (currentBtn.tag == 1009){
        [self doGetCollectLists:@"live"];
    }
}

#pragma mark 点击顶部分类
- (void)click_classifyBtn:(UIButton *)sender
{
    NSArray * classifyArr = @[@"推荐",@"通告",@"招聘",@"新闻",@"家政",@"租房",@"买卖",@"相约",@"其他",@"婚恋"];
    for (int i = 0; i < classifyArr.count; i ++) {
        UIButton * button = (UIButton *)[self.mainScrollView viewWithTag:1000 + i];
        button.selected = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    sender.selected = !sender.selected;
    currentBtn = sender;
    sender.titleLabel.font = [UIFont systemFontOfSize:17];

    
    [UIView animateWithDuration:0.24 animations:^{
        self.radView.frame = CGRectMake(CGRectGetMinX(sender.frame) + FitSizeW(10),CGRectGetMidY(self.classifyLineView.frame) - FitSizeH(2), FitSizeW(14), FitSizeH(4));
    }];
    
    if (sender.tag == 1006) {
        //买卖
        self->page = 1;
        [self doGetCollectLists:@"goods"];
        
    }else if (sender.tag == 1000){
        //推荐
        
        self->page = 1;
        [self doGetCollectLists:@"recommend"];
        
    }else if (sender.tag == 1001){
        //通告
        self->page = 1;
       [self doGetCollectLists:@"notice"];
        
    }else if (sender.tag == 1002){
        self->page = 1;
        
        [self doGetCollectLists:@"staff"];
    }else if (sender.tag == 1003){
        self->page = 1;
        [self doGetCollectLists:@"news"];
        
    }else if (sender.tag == 1004){
        self->page = 1;
        [self doGetCollectLists:@"housekeep"];
        
    }else if (sender.tag == 1005){
        self->page = 1;
        [self doGetCollectLists:@"lease"];
        
    }else if (sender.tag == 1007){
        self->page = 1;
        [self doGetCollectLists:@"appointment"];
        
    }else if (sender.tag == 1008){
        self->page = 1;
        [self doGetCollectLists:@"else"];
        
    }else if (sender.tag == 1009){
        self->page = 1;
        [self doGetCollectLists:@"live"];
        
    }
    
    
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
    }else if (currentBtn.tag == 1008) {
        return self->mutaElseArr.count;
    }else{
        return self->mutaLivesArr.count;
    }
}
/**
 *  设置行高
 */
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (currentBtn.tag == 1002 ||currentBtn.tag == 1004 ||currentBtn.tag == 1007||currentBtn.tag == 1008) {
        return FitSizeH(170);
    }else{
        return FitSizeH(160);
    }
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (currentBtn.tag == 1000 ||currentBtn.tag == 1001 ||currentBtn.tag == 1003) {
        //推荐、新闻、通告
        NSString * identifier= @"RecommendedCell";
        MyCollectRecommendedCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCollectRecommendedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        if (currentBtn.tag == 1000) {
            cell.dic = self->mutaRecommendArr[indexPath.row];
        }else if (currentBtn.tag == 1001){
            cell.dic = self->MutaNoticeArr[indexPath.row];
        }else{
            cell.dic = self->MutaNewsArr[indexPath.row];
        }
        cell.delegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (currentBtn.tag == 1002){
        NSString * identifier= @"RecruitmentCell";
        MyCollectRecruitmentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCollectRecruitmentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.dic = self->mutaRecruitmentArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (currentBtn.tag == 1004){
        
        NSString * identifier= @"MyCollectHousekeepingCell";
        MyCollectHousekeepingCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCollectHousekeepingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.dic = self->mutaRecruithousekeepArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (currentBtn.tag == 1005){
        NSString * identifier= @"MyCollectRentHouseCell";
        MyCollectRentHouseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCollectRentHouseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.dic = self->mutaLeaseArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (currentBtn.tag == 1006){
        NSString * identifier= @"MyCollecBaySellCell";
        MyCollecBaySellCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCollecBaySellCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.dic = self->mutaGoodsArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (currentBtn.tag == 1007){
        NSString * identifier= @"MyCollectOnADateCell";
        MyCollectOnADateCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCollectOnADateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dic = self->mutaFriendArr[indexPath.row];
        return cell;
    }else if (currentBtn.tag == 1008) {
        
        NSString * identifier= @"MyCollectElseCell";
        MyCollectElseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCollectElseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dic = self->mutaElseArr[indexPath.row];
        return cell;
    }else{
        NSString * identifier= @"MyCollectLivesCell";
        MyCollectLivesCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCollectLivesCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dic = mutaLivesArr[indexPath.row];
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
    }else if (currentBtn.tag == 1008){
        NSDictionary * dic = self->mutaElseArr[indexPath.row];
        ElseDetailViewController * navc = [[ElseDetailViewController alloc]init];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary * dic = mutaLivesArr[indexPath.row];
        
        HunLianDetailViewController * navc = [[HunLianDetailViewController alloc]init];
        
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
    }
}

#pragma mark ——————————————————————————————————————————————————————————新闻 推荐 招聘删除
- (void)clickRecommendedDeleteBtn:(UIButton *)button cell:(MyCollectRecommendedCell *)cell
{
    if (currentBtn.tag == 1000) {
        cellIndex = [_tableView indexPathForCell:cell];
        NSDictionary * dic = [self->mutaRecommendArr objectAtIndex:cellIndex.row];
        NSLog(@"%@",dic);
        NSString * idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self doGetCollectDelete:idStr type:@"recommend"];
    }else if (currentBtn.tag == 1001){
        cellIndex = [_tableView indexPathForCell:cell];
        NSDictionary * dic = [self->MutaNoticeArr objectAtIndex:cellIndex.row];
        NSLog(@"%@",dic);
        NSString * idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self doGetCollectDelete:idStr type:@"notice"];
    }else if (currentBtn.tag == 1003){
        cellIndex = [_tableView indexPathForCell:cell];
        NSDictionary * dic = [self->MutaNewsArr objectAtIndex:cellIndex.row];
        NSLog(@"%@",dic);
        NSString * idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self doGetCollectDelete:idStr type:@"news"];
    }
}

#pragma mark ——————————————————————————————————————————————————————————招聘删除
- (void)clickRecruitmentDeleteBtn:(UIButton *)button cell:(MyCollectRecruitmentCell *)cell
{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaRecruitmentArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    NSString * idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetCollectDelete:idStr type:@"staff"];
}

#pragma mark ——————————————————————————————————————————————————————————家政删除
- (void)clickHousekeepingDeleteBtn:(UIButton *)button cell:(MyCollectHousekeepingCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaRecruithousekeepArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    NSString * idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetCollectDelete:idStr type:@"housekeep"];
}

#pragma mark ——————————————————————————————————————————————————————————租房删除
- (void)clickRentHouseDeleteBtn:(UIButton *)button cell:(MyCollectRentHouseCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaLeaseArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    NSString * idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetCollectDelete:idStr type:@"lease"];
}

#pragma mark ——————————————————————————————————————————————————————————买卖删除
- (void)clickBaySellDeleteBtn:(UIButton *)button cell:(MyCollecBaySellCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaGoodsArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    NSString * idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetCollectDelete:idStr type:@"goods"];
}

#pragma mark ——————————————————————————————————————————————————————————相约删除
- (void)clickOnADateDeleteBtn:(UIButton *)button cell:(MyCollectOnADateCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaFriendArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    NSString * idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetCollectDelete:idStr type:@"appointment"];
}

#pragma mark ——————————————————————————————————————————————————————————其他删除
- (void)clickElseDeleteBtn:(UIButton *)button cell:(MyCollectElseCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaElseArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    NSString * idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetCollectDelete:idStr type:@"else"];
}

#pragma mark ——————————————————————————————————————————————————————————婚恋删除
- (void)clickLivesDeleteBtn:(UIButton *)button cell:(MyCollectLivesCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaLivesArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    NSString * idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetCollectDelete:idStr type:@"live"];
}


#pragma mark 删除收藏
- (void)doGetCollectDelete:(NSString *)type_id type:(NSString *)type
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",CollectDelete];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"type_id":type_id,@"type":type};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"NewslLists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            mutaRecommendArr = [NSMutableArray array];
            MutaNoticeArr = [NSMutableArray array];
            MutaNewsArr = [NSMutableArray array];
            mutaRecruitmentArr = [NSMutableArray array];
            mutaRecruithousekeepArr = [NSMutableArray array];
            mutaLeaseArr = [NSMutableArray array];
            mutaGoodsArr = [NSMutableArray array];
            mutaFriendArr = [NSMutableArray array];
            mutaElseArr = [NSMutableArray array];
            mutaLivesArr = [NSMutableArray array];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self->page = 1;
            [self doGetCollectLists:type];
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


#pragma mark 获取收藏列表
- (void)doGetCollectLists:(NSString *)type
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",CollectLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"num":@"10",@"page":pageNum,@"type":type};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"RecommendRecommend_lists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            NSString * dataStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
            if ([dataStr isEqualToString:@"<null>"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                self.noDataView.hidden = NO;
                return ;
            }else{
                self.noDataView.hidden = YES;
                NSDictionary * dataDic = [responseObject objectForKey:@"data"];
                if ([type isEqualToString:@"recommend"]) {
                    self->recommendArr = [dataDic objectForKey:@"data"];
                    if (self->page == 1) {
                        self->mutaRecommendArr  = [NSMutableArray arrayWithArray:self->recommendArr];
                        NSLog(@"mutaRecommendArr ====%@",self->mutaRecommendArr);
                    }else{
                        [self->mutaRecommendArr addObjectsFromArray:self->recommendArr];
                        NSLog(@"mutaRecommendArr ====%@",self->mutaRecommendArr);
                    }
                }else if ([type isEqualToString:@"notice"]){
                    self->noticeArr = [dataDic objectForKey:@"data"];
                    if (self->page == 1) {
                        self->MutaNoticeArr  = [NSMutableArray arrayWithArray:self->noticeArr];
                        NSLog(@"MutaNoticeArr ====%@",self->MutaNoticeArr);
                    }else{
                        [self->MutaNoticeArr addObjectsFromArray:self->noticeArr];
                        NSLog(@"MutaNoticeArr ====%@",self->MutaNoticeArr);
                    }
                }else if ([type isEqualToString:@"staff"]){
                    self->recruitmentArr = [dataDic objectForKey:@"data"];
                    if (self->page == 1) {
                        self->mutaRecruitmentArr  = [NSMutableArray arrayWithArray:self->recruitmentArr];
                        NSLog(@"mutaRecruitmentArr ====%@",self->mutaRecruitmentArr);
                    }else{
                        [self->mutaRecruitmentArr addObjectsFromArray:self->recruitmentArr];
                        NSLog(@"mutaRecruitmentArr ====%@",self->mutaRecruitmentArr);
                    }
                }else if ([type isEqualToString:@"news"]){
                    self->newsArr = [dataDic objectForKey:@"data"];
                    if (self->page == 1) {
                        self->MutaNewsArr  = [NSMutableArray arrayWithArray:self->newsArr];
                        NSLog(@"MutaNewsArr ====%@",self->MutaNewsArr);
                    }else{
                        [self->MutaNewsArr addObjectsFromArray:self->newsArr];
                        NSLog(@"MutaNewsArr ====%@",self->MutaNewsArr);
                    }
                }else if ([type isEqualToString:@"housekeep"]){
                    self->recruithousekeepArr = [dataDic objectForKey:@"data"];
                    if (self->page == 1) {
                        self->mutaRecruithousekeepArr  = [NSMutableArray arrayWithArray:self->recruithousekeepArr];
                        NSLog(@"mutaRecruithousekeepArr ====%@",self->mutaRecruithousekeepArr);
                    }else{
                        [self->mutaRecruitmentArr addObjectsFromArray:self->recruithousekeepArr];
                        NSLog(@"mutaRecruithousekeepArr ====%@",self->mutaRecruithousekeepArr);
                    }
                }else if ([type isEqualToString:@"lease"]){
                    self->leaseArr = [dataDic objectForKey:@"data"];
                    if (self->page == 1) {
                        self->mutaLeaseArr  = [NSMutableArray arrayWithArray:self->leaseArr];
                        NSLog(@"mutaLeaseArr ====%@",self->mutaLeaseArr);
                    }else{
                        [self->mutaLeaseArr addObjectsFromArray:self->leaseArr];
                        NSLog(@"mutaLeaseArr ====%@",self->mutaLeaseArr);
                    }
                }else if ([type isEqualToString:@"goods"]){
                    self->goodsArr = [dataDic objectForKey:@"data"];
                    if (self->page == 1) {
                        self->mutaGoodsArr  = [NSMutableArray arrayWithArray:self->goodsArr];
                        NSLog(@"mutaGoodsArr ====%@",self->mutaGoodsArr);
                    }else{
                        [self->mutaGoodsArr addObjectsFromArray:self->goodsArr];
                        NSLog(@"mutaGoodsArr ====%@",self->mutaGoodsArr);
                    }
                }else if ([type isEqualToString:@"appointment"]){
                    self->friendArr = [dataDic objectForKey:@"data"];
                    if (self->page == 1) {
                        self->mutaFriendArr  = [NSMutableArray arrayWithArray:self->friendArr];
                        NSLog(@"mutaFriendArr ====%@",self->mutaFriendArr);
                    }else{
                        [self->mutaFriendArr addObjectsFromArray:self->friendArr];
                        NSLog(@"mutaFriendArr ====%@",self->mutaFriendArr);
                    }
                }else if ([type isEqualToString:@"live"]){
                    self->LivesArr = [dataDic objectForKey:@"data"];
                    if (self->page == 1) {
                        self->mutaLivesArr  = [NSMutableArray arrayWithArray:self->LivesArr];
                        NSLog(@"mutaLivesArr ====%@",self->mutaLivesArr);
                    }else{
                        [self->mutaLivesArr addObjectsFromArray:self->LivesArr];
                        NSLog(@"mutaLivesArr ====%@",self->mutaLivesArr);
                    }
                }else if ([type isEqualToString:@"else"]){
                    self->elseArr = [dataDic objectForKey:@"data"];
                    if (self->page == 1) {
                        self->mutaElseArr  = [NSMutableArray arrayWithArray:self->elseArr];
                        NSLog(@"mutaElseArr ====%@",self->mutaElseArr);
                    }else{
                        [self->mutaElseArr addObjectsFromArray:self->elseArr];
                        NSLog(@"mutaElseArr ====%@",self->mutaElseArr);
                    }
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
