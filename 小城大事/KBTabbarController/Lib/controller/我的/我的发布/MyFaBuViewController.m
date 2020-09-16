//
//  MyFaBuViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/29.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "MyFaBuViewController.h"
#import "MyRecruitmentCell.h"
#import "MyHousekeepingCell.h"
#import "MyRentHouseCell.h"
#import "MyOnADateCell.h"
#import "MyElseCell.h"
#import "BuyingSellingCollectionCell.h"
#import "MyBuySellTableViewCell.h"
#import "MyLivesCell.h"

#import "RecruitmentDetailsViewController.h"
#import "HousekeepingDetailViewController.h"
#import "RentHouseDetailViewController.h"
#import "BaySellDetailViewController.h"
#import "FriendDetailViewController.h"
#import "ElseDetailViewController.h"
#import "HunLianDetailViewController.h"

#import "FaBuHunLianViewController.h"
#import "FaBuRecruitmentViewController.h"
#import "FaBuHousekeepingViewController.h"
#import "RentHouseViewController.h"
#import "FaBuBuySellViewController.h"
#import "FaBuElesViewController.h"
#import "FaBuDatingViewController.h"

@interface MyFaBuViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MyRecruitmentCellDelegate,MyHousekeepingCellDelegate,MyRentHouseCellDelegate,MyBuySellTableViewCellDelegate,MyOnADateCellDelegate,MyElseCellDelegate,MyLivesCellDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;

@property (nonatomic, strong) UIView * classifyView;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) UIView * classifyLineView;
@property (nonatomic, strong) UIView * radView;
@property (nonatomic, strong) UITableView * tableView;


@end

@implementation MyFaBuViewController
{
    UIButton * currentBtn;
    
    NSInteger  page;
    
    NSIndexPath *cellIndex;
    
    NSDictionary * categoryDic;
    
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
    NSArray * liveArr;
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
    mutaRecruitmentArr = [NSMutableArray array];
    mutaRecruithousekeepArr = [NSMutableArray array];
    mutaLeaseArr = [NSMutableArray array];
    mutaGoodsArr = [NSMutableArray array];
    mutaFriendArr = [NSMutableArray array];
    mutaElseArr = [NSMutableArray array];
    mutaLivesArr = [NSMutableArray array];
    [self initNavigationView];
    [self initView];
}

- (void)initNavigationView{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"我的发布" Color:RGBA(15, 15, 15, 1.0) Direction:NSTextAlignmentCenter];
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
    
    NSArray * classifyArr = @[@"招聘",@"家政",@"租房",@"买卖",@"相约",@"其他",@"婚恋"];
    currentBtn.tag = 1000;
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
    if (classifyArr.count <= 8) {
        self.classifyLineView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(46), SCREEN_WIDTH, FitSizeH(0.5)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
        [self.mainScrollView addSubview:self.classifyLineView];
    }else{
        self.classifyLineView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(46), classifyArr.count * (SCREEN_WIDTH / 8), FitSizeH(0.5)) BgColor:RGBA(220, 220, 220, 1.0) BgImage:nil];
        [self.mainScrollView addSubview:self.classifyLineView];
    }
    
    
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
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self->page = 1;
        [self doGetRecruitstaffLists];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadOnceData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadRecommendMoreData)];
    
}

- (void)loadRecommendMoreData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self->page ++;
    
    if (currentBtn.tag == 1000){
        self->page = 1;
        
        [self doGetRecruitstaffLists];
    }else if (currentBtn.tag == 1001){
        self->page = 1;
        [self doGetRecruithousekeepLists];
        
    }else if (currentBtn.tag == 1002){
        self->page = 1;
        [self doGetLeaseLists];
        
    }else if (currentBtn.tag == 1003) {
        //买卖
        self->page = 1;
        [self doGetGoodsLists];
        
    }else if (currentBtn.tag == 1004){
        self->page = 1;
        [self doGetAppointmentLists];
        
    }else if (currentBtn.tag == 1005){
        self->page = 1;
        [self doGetElsesLists];
        
    }else if (currentBtn.tag == 1006){
        self->page = 1;
        [self doGetLivelists];
        
    }
}

