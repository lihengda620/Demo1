//
//  SearchResultViewController.m
//  KBTabbarController
//
//  Created by 创胜网络 on 2019/6/26.
//  Copyright © 2019 kangbing. All rights reserved.
//

#import "SearchResultViewController.h"
#import "RecommendedCell.h"

@interface SearchResultViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * navigationView;
@property (nonatomic, strong) UITextField * searchView;
@property (nonatomic, strong) UIButton * searchBtn;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * noDataView;


@end

@implementation SearchResultViewController
{
    //推荐列表
    NSMutableArray * mutaRecommendArr;
    NSArray * recommendArr;
    NSInteger  page;
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRootViewwController) name:@"click_PWLoginDismiss" object:nil];
}

- (void)getRootViewwController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(245, 245, 245, 1.0);
    mutaRecommendArr = [NSMutableArray array];
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
    self.searchView.text = self.currentSearchStr;
    
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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,CGRectGetMaxY(self.navigationView.frame) + FitSizeH(2), SCREEN_WIDTH, ScreenSizeHeight - CGRectGetMaxY(self.navigationView.frame) - FitSizeH(2)) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    self.tableView.showsVerticalScrollIndicator = NO;
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
    
    UILabel * noDataLabel = [FlanceTools labelCreateWithFrame:CGRectMake(0, CGRectGetMaxY(noDataImageView.frame), SCREEN_WIDTH, FitSizeH(40)) Font:14 IsBold:NO Text:@"哎呀，这里没信息呢~" Color:RGBA(150, 150, 150, 1) Direction:NSTextAlignmentCenter];
    [self.noDataView addSubview:noDataLabel];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self->page = 1;
        [self doGetSearchLists:self.searchView.text];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadOnceData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadRecommendMoreData)];
}

- (void)loadRecommendMoreData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self->page ++;
    [self doGetSearchLists:self.searchView.text];
}

#pragma mark 点击键盘搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if (self.searchView.text.length > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self->mutaRecommendArr removeAllObjects];
        self->page = 1;
        [self doGetSearchLists:self.searchView.text];
    }else{
        [self showAlert:@"请输入关键字"];
    }
    
    return YES;
}

// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mutaRecommendArr.count;
}
/**
 *  设置行高
 */
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return FitSizeH(130);
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
        NSString * identifier= @"RecommendedCell";
        RecommendedCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[RecommendedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.dic = self->mutaRecommendArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSDictionary * dic = self->mutaRecommendArr[indexPath.row];
        WebViewController * navc = [[WebViewController alloc]init];
        navc.type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        navc.titleStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        navc.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self.navigationController pushViewController:navc animated:YES];
        
}

- (void)click_searchBtn
{
    if (self.searchView.text.length > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self->mutaRecommendArr removeAllObjects];
        self->page = 1;
        [self doGetSearchLists:self.searchView.text];
    }else{
        [self showAlert:@"请输入关键字"];
    }
    
}



#pragma mark 获取推荐列表
- (void)doGetSearchLists:(NSString *)search
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",SearchLists];
    //构造参数
    NSNumber  * pageNum = [NSNumber numberWithInteger:page];
    NSDictionary *parameters = @{@"num":@"10",@"page":pageNum,@"search":search};
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

#pragma mark 获取推荐详情
- (void)doGetRecommendRecommend_details:(NSString *)idStr type:(NSString *)type
{   //创建请求地址
    NSString *url=[NSString stringWithFormat:@"%@",RecommendRecommend_details];
    //构造参数
    NSDictionary *parameters = @{@"type":type,@"id":idStr};
    //AFN管理者调用get请求方法
    [[self sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"RecommendRecommend_details responseObject-->%@",[FlanceTools convertToJsonData:responseObject]);
        int code = [[responseObject valueForKey:@"code"]intValue];
        if (code == 200) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
