//
//  TwoViewController.m
//  KBTabbarController
//
//  Created by kangbing on 16/5/31.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "TwoViewController.h"
#import "MarriageCell.h"
#import "HunLianDetailViewController.h"

@interface TwoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * noDataView;

@end

@implementation TwoViewController{
    
    //推荐列表
    NSMutableArray * mutaLivesArr;
    NSArray * liveArr;
    NSInteger  page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    mutaLivesArr = [NSMutableArray array];
    [self initNavigationView];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRootViewwController) name:@"click_PWLoginDismiss" object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)getRootViewwController{
    [self.tabBarController setSelectedIndex:0];
}

- (void)initNavigationView
{
    self.navigationView = [FlanceTools viewCreateWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT) BgColor:RGBA(238, 82, 82, 1) BgImage:nil];
    [self.view addSubview:self.navigationView];
    
    self.titleLabel = [FlanceTools labelCreateWithFrame:CGRectMake(SCREEN_WIDTH/2 - FitSizeH(100), STATUS_BAR_HEIGHT + FitSizeH(8), FitSizeW(200), FitSizeH(20)) Font:17.0f IsBold:YES Text:@"婚恋" Color:[UIColor whiteColor] Direction:NSTextAlignmentCenter];
    [self.navigationView addSubview: self.titleLabel];
}

- (void)initView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,CGRectGetMaxY(self.navigationView.frame), SCREEN_WIDTH, ScreenSizeHeight - CGRectGetMaxY(self.navigationView.frame) - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
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
    
    self.noDataView = [FlanceTools viewCreateWithFrame:CGRectMake(0, FitSizeH(178), SCREEN_WIDTH, FitSizeH(180)) BgColor:[UIColor whiteColor] BgImage:nil];
    [self.view addSubview:self.noDataView];
    self.noDataView.hidden = YES;
    
    UIImageView * noDataImageView = [FlanceTools imageViewCreateViewWithFrame:CGRectMake((SCREEN_WIDTH - FitSizeW(130)) / 2, FitSizeH(10), FitSizeW(130), FitSizeH(130)) ImageName:@"wuneir"];
    [self.noDataView addSubview:noDataImageView];
    
    UILabel * noDataLabel = [FlanceTools labelCreateWithFrame:CGRectMake(0, CGRectGetMaxY(noDataImageView.frame), SCREEN_WIDTH, FitSizeH(40)) Font:14 IsBold:NO Text:@"哎呀，这里还没有消息呢？" Color:RGBA(150, 150, 150, 1) Direction:NSTextAlignmentCenter];
    [self.noDataView addSubview:noDataLabel];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self->page = 1;
        [self doGetElsesLists];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadOnceData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadRecommendMoreData)];
    
}


- (void)loadRecommendMoreData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self->page ++;
    [self doGetElsesLists];
}

// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mutaLivesArr.count;
}
/**
 *  设置行高
 */
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return FitSizeH(130);
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSString * identifier= @"MarriageCell";
    MarriageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MarriageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dic = mutaLivesArr[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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


#pragma mark 婚恋列表
- (void)doGetElsesLists
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",Livelists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * userinfoDic = [userDefaultes valueForKey:@"userinfoDic"];
    NSString * tokenStr = [NSString stringWithFormat:@"%@",[userinfoDic objectForKey:@"token"]];
    NSString * cityStr = [NSString stringWithFormat:@"%@市",[userDefaultes stringForKey:@"currentCityStr"]];
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
            self->liveArr = [dataDic objectForKey:@"data"];
            if (self->page == 1) {
                self->mutaLivesArr  = [NSMutableArray arrayWithArray:self->liveArr];
                NSLog(@"mutaLivesArr ====%@",self->mutaLivesArr);
            }else{
                [self->mutaLivesArr addObjectsFromArray:self->liveArr];
                NSLog(@"mutaLivesArr ====%@",self->mutaLivesArr);
            }
            [self.tableView reloadData];
            if (self->mutaLivesArr.count != 0) {
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



@end