#pragma mark 点击顶部分类
- (void)click_classifyBtn:(UIButton *)sender
{
    NSArray * classifyArr = @[@"招聘",@"家政",@"租房",@"买卖",@"相约",@"其他",@"婚恋"];
    for (int i = 0; i < classifyArr.count; i ++) {
        UIButton * button = (UIButton *)[self.mainScrollView viewWithTag:1000 + i];
        button.selected = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    sender.selected = !sender.selected;
    currentBtn = sender;
    sender.titleLabel.font = [UIFont systemFontOfSize:17];
    
    if (sender.tag == 1000){
        self->page = 1;
        
        [self doGetRecruitstaffLists];
    }else if (sender.tag == 1001){
        self->page = 1;
        [self doGetRecruithousekeepLists];
        
    }else if (sender.tag == 1002){
        self->page = 1;
        [self doGetLeaseLists];
        
    }else if (sender.tag == 1003) {
        //买卖
        self->page = 1;
        [self doGetGoodsLists];
        
    }else if (sender.tag == 1004){
        self->page = 1;
        [self doGetAppointmentLists];
        
    }else if (sender.tag == 1005){
        self->page = 1;
        [self doGetElsesLists];
        
    }else if (sender.tag == 1006){
        self->page = 1;
        [self doGetLivelists];
        
    }
    
    [UIView animateWithDuration:0.24 animations:^{
        self.radView.frame = CGRectMake(CGRectGetMinX(sender.frame) + FitSizeW(10),CGRectGetMidY(self.classifyLineView.frame) - FitSizeH(2), FitSizeW(14), FitSizeH(4));
    }];
    [self.tableView reloadData];
}

// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (currentBtn.tag == 1000) {
        return self->mutaRecruitmentArr.count;
    }else if (currentBtn.tag == 1001) {
        return self->mutaRecruithousekeepArr.count;
    }else if (currentBtn.tag == 1002) {
        return self->mutaLeaseArr.count;
    }else if (currentBtn.tag == 1003) {
        return self->mutaGoodsArr.count;
    }else if (currentBtn.tag == 1004) {
        return self->mutaFriendArr.count;
    }else if (currentBtn.tag == 1005) {
        return self->mutaElseArr.count;
    }else{
        return self->mutaLivesArr.count;
    }
}
/**
 *  设置行高
 */
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (currentBtn.tag == 1000 ||currentBtn.tag == 1001 ||currentBtn.tag == 1004||currentBtn.tag == 1005) {
        return FitSizeH(170);
    }else{
        return FitSizeH(160);
    }
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (currentBtn.tag == 1000){
        NSString * identifier= @"MyRecruitmentCell";
        MyRecruitmentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyRecruitmentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.dic = self->mutaRecruitmentArr[indexPath.row];
        return cell;
    }else if (currentBtn.tag == 1001){
        
        NSString * identifier= @"MyHousekeepingCell";
        MyHousekeepingCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyHousekeepingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.dic = self->mutaRecruithousekeepArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (currentBtn.tag == 1002){
        NSString * identifier= @"MyRentHouseCell";
        MyRentHouseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyRentHouseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dic = self->mutaLeaseArr[indexPath.row];
        return cell;
    }else if (currentBtn.tag == 1003){
    
        NSString * identifier= @"MyBuySellTableViewCell";
        MyBuySellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyBuySellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.dic = self->mutaGoodsArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (currentBtn.tag == 1004){
        NSString * identifier= @"MyOnADateCell";
        MyOnADateCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyOnADateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.dic = self->mutaFriendArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (currentBtn.tag == 1005){
        
        NSString * identifier= @"MyElseCell";
        MyElseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyElseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.dic = self->mutaElseArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        NSString * identifier= @"MarriageCell";
        MyLivesCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyLivesCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
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
        NSDictionary * dic = self->mutaRecruitmentArr[indexPath.row];
        RecruitmentDetailsViewController * navc = [[RecruitmentDetailsViewController alloc]init];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
    }else if (currentBtn.tag == 1001){
        NSDictionary * dic = self->mutaRecruithousekeepArr[indexPath.row];
        HousekeepingDetailViewController * navc = [[HousekeepingDetailViewController alloc]init];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
    }else if (currentBtn.tag == 1002){
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
    }else if (currentBtn.tag == 1003){
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
    }else if (currentBtn.tag == 1004){
        NSDictionary * dic = self->mutaFriendArr[indexPath.row];
        FriendDetailViewController * navc = [[FriendDetailViewController alloc]init];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
    }else if (currentBtn.tag == 1005){
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
#pragma mark---------------------------------招聘
#pragma mark 点击招聘置顶
- (void)clickRecruitmentTopBtn:(UIButton *)button cell:(MyRecruitmentCell *)cell
{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaRecruitmentArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex:@"staff" idStr:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
}

#pragma mark 点击招聘编辑
- (void)clickRecruitmentEditBtn:(UIButton *)button cell:(MyRecruitmentCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaRecruitmentArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    FaBuRecruitmentViewController * navc = [[FaBuRecruitmentViewController alloc]init];
    navc.isEditStr = @"1";
    navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:navc animated:YES];
}

#pragma mark 点击招聘删除
- (void)clickRecruitmentDeleteBtn:(UIButton *)button cell:(MyRecruitmentCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaRecruitmentArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetStaffDelete:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
}

#pragma mark---------------------------------家政
#pragma mark 点击家政置顶
- (void)clickHousekeepingTopBtn:(UIButton *)button cell:(MyHousekeepingCell *)cell
{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaRecruithousekeepArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex:@"housekeep" idStr:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
}

#pragma mark 点击家政编辑
- (void)clickHousekeepingEditBtn:(UIButton *)button cell:(MyHousekeepingCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaRecruithousekeepArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    FaBuHousekeepingViewController * navc = [[FaBuHousekeepingViewController alloc]init];
    navc.isEditStr = @"1";
    navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:navc animated:YES];
}

#pragma mark 点击家政删除
- (void)clickHousekeepingDeleteBtn:(UIButton *)button cell:(MyHousekeepingCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaRecruithousekeepArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetHousekeepDelete:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
}


#pragma mark---------------------------------租房
#pragma mark 点击租房置顶
- (void)clickRentHouseTopBtn:(UIButton *)button cell:(MyRentHouseCell *)cell
{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaLeaseArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex:@"lease" idStr:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
}

#pragma mark 点击租房编辑
- (void)clickRentHouseEditBtn:(UIButton *)button cell:(MyRentHouseCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaLeaseArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    RentHouseViewController * navc = [[RentHouseViewController alloc]init];
    navc.isEditStr = @"1";
    navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:navc animated:YES];
    
}

#pragma mark 点击租房删除
- (void)clickRentHouseDeleteBtn:(UIButton *)button cell:(MyRentHouseCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaLeaseArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetLeaseDelete:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    
}

#pragma mark---------------------------------买卖
#pragma mark 点击买卖置顶
- (void)clickBuySellTopBtn:(UIButton *)button cell:(MyBuySellTableViewCell *)cell
{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaGoodsArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex:@"goods" idStr:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
}

#pragma mark 点击买卖编辑
- (void)clickBuySellEditBtn:(UIButton *)button cell:(MyBuySellTableViewCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaGoodsArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    FaBuBuySellViewController * navc = [[FaBuBuySellViewController alloc]init];
    navc.isEditStr = @"1";
    navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:navc animated:YES];
}

#pragma mark 点击买卖删除
- (void)clickBuySellDeleteBtn:(UIButton *)button cell:(MyBuySellTableViewCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaGoodsArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetGoodsDelete:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    
}

#pragma mark---------------------------------相约
#pragma mark 点击相约置顶
- (void)clickOnADateTopBtn:(UIButton *)button cell:(MyOnADateCell *)cell
{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaFriendArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex:@"appointment" idStr:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
}

#pragma mark 点击相约编辑
- (void)clickOnADatelEditBtn:(UIButton *)button cell:(MyOnADateCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaFriendArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    FaBuDatingViewController * navc = [[FaBuDatingViewController alloc]init];
    navc.isEditStr = @"1";
    navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:navc animated:YES];
}

#pragma mark 点击相约删除
- (void)clickOnADateDeleteBtn:(UIButton *)button cell:(MyOnADateCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaFriendArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetAppointmentDelete:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    
}


#pragma mark---------------------------------其他
#pragma mark 点击其他置顶
- (void)clickElseTopBtn:(UIButton *)button cell:(MyElseCell *)cell
{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaElseArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex:@"else" idStr:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
}

#pragma mark 点击其他编辑
- (void)clickElseEditBtn:(UIButton *)button cell:(MyElseCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaElseArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    FaBuElesViewController * navc = [[FaBuElesViewController alloc]init];
    navc.isEditStr = @"1";
    navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:navc animated:YES];
    
}

#pragma mark 点击其他删除
- (void)clickElseDeleteBtn:(UIButton *)button cell:(MyElseCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaElseArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetElseDelete:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    
}

#pragma mark---------------------------------婚恋
#pragma mark 点击婚恋置顶
- (void)clickLivesTopBtn:(UIButton *)button cell:(MyLivesCell *)cell
{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaLivesArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dogGetUserIndex:@"live" idStr:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
}

#pragma mark 点击其婚恋辑
- (void)clickLivesEditBtn:(UIButton *)button cell:(MyLivesCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaLivesArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    FaBuHunLianViewController * navc = [[FaBuHunLianViewController alloc]init];
    navc.isEditStr = @"1";
    navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:navc animated:YES];
}

#pragma mark 点击婚恋删除
- (void)clickLivesDeleteBtn:(UIButton *)button cell:(MyLivesCell *)cell{
    cellIndex = [_tableView indexPathForCell:cell];
    NSDictionary * dic = [self->mutaLivesArr objectAtIndex:cellIndex.row];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doGetLiveDelete:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
}



#pragma mark 查询价格
- (void)dogGetUserIndex:(NSString *)type idStr:(NSString *)idStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",UserIndex];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"type":type};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"UserIndex responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->categoryDic = [dataDic objectForKey:@"category"][0];
            //发布价格
            NSString * top_price = [NSString stringWithFormat:@"%@",[self->categoryDic objectForKey:@"top_price"]];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self doOrderCreate:top_price type_id:idStr type:type];
            
            
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

#pragma mark 创建订单
- (void)doOrderCreate:(NSString *)total_fee type_id:(NSString *)type_id type:(NSString *)type
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",OrderCreate];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"total_fee":total_fee,@"type":type,@"type_id":type_id,@"channel":@"3"};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"OrderCreate responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            NSString * order_no = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"order_no"]];
            PayViewController * navc = [[PayViewController alloc]init];
            navc.order_noStr = order_no;
            navc.total_feeStr = total_fee;
            navc.payType = @"2";
            
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
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"num":@"10",@"page":pageNum,@"user":@"1"};
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
                self->mutaRecruitmentArr  = [NSMutableArray arrayWithArray:self->recruitmentArr];
                NSLog(@"mutaRecruitmentArr ====%@",self->mutaRecruitmentArr);
            }else{
                [self->mutaRecruitmentArr addObjectsFromArray:self->recruitmentArr];
                NSLog(@"mutaRecruitmentArr ====%@",self->mutaRecruitmentArr);
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

#pragma mark 家政列表
- (void)doGetRecruithousekeepLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",RecruithousekeepLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"num":@"10",@"page":pageNum,@"user":@"1"};
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
                self->mutaRecruithousekeepArr  = [NSMutableArray arrayWithArray:self->recruithousekeepArr];
                NSLog(@"mutaRecruithousekeepArr ====%@",self->mutaRecruithousekeepArr);
            }else{
                [self->mutaRecruithousekeepArr addObjectsFromArray:self->recruithousekeepArr];
                NSLog(@"mutaRecruithousekeepArr ====%@",self->mutaRecruithousekeepArr);
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


#pragma mark 租房列表
- (void)doGetLeaseLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",LeaseLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"num":@"10",@"page":pageNum,@"user":@"1",};
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
                self->mutaLeaseArr  = [NSMutableArray arrayWithArray:self->leaseArr];
                NSLog(@"mutaLeaseArr ====%@",self->mutaLeaseArr);
            }else{
                [self->mutaLeaseArr addObjectsFromArray:self->leaseArr];
                NSLog(@"mutaLeaseArr ====%@",self->mutaLeaseArr);
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

#pragma mark 商品列表
- (void)doGetGoodsLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",GoodsLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"num":@"10",@"page":pageNum,@"user":@"1"};
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
                self->mutaGoodsArr  = [NSMutableArray arrayWithArray:self->goodsArr];
                NSLog(@"mutaGoodsArr ====%@",self->mutaGoodsArr);
            }else{
                [self->mutaGoodsArr addObjectsFromArray:self->goodsArr];
                NSLog(@"mutaGoodsArr ====%@",self->mutaGoodsArr);
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


#pragma mark 交友列表
- (void)doGetAppointmentLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",AppointmentLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"num":@"10",@"page":pageNum,@"user":@"1",};
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
                self->mutaFriendArr  = [NSMutableArray arrayWithArray:self->friendArr];
                NSLog(@"mutaGoodsArr ====%@",self->mutaFriendArr);
            }else{
                [self->mutaFriendArr addObjectsFromArray:self->friendArr];
                NSLog(@"mutaGoodsArr ====%@",self->mutaFriendArr);
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

#pragma mark 其他
- (void)doGetElsesLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",ElsesLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"num":@"10",@"page":pageNum,@"user":@"1"};
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
                self->mutaElseArr  = [NSMutableArray arrayWithArray:self->elseArr];
                NSLog(@"mutaElseArr ====%@",self->mutaElseArr);
            }else{
                [self->mutaElseArr addObjectsFromArray:self->elseArr];
                NSLog(@"mutaElseArr ====%@",self->mutaElseArr);
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

#pragma mark 婚恋列表
- (void)doGetLivelists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",Livelists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"num":@"10",@"page":pageNum,@"user":@"1"};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"Livelists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self->liveArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                self->mutaLivesArr  = [NSMutableArray arrayWithArray:self->liveArr];
                NSLog(@"mutaLivesArr ====%@",self->mutaLivesArr);
            }else{
                [self->mutaLivesArr addObjectsFromArray:self->liveArr];
                NSLog(@"mutaLivesArr ====%@",self->mutaLivesArr);
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



#pragma mark 招聘删除
- (void)doGetStaffDelete:(NSString *)idStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",StaffDelete];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"id":idStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"StaffDelete responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [mutaRecruitmentArr removeAllObjects];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self->page = 1;
            [self doGetRecruitstaffLists];
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

#pragma mark 家政删除
- (void)doGetHousekeepDelete:(NSString *)idStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",HousekeepDelete];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"id":idStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"Livelists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [mutaRecruithousekeepArr removeAllObjects];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self->page = 1;
            [self doGetRecruithousekeepLists];
            
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

#pragma mark 租房删除
- (void)doGetLeaseDelete:(NSString *)idStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",LeaseDelete];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"id":idStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"Livelists responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [mutaLeaseArr removeAllObjects];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self->page = 1;
            [self doGetLeaseLists];
            
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

#pragma mark 买卖删除
- (void)doGetGoodsDelete:(NSString *)idStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",GoodsDelete];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"id":idStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"GoodsDelete responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [mutaGoodsArr removeAllObjects];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self->page = 1;
            [self doGetGoodsLists];
            
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

#pragma mark 相约删除
- (void)doGetAppointmentDelete:(NSString *)idStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",AppointmentDelete];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"id":idStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"AppointmentDelete responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [mutaFriendArr removeAllObjects];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self->page = 1;
            [self doGetAppointmentLists];
            
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

#pragma mark 其他删除
- (void)doGetElseDelete:(NSString *)idStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",ElseDelete];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"id":idStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"ElseDelete responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [mutaElseArr removeAllObjects];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self->page = 1;
            [self doGetElsesLists];
            
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

#pragma mark 婚恋删除
- (void)doGetLiveDelete:(NSString *)idStr
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",LiveDelete];
    //构造参数
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSDictionary *parameters = @{@"token":tokenStr,@"id":idStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"ElseDelete responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [mutaLivesArr removeAllObjects];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self->page = 1;
            [self doGetLivelists];
            
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
